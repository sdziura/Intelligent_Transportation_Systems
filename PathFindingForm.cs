using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Intelligent_Transportation
{
    public partial class PathFindingForm : Form
    {
        DataAccess da = new DataAccess();
        string fromRoadId;
        string toRoadId;
        string dateTime;
        string radius;

        public PathFindingForm()
        {
            InitializeComponent();
        }

        private void PathFindingForm_Load(object sender, EventArgs e)
        {
            toListBox.DataSource = da.GetColumn("DISTINCT(source) FROM roads_nis2_noded ORDER BY source ASC");
            fromListBox.DataSource = da.GetColumn("DISTINCT(source) FROM roads_nis2_noded ORDER BY source ASC");
        }

        private void checkAvgButton_Click(object sender, EventArgs e)
        {
            fromRoadTxtBox.Text = fromRoadId;
            toRoadTxtBox.Text = toRoadId;
            dateTime = dateTimePicker1.Value.ToString("yyyy-MM-dd HH:mm:ss");
            radius = radiusTxtBox.Text; 

            List<string> col = da.GetColumn($"* FROM find_path({fromRoadId}, {toRoadId}, '{dateTime}', {radius})", 3);
            pathListBox.DataSource = col;
        }

        private void fromListBox_SelectedValueChanged(object sender, EventArgs e)
        {
            fromRoadId = fromListBox.SelectedValue.ToString();
        }

        private void toListBox_SelectedValueChanged(object sender, EventArgs e)
        {
            toRoadId = toListBox.SelectedValue.ToString();
        }
    }
}
