using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Intelligent_Transportation
{
    public partial class RoadInfoForm : Form
    {
        DataAccess da = new DataAccess();
        string chosenRoadId;
        public RoadInfoForm()
        {
            InitializeComponent();
        }

        private void RoadInfoForm_Load(object sender, EventArgs e)
        {
            roadsListBox.DataSource = da.GetColumn("DISTINCT(road) FROM avl_nis ORDER BY road ASC");
        }

        private void roadsListBox_SelectedValueChanged(object sender, EventArgs e)
        {
            chosenRoadId = roadsListBox.SelectedValue.ToString();
        }

        private void checkAvgButton_Click(object sender, EventArgs e)
        {
            roadIdTxtBox.Text = chosenRoadId;
            List<string> avgValues = da.GetRow($"* FROM avg_all({chosenRoadId})");
            avgSpeedTxtBox.Text = avgValues[0];
            avgSpeedMoveTxtBox.Text = avgValues[1];
            avgRpmTxtBox.Text = avgValues[2];
            avgRpmMoveTxtBox.Text = avgValues[3];
            avgMpgTxtBox.Text = avgValues[4];
        }
    }
}
