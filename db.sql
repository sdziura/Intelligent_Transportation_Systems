--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: gis; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA gis;


ALTER SCHEMA gis OWNER TO postgres;

--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: pgrouting; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgrouting WITH SCHEMA public;


--
-- Name: EXTENSION pgrouting; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgrouting IS 'pgRouting Extension';


--
-- Name: add_roads(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_roads()
    LANGUAGE sql
    AS $$
UPDATE avl_nis
SET road = COALESCE(nearest_road(geom), nearest_road_null(geom));
$$;


ALTER PROCEDURE public.add_roads() OWNER TO postgres;

--
-- Name: avg_all(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.avg_all(road_gid integer) RETURNS TABLE(_avg_speed numeric, _avg_speed_move numeric, _avg_rpm numeric, _avg_rpm_move numeric, _avg_mpg numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    SELECT avg_speed(road_gid), avg_speed_in_move(road_gid), avg_rpm(road_gid), avg_rpm_in_move(road_gid), avg_mpg(road_gid);
END;$$;


ALTER FUNCTION public.avg_all(road_gid integer) OWNER TO postgres;

--
-- Name: avg_mpg(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.avg_mpg(road_gid integer) RETURNS numeric
    LANGUAGE sql
    AS $$
SELECT COALESCE(ROUND(AVG(IOValue), 2), 0)
FROM obd_nis
WHERE road = road_gid AND IOTypeName = 'Fuel rate (MPG)'
$$;


ALTER FUNCTION public.avg_mpg(road_gid integer) OWNER TO postgres;

--
-- Name: avg_mpg_for_car(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.avg_mpg_for_car(car_vid integer) RETURNS numeric
    LANGUAGE sql
    AS $$
SELECT COALESCE(ROUND(AVG(IOValue), 2), 0)
FROM obd_nis
WHERE VID = car_vid AND IOTypeName = 'Fuel rate (MPG)'
$$;


ALTER FUNCTION public.avg_mpg_for_car(car_vid integer) OWNER TO postgres;

--
-- Name: avg_rpm(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.avg_rpm(road_gid integer) RETURNS numeric
    LANGUAGE sql
    AS $$
SELECT COALESCE(ROUND(AVG(IOValue), 2), 0)
FROM obd_nis
WHERE road = road_gid AND IOTypeName = 'RPM'
$$;


ALTER FUNCTION public.avg_rpm(road_gid integer) OWNER TO postgres;

--
-- Name: avg_rpm_in_move(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.avg_rpm_in_move(road_gid integer) RETURNS numeric
    LANGUAGE sql
    AS $$
SELECT COALESCE(ROUND(AVG(IOValue), 2), 0)
FROM obd_nis
WHERE road = road_gid AND IOTypeName = 'RPM' AND IOValue > 0
$$;


ALTER FUNCTION public.avg_rpm_in_move(road_gid integer) OWNER TO postgres;

--
-- Name: avg_speed(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.avg_speed(road_gid integer) RETURNS numeric
    LANGUAGE sql
    AS $$
SELECT COALESCE(ROUND(AVG(speed), 2), 0)
FROM avl_nis
WHERE road = road_gid
$$;


ALTER FUNCTION public.avg_speed(road_gid integer) OWNER TO postgres;

--
-- Name: avg_speed_in_move(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.avg_speed_in_move(road_gid integer) RETURNS numeric
    LANGUAGE sql
    AS $$
SELECT COALESCE(ROUND(AVG(speed), 2), 0)
FROM avl_nis
WHERE road = road_gid AND speed > 0
$$;


ALTER FUNCTION public.avg_speed_in_move(road_gid integer) OWNER TO postgres;

--
-- Name: avg_speed_on_time(integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.avg_speed_on_time(road_gid integer, date_and_time timestamp without time zone) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE 
ret NUMERIC;
BEGIN
    IF EXTRACT(dow FROM date_and_time) IN (0, 7)
    THEN
        SELECT COALESCE(ROUND(AVG(speed), 2), 0) INTO ret
        FROM avl_nis
        WHERE road = road_gid AND EXTRACT(dow FROM dtime) IN (0, 7) AND EXTRACT(HOUR FROM dtime) = EXTRACT(HOUR FROM date_and_time);
    ELSE
        SELECT COALESCE(ROUND(AVG(speed), 2), 0) INTO ret
        FROM avl_nis
        WHERE road = road_gid AND EXTRACT(dow FROM dtime) IN (1, 2, 3, 4, 5, 6) AND EXTRACT(HOUR FROM dtime) = EXTRACT(HOUR FROM date_and_time);
    END IF;

    IF ret = 0 THEN
        RETURN 40;
    ELSE
        RETURN ret;
    END IF;
END;
$$;


ALTER FUNCTION public.avg_speed_on_time(road_gid integer, date_and_time timestamp without time zone) OWNER TO postgres;

--
-- Name: cost_on_time(integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cost_on_time(noded_road_id integer, date_and_time timestamp without time zone) RETURNS numeric
    LANGUAGE sql
    AS $$
SELECT ST_Length(geom)/avg_speed_on_time(old_id, date_and_time) AS cost
FROM roads_nis2_noded
WHERE id = noded_road_id
$$;


ALTER FUNCTION public.cost_on_time(noded_road_id integer, date_and_time timestamp without time zone) OWNER TO postgres;

--
-- Name: cost_on_time(bigint, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cost_on_time(noded_road_id bigint, date_and_time timestamp without time zone) RETURNS numeric
    LANGUAGE sql
    AS $$
SELECT ST_Length(geom)/avg_speed_on_time(old_id, date_and_time) AS cost 
FROM roads_nis2_noded
WHERE id = noded_road_id
$$;


ALTER FUNCTION public.cost_on_time(noded_road_id bigint, date_and_time timestamp without time zone) OWNER TO postgres;

--
-- Name: find_path(integer, integer, timestamp without time zone, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_path(start_node integer, end_node integer, date_and_time timestamp without time zone DEFAULT (now())::timestamp without time zone, radius double precision DEFAULT 0.005) RETURNS TABLE(seq integer, path_seq integer, node bigint, edge bigint, cost double precision, agg_cost double precision)
    LANGUAGE plpgsql
    AS $$
DECLARE
poly GEOMETRY;
xx INTEGER;
BEGIN
    poly = find_polygon(start_node, end_node, radius);
    DROP TABLE IF EXISTS edge_table3;
    CREATE TEMP TABLE edge_table3 AS
    SELECT id, old_id, source, roads_nis2_noded.target AS target, 10000*ST_Length(geom) AS seg_length
    FROM roads_nis2_noded WHERE ST_Intersects(geom, poly);

    xx = COUNT(*) FROM edge_table3;
    RAISE NOTICE 'intersecting done (%)', xx;

    --new
    DROP TABLE IF EXISTS edge_old;
    CREATE TEMP TABLE edge_old AS
    SELECT DISTINCT(old_id) 
    FROM edge_table3;

    xx = COUNT(*) FROM edge_old;
    RAISE NOTICE 'intersecting done (%)', xx;

    DROP TABLE IF EXISTS speed_table;
    CREATE TEMP TABLE speed_table AS
    SELECT old_id, avg_speed_on_time(old_id, date_and_time) AS speed
    FROM edge_old;
    --new

    DROP TABLE IF EXISTS edge_table;
    CREATE TEMP TABLE edge_table AS
    SELECT id, source, target, seg_length/speed_table.speed AS cost
    FROM edge_table3
    LEFT JOIN speed_table
    ON edge_table3.old_id = speed_table.old_id;

    RETURN QUERY
    SELECT * FROM pgr_dijkstra(
    'SELECT *, cost  FROM edge_table', start_node, end_node);
END;
$$;


ALTER FUNCTION public.find_path(start_node integer, end_node integer, date_and_time timestamp without time zone, radius double precision) OWNER TO postgres;

--
-- Name: find_polygon(integer, integer, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_polygon(start_node integer, end_node integer, radius double precision) RETURNS public.geometry
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN ST_Buffer(
    ST_MakeLine( ARRAY( 
        SELECT geom FROM roads_nis2_noded WHERE id IN (
            SELECT edge FROM find_shortest_path(start_node, end_node)) ) ),
    radius );
END;
$$;


ALTER FUNCTION public.find_polygon(start_node integer, end_node integer, radius double precision) OWNER TO postgres;

--
-- Name: find_shortest_path(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_shortest_path(start_node integer, end_node integer) RETURNS TABLE(seq integer, path_seq integer, node bigint, edge bigint, cost double precision, agg_cost double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DROP TABLE IF EXISTS edge_table2;
    CREATE TEMP TABLE edge_table2 AS
    SELECT id, source, roads_nis2_noded.target, ST_Length(geom) AS cost
    FROM roads_nis2_noded; 

    RETURN QUERY
    SELECT * FROM pgr_dijkstra(
    'SELECT *, cost  FROM edge_table2', start_node, end_node);
END;
$$;


ALTER FUNCTION public.find_shortest_path(start_node integer, end_node integer) OWNER TO postgres;

--
-- Name: find_shortest_path(integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_shortest_path(start_node integer, end_node integer, date_and_time timestamp without time zone) RETURNS TABLE(seq integer, path_seq integer, node bigint, edge bigint, cost double precision, agg_cost double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    CREATE TEMP TABLE edge_table AS
    SELECT id, source, roads_nis2_noded.target, ST_Length(geom) 
    FROM roads_nis2_noded;

    RETURN QUERY
    SELECT * FROM pgr_dijkstra(
    edge_table, start_node, end_node);
END;
$$;


ALTER FUNCTION public.find_shortest_path(start_node integer, end_node integer, date_and_time timestamp without time zone) OWNER TO postgres;

--
-- Name: nearest_point(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.nearest_point(p public.geometry) RETURNS public.geometry
    LANGUAGE plpgsql
    AS $$
DECLARE new_p geometry;
BEGIN
    
    SELECT ST_ClosestPoint(geom, p) as closest_point_on_line
    INTO new_p
    FROM gis_osm_roads_free_1
    WHERE ST_Distance(p, geom) IS NOT NULL 
    ORDER BY ST_Distance(p, geom)
    LIMIT 1;
    RETURN new_p;

END;
$$;


ALTER FUNCTION public.nearest_point(p public.geometry) OWNER TO postgres;

--
-- Name: nearest_road(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.nearest_road(p public.geometry) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE new_p integer;
BEGIN
    
    SELECT gid as closest_road
    INTO new_p
    FROM roads_nis
    WHERE p && geom AND ST_Distance(p, geom) IS NOT NULL 
    ORDER BY ST_Distance(p, geom)
    LIMIT 1;
    RETURN new_p;

END;
$$;


ALTER FUNCTION public.nearest_road(p public.geometry) OWNER TO postgres;

--
-- Name: nearest_road_null(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.nearest_road_null(p public.geometry) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE new_p integer;
BEGIN
    
    SELECT gid as closest_road
    INTO new_p
    FROM roads_nis
    WHERE ST_Distance(p, geom) IS NOT NULL 
    ORDER BY ST_Distance(p, geom)
    LIMIT 1;
    RETURN new_p;

END;
$$;


ALTER FUNCTION public.nearest_road_null(p public.geometry) OWNER TO postgres;

--
-- Name: parking(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.parking(car_vid integer) RETURNS integer
    LANGUAGE sql
    AS $$
SELECT road
FROM obd_nis
WHERE VID = car_vid AND IOTypeName = 'Ignition' AND IOValue = 0
GROUP BY road
ORDER BY COUNT(IOValue) DESC
$$;


ALTER FUNCTION public.parking(car_vid integer) OWNER TO postgres;

--
-- Name: stops_at_road(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stops_at_road(road_gid integer) RETURNS integer
    LANGUAGE sql
    AS $$
SELECT COALESCE(COUNT(*), 0)
FROM avl_nis
WHERE road = road_gid AND speed = 0
$$;


ALTER FUNCTION public.stops_at_road(road_gid integer) OWNER TO postgres;

--
-- Name: stops_at_road_for_car(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stops_at_road_for_car(road_gid integer, car_vid integer) RETURNS integer
    LANGUAGE sql
    AS $$
SELECT COALESCE(COUNT(*), 0)
FROM avl_nis
WHERE road = road_gid AND speed = 0 AND VID = car_vid
$$;


ALTER FUNCTION public.stops_at_road_for_car(road_gid integer, car_vid integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: avl; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avl (
    gid integer NOT NULL,
    vid bigint,
    valid bigint,
    dtime character varying(24),
    lat numeric,
    lon numeric,
    speed numeric,
    course numeric,
    geom public.geometry(Point,3909),
    road integer
);


ALTER TABLE public.avl OWNER TO postgres;

--
-- Name: avl_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avl_backup (
    gid integer,
    vid bigint,
    valid bigint,
    dtime character varying(24),
    lat numeric,
    lon numeric,
    speed numeric,
    course numeric,
    geom public.geometry(Point,3909)
);


ALTER TABLE public.avl_backup OWNER TO postgres;

--
-- Name: avl_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.avl_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.avl_gid_seq OWNER TO postgres;

--
-- Name: avl_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.avl_gid_seq OWNED BY public.avl.gid;


--
-- Name: avl_nis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avl_nis (
    gid integer NOT NULL,
    vid bigint,
    valid bigint,
    dtime timestamp without time zone,
    lat numeric,
    lon numeric,
    speed numeric,
    course numeric,
    geom public.geometry(Point,3909),
    road integer
);


ALTER TABLE public.avl_nis OWNER TO postgres;

--
-- Name: avl_nis_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.avl_nis_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.avl_nis_gid_seq OWNER TO postgres;

--
-- Name: avl_nis_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.avl_nis_gid_seq OWNED BY public.avl_nis.gid;


--
-- Name: gis_osm_buildings_a_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_buildings_a_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    type character varying(20),
    geom public.geometry(MultiPolygon,3909)
);


ALTER TABLE public.gis_osm_buildings_a_free_1 OWNER TO postgres;

--
-- Name: gis_osm_buildings_a_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_buildings_a_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_buildings_a_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_buildings_a_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_buildings_a_free_1_gid_seq OWNED BY public.gis_osm_buildings_a_free_1.gid;


--
-- Name: gis_osm_landuse_a_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_landuse_a_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(MultiPolygon,3909)
);


ALTER TABLE public.gis_osm_landuse_a_free_1 OWNER TO postgres;

--
-- Name: gis_osm_landuse_a_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_landuse_a_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_landuse_a_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_landuse_a_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_landuse_a_free_1_gid_seq OWNED BY public.gis_osm_landuse_a_free_1.gid;


--
-- Name: gis_osm_natural_a_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_natural_a_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(MultiPolygon,3909)
);


ALTER TABLE public.gis_osm_natural_a_free_1 OWNER TO postgres;

--
-- Name: gis_osm_natural_a_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_natural_a_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_natural_a_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_natural_a_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_natural_a_free_1_gid_seq OWNED BY public.gis_osm_natural_a_free_1.gid;


--
-- Name: gis_osm_natural_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_natural_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(Point,3909)
);


ALTER TABLE public.gis_osm_natural_free_1 OWNER TO postgres;

--
-- Name: gis_osm_natural_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_natural_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_natural_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_natural_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_natural_free_1_gid_seq OWNED BY public.gis_osm_natural_free_1.gid;


--
-- Name: gis_osm_places_a_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_places_a_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    population bigint,
    name character varying(100),
    geom public.geometry(MultiPolygon,3909)
);


ALTER TABLE public.gis_osm_places_a_free_1 OWNER TO postgres;

--
-- Name: gis_osm_places_a_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_places_a_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_places_a_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_places_a_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_places_a_free_1_gid_seq OWNED BY public.gis_osm_places_a_free_1.gid;


--
-- Name: gis_osm_places_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_places_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    population bigint,
    name character varying(100),
    geom public.geometry(Point,3909)
);


ALTER TABLE public.gis_osm_places_free_1 OWNER TO postgres;

--
-- Name: gis_osm_places_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_places_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_places_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_places_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_places_free_1_gid_seq OWNED BY public.gis_osm_places_free_1.gid;


--
-- Name: gis_osm_pofw_a_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_pofw_a_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(MultiPolygon,3909)
);


ALTER TABLE public.gis_osm_pofw_a_free_1 OWNER TO postgres;

--
-- Name: gis_osm_pofw_a_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_pofw_a_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_pofw_a_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_pofw_a_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_pofw_a_free_1_gid_seq OWNED BY public.gis_osm_pofw_a_free_1.gid;


--
-- Name: gis_osm_pofw_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_pofw_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(Point,3909)
);


ALTER TABLE public.gis_osm_pofw_free_1 OWNER TO postgres;

--
-- Name: gis_osm_pofw_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_pofw_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_pofw_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_pofw_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_pofw_free_1_gid_seq OWNED BY public.gis_osm_pofw_free_1.gid;


--
-- Name: gis_osm_pois_a_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_pois_a_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(MultiPolygon,3909)
);


ALTER TABLE public.gis_osm_pois_a_free_1 OWNER TO postgres;

--
-- Name: gis_osm_pois_a_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_pois_a_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_pois_a_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_pois_a_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_pois_a_free_1_gid_seq OWNED BY public.gis_osm_pois_a_free_1.gid;


--
-- Name: gis_osm_pois_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_pois_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(Point,3909)
);


ALTER TABLE public.gis_osm_pois_free_1 OWNER TO postgres;

--
-- Name: gis_osm_pois_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_pois_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_pois_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_pois_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_pois_free_1_gid_seq OWNED BY public.gis_osm_pois_free_1.gid;


--
-- Name: gis_osm_railways_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_railways_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    layer double precision,
    bridge character varying(1),
    tunnel character varying(1),
    geom public.geometry(MultiLineString,3909)
);


ALTER TABLE public.gis_osm_railways_free_1 OWNER TO postgres;

--
-- Name: gis_osm_railways_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_railways_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_railways_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_railways_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_railways_free_1_gid_seq OWNED BY public.gis_osm_railways_free_1.gid;


--
-- Name: gis_osm_roads_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_roads_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    ref character varying(20),
    oneway character varying(1),
    maxspeed smallint,
    layer double precision,
    bridge character varying(1),
    tunnel character varying(1),
    geom public.geometry(MultiLineString,3909)
);


ALTER TABLE public.gis_osm_roads_free_1 OWNER TO postgres;

--
-- Name: gis_osm_roads_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_roads_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_roads_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_roads_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_roads_free_1_gid_seq OWNED BY public.gis_osm_roads_free_1.gid;


--
-- Name: gis_osm_traffic_a_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_traffic_a_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(MultiPolygon,3909)
);


ALTER TABLE public.gis_osm_traffic_a_free_1 OWNER TO postgres;

--
-- Name: gis_osm_traffic_a_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_traffic_a_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_traffic_a_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_traffic_a_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_traffic_a_free_1_gid_seq OWNED BY public.gis_osm_traffic_a_free_1.gid;


--
-- Name: gis_osm_traffic_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_traffic_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(Point,3909)
);


ALTER TABLE public.gis_osm_traffic_free_1 OWNER TO postgres;

--
-- Name: gis_osm_traffic_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_traffic_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_traffic_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_traffic_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_traffic_free_1_gid_seq OWNED BY public.gis_osm_traffic_free_1.gid;


--
-- Name: gis_osm_transport_a_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_transport_a_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(MultiPolygon,3909)
);


ALTER TABLE public.gis_osm_transport_a_free_1 OWNER TO postgres;

--
-- Name: gis_osm_transport_a_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_transport_a_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_transport_a_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_transport_a_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_transport_a_free_1_gid_seq OWNED BY public.gis_osm_transport_a_free_1.gid;


--
-- Name: gis_osm_transport_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_transport_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(Point,3909)
);


ALTER TABLE public.gis_osm_transport_free_1 OWNER TO postgres;

--
-- Name: gis_osm_transport_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_transport_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_transport_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_transport_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_transport_free_1_gid_seq OWNED BY public.gis_osm_transport_free_1.gid;


--
-- Name: gis_osm_water_a_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_water_a_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    name character varying(100),
    geom public.geometry(MultiPolygon,3909)
);


ALTER TABLE public.gis_osm_water_a_free_1 OWNER TO postgres;

--
-- Name: gis_osm_water_a_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_water_a_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_water_a_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_water_a_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_water_a_free_1_gid_seq OWNED BY public.gis_osm_water_a_free_1.gid;


--
-- Name: gis_osm_waterways_free_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gis_osm_waterways_free_1 (
    gid integer NOT NULL,
    osm_id character varying(10),
    code smallint,
    fclass character varying(28),
    width integer,
    name character varying(100),
    geom public.geometry(MultiLineString,3909)
);


ALTER TABLE public.gis_osm_waterways_free_1 OWNER TO postgres;

--
-- Name: gis_osm_waterways_free_1_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gis_osm_waterways_free_1_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gis_osm_waterways_free_1_gid_seq OWNER TO postgres;

--
-- Name: gis_osm_waterways_free_1_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gis_osm_waterways_free_1_gid_seq OWNED BY public.gis_osm_waterways_free_1.gid;


--
-- Name: obd; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.obd (
    gid integer NOT NULL,
    vid bigint,
    dtime character varying(24),
    iotypename character varying(254),
    iovalue numeric
);


ALTER TABLE public.obd OWNER TO postgres;

--
-- Name: obd_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.obd_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obd_gid_seq OWNER TO postgres;

--
-- Name: obd_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.obd_gid_seq OWNED BY public.obd.gid;


--
-- Name: obd_nis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.obd_nis (
    gid integer,
    vid bigint,
    dtime character varying(24),
    iotypename character varying(254),
    iovalue numeric,
    road integer
);


ALTER TABLE public.obd_nis OWNER TO postgres;

--
-- Name: roads_nis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roads_nis (
    gid integer NOT NULL,
    __gid bigint,
    osm_id character varying(10),
    code bigint,
    fclass character varying(28),
    name character varying(100),
    ref character varying(20),
    oneway character varying(1),
    maxspeed bigint,
    layer numeric,
    bridge character varying(1),
    tunnel character varying(1),
    geom public.geometry(MultiLineString,3909)
);


ALTER TABLE public.roads_nis OWNER TO postgres;

--
-- Name: roads_nis2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roads_nis2 (
    gid integer,
    __gid bigint,
    osm_id character varying(10),
    code bigint,
    fclass character varying(28),
    name character varying(100),
    ref character varying(20),
    oneway character varying(1),
    maxspeed bigint,
    layer numeric,
    bridge character varying(1),
    tunnel character varying(1),
    geom public.geometry
);


ALTER TABLE public.roads_nis2 OWNER TO postgres;

--
-- Name: roads_nis2_noded; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roads_nis2_noded (
    id bigint NOT NULL,
    old_id integer,
    sub_id integer,
    source bigint,
    target bigint,
    geom public.geometry(LineString,3909)
);


ALTER TABLE public.roads_nis2_noded OWNER TO postgres;

--
-- Name: roads_nis2_noded_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roads_nis2_noded_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roads_nis2_noded_id_seq OWNER TO postgres;

--
-- Name: roads_nis2_noded_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roads_nis2_noded_id_seq OWNED BY public.roads_nis2_noded.id;


--
-- Name: roads_nis2_noded_vertices_pgr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roads_nis2_noded_vertices_pgr (
    id bigint NOT NULL,
    cnt integer,
    chk integer,
    ein integer,
    eout integer,
    the_geom public.geometry(Point,3909)
);


ALTER TABLE public.roads_nis2_noded_vertices_pgr OWNER TO postgres;

--
-- Name: roads_nis2_noded_vertices_pgr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roads_nis2_noded_vertices_pgr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roads_nis2_noded_vertices_pgr_id_seq OWNER TO postgres;

--
-- Name: roads_nis2_noded_vertices_pgr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roads_nis2_noded_vertices_pgr_id_seq OWNED BY public.roads_nis2_noded_vertices_pgr.id;


--
-- Name: roads_nis_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roads_nis_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roads_nis_gid_seq OWNER TO postgres;

--
-- Name: roads_nis_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roads_nis_gid_seq OWNED BY public.roads_nis.gid;


--
-- Name: avl gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avl ALTER COLUMN gid SET DEFAULT nextval('public.avl_gid_seq'::regclass);


--
-- Name: avl_nis gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avl_nis ALTER COLUMN gid SET DEFAULT nextval('public.avl_nis_gid_seq'::regclass);


--
-- Name: gis_osm_buildings_a_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_buildings_a_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_buildings_a_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_landuse_a_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_landuse_a_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_landuse_a_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_natural_a_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_natural_a_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_natural_a_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_natural_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_natural_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_natural_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_places_a_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_places_a_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_places_a_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_places_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_places_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_places_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_pofw_a_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_pofw_a_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_pofw_a_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_pofw_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_pofw_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_pofw_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_pois_a_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_pois_a_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_pois_a_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_pois_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_pois_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_pois_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_railways_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_railways_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_railways_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_roads_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_roads_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_roads_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_traffic_a_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_traffic_a_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_traffic_a_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_traffic_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_traffic_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_traffic_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_transport_a_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_transport_a_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_transport_a_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_transport_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_transport_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_transport_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_water_a_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_water_a_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_water_a_free_1_gid_seq'::regclass);


--
-- Name: gis_osm_waterways_free_1 gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_waterways_free_1 ALTER COLUMN gid SET DEFAULT nextval('public.gis_osm_waterways_free_1_gid_seq'::regclass);


--
-- Name: obd gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obd ALTER COLUMN gid SET DEFAULT nextval('public.obd_gid_seq'::regclass);


--
-- Name: roads_nis gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roads_nis ALTER COLUMN gid SET DEFAULT nextval('public.roads_nis_gid_seq'::regclass);


--
-- Name: roads_nis2_noded id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roads_nis2_noded ALTER COLUMN id SET DEFAULT nextval('public.roads_nis2_noded_id_seq'::regclass);


--
-- Name: roads_nis2_noded_vertices_pgr id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roads_nis2_noded_vertices_pgr ALTER COLUMN id SET DEFAULT nextval('public.roads_nis2_noded_vertices_pgr_id_seq'::regclass);


--
-- Name: avl_nis avl_nis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avl_nis
    ADD CONSTRAINT avl_nis_pkey PRIMARY KEY (gid);


--
-- Name: avl avl_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avl
    ADD CONSTRAINT avl_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_buildings_a_free_1 gis_osm_buildings_a_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_buildings_a_free_1
    ADD CONSTRAINT gis_osm_buildings_a_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_landuse_a_free_1 gis_osm_landuse_a_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_landuse_a_free_1
    ADD CONSTRAINT gis_osm_landuse_a_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_natural_a_free_1 gis_osm_natural_a_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_natural_a_free_1
    ADD CONSTRAINT gis_osm_natural_a_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_natural_free_1 gis_osm_natural_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_natural_free_1
    ADD CONSTRAINT gis_osm_natural_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_places_a_free_1 gis_osm_places_a_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_places_a_free_1
    ADD CONSTRAINT gis_osm_places_a_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_places_free_1 gis_osm_places_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_places_free_1
    ADD CONSTRAINT gis_osm_places_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_pofw_a_free_1 gis_osm_pofw_a_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_pofw_a_free_1
    ADD CONSTRAINT gis_osm_pofw_a_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_pofw_free_1 gis_osm_pofw_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_pofw_free_1
    ADD CONSTRAINT gis_osm_pofw_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_pois_a_free_1 gis_osm_pois_a_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_pois_a_free_1
    ADD CONSTRAINT gis_osm_pois_a_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_pois_free_1 gis_osm_pois_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_pois_free_1
    ADD CONSTRAINT gis_osm_pois_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_railways_free_1 gis_osm_railways_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_railways_free_1
    ADD CONSTRAINT gis_osm_railways_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_roads_free_1 gis_osm_roads_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_roads_free_1
    ADD CONSTRAINT gis_osm_roads_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_traffic_a_free_1 gis_osm_traffic_a_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_traffic_a_free_1
    ADD CONSTRAINT gis_osm_traffic_a_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_traffic_free_1 gis_osm_traffic_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_traffic_free_1
    ADD CONSTRAINT gis_osm_traffic_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_transport_a_free_1 gis_osm_transport_a_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_transport_a_free_1
    ADD CONSTRAINT gis_osm_transport_a_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_transport_free_1 gis_osm_transport_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_transport_free_1
    ADD CONSTRAINT gis_osm_transport_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_water_a_free_1 gis_osm_water_a_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_water_a_free_1
    ADD CONSTRAINT gis_osm_water_a_free_1_pkey PRIMARY KEY (gid);


--
-- Name: gis_osm_waterways_free_1 gis_osm_waterways_free_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gis_osm_waterways_free_1
    ADD CONSTRAINT gis_osm_waterways_free_1_pkey PRIMARY KEY (gid);


--
-- Name: obd obd_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obd
    ADD CONSTRAINT obd_pkey PRIMARY KEY (gid);


--
-- Name: roads_nis2_noded roads_nis2_noded_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roads_nis2_noded
    ADD CONSTRAINT roads_nis2_noded_pkey PRIMARY KEY (id);


--
-- Name: roads_nis2_noded_vertices_pgr roads_nis2_noded_vertices_pgr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roads_nis2_noded_vertices_pgr
    ADD CONSTRAINT roads_nis2_noded_vertices_pgr_pkey PRIMARY KEY (id);


--
-- Name: roads_nis roads_nis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roads_nis
    ADD CONSTRAINT roads_nis_pkey PRIMARY KEY (gid);


--
-- Name: avl_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX avl_geom_idx ON public.avl USING gist (geom);


--
-- Name: avl_nis_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX avl_nis_geom_idx ON public.avl_nis USING gist (geom);


--
-- Name: gis_osm_buildings_a_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_buildings_a_free_1_geom_idx ON public.gis_osm_buildings_a_free_1 USING gist (geom);


--
-- Name: gis_osm_landuse_a_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_landuse_a_free_1_geom_idx ON public.gis_osm_landuse_a_free_1 USING gist (geom);


--
-- Name: gis_osm_natural_a_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_natural_a_free_1_geom_idx ON public.gis_osm_natural_a_free_1 USING gist (geom);


--
-- Name: gis_osm_natural_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_natural_free_1_geom_idx ON public.gis_osm_natural_free_1 USING gist (geom);


--
-- Name: gis_osm_places_a_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_places_a_free_1_geom_idx ON public.gis_osm_places_a_free_1 USING gist (geom);


--
-- Name: gis_osm_places_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_places_free_1_geom_idx ON public.gis_osm_places_free_1 USING gist (geom);


--
-- Name: gis_osm_pofw_a_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_pofw_a_free_1_geom_idx ON public.gis_osm_pofw_a_free_1 USING gist (geom);


--
-- Name: gis_osm_pofw_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_pofw_free_1_geom_idx ON public.gis_osm_pofw_free_1 USING gist (geom);


--
-- Name: gis_osm_pois_a_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_pois_a_free_1_geom_idx ON public.gis_osm_pois_a_free_1 USING gist (geom);


--
-- Name: gis_osm_pois_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_pois_free_1_geom_idx ON public.gis_osm_pois_free_1 USING gist (geom);


--
-- Name: gis_osm_railways_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_railways_free_1_geom_idx ON public.gis_osm_railways_free_1 USING gist (geom);


--
-- Name: gis_osm_roads_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_roads_free_1_geom_idx ON public.gis_osm_roads_free_1 USING gist (geom);


--
-- Name: gis_osm_traffic_a_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_traffic_a_free_1_geom_idx ON public.gis_osm_traffic_a_free_1 USING gist (geom);


--
-- Name: gis_osm_traffic_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_traffic_free_1_geom_idx ON public.gis_osm_traffic_free_1 USING gist (geom);


--
-- Name: gis_osm_transport_a_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_transport_a_free_1_geom_idx ON public.gis_osm_transport_a_free_1 USING gist (geom);


--
-- Name: gis_osm_transport_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_transport_free_1_geom_idx ON public.gis_osm_transport_free_1 USING gist (geom);


--
-- Name: gis_osm_water_a_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_water_a_free_1_geom_idx ON public.gis_osm_water_a_free_1 USING gist (geom);


--
-- Name: gis_osm_waterways_free_1_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gis_osm_waterways_free_1_geom_idx ON public.gis_osm_waterways_free_1 USING gist (geom);


--
-- Name: roads_nis2_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roads_nis2_geom_idx ON public.roads_nis2 USING gist (geom);


--
-- Name: roads_nis2_gid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roads_nis2_gid_idx ON public.roads_nis2 USING btree (gid);


--
-- Name: roads_nis2_noded_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roads_nis2_noded_geom_idx ON public.roads_nis2_noded USING gist (geom);


--
-- Name: roads_nis2_noded_source_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roads_nis2_noded_source_idx ON public.roads_nis2_noded USING btree (source);


--
-- Name: roads_nis2_noded_target_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roads_nis2_noded_target_idx ON public.roads_nis2_noded USING btree (target);


--
-- Name: roads_nis2_noded_vertices_pgr_the_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roads_nis2_noded_vertices_pgr_the_geom_idx ON public.roads_nis2_noded_vertices_pgr USING gist (the_geom);


--
-- Name: roads_nis_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roads_nis_geom_idx ON public.roads_nis USING gist (geom);


--
-- Name: avl_nis avl_nis_road_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avl_nis
    ADD CONSTRAINT avl_nis_road_fkey FOREIGN KEY (road) REFERENCES public.roads_nis(gid);


--
-- Name: avl avl_road_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avl
    ADD CONSTRAINT avl_road_fkey FOREIGN KEY (road) REFERENCES public.gis_osm_roads_free_1(gid);


--
-- Name: obd_nis obd_nis_road_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obd_nis
    ADD CONSTRAINT obd_nis_road_fkey FOREIGN KEY (road) REFERENCES public.roads_nis(gid);


--
-- PostgreSQL database dump complete
--

