using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Intelligent_Transportation
{
    public class DataAccess
    {
        private string connectionString = "Server=localhost;Port=5432;User Id=postgres;Password=1234;Database=gis";
        private NpgsqlConnection connection;
        private NpgsqlCommand command;

        public DataAccess()
        {
            connection = new NpgsqlConnection(connectionString);
        }

        private DataTable Select(string query)
        {
            string fullQuery = @"SELECT " + query;
            DataTable dt = new DataTable();
            try
            {
                connection.Open();
                command = new NpgsqlCommand(fullQuery, connection);
                dt.Load(command.ExecuteReader());
                connection.Close();
            }
            catch(Exception ex)
            {
                connection.Close();
                MessageBox.Show("Error " + ex.Message);
            }
            return dt;
        }

        public List<string> GetColumn(string query, int col = 0)
        {
            return Select(query).AsEnumerable().Select(r => r[col].ToString()).ToList();
        }

        public List<string> GetRow(string query)
        {
            var dt = Select(query);
            return dt.AsEnumerable().First().ItemArray.Select(r => r.ToString()).ToList();
        }

    }
}
