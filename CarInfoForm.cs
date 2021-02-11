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
    public partial class CarInfoForm : Form
    {
        DataAccess da = new DataAccess();
        string chosenCarId;
        string chosenRoadId;
        public CarInfoForm()
        {
            InitializeComponent();
        }

        private void CarInfoForm_Load(object sender, EventArgs e)
        {
            carsListBox.DataSource = da.GetColumn("DISTINCT(vid) FROM avl_nis ORDER BY vid ASC");
            roadsListBox.DataSource = da.GetColumn("DISTINCT(road) FROM avl_nis ORDER BY road ASC");
        }

        private void carsListBox_SelectedValueChanged(object sender, EventArgs e)
        {
            chosenCarId = carsListBox.SelectedValue.ToString();
        }

        private void roadsListBox_SelectedValueChanged(object sender, EventArgs e)
        {
            chosenRoadId = roadsListBox.SelectedValue.ToString();
        }

        private void checkAvgButton_Click(object sender, EventArgs e)
        {
            roadIdTxtBox.Text = chosenRoadId;
            carIdTxtBox.Text = chosenCarId;

            stopsTxtBox.Text = da.GetRow($"* FROM  stops_at_road_for_car({chosenRoadId},{chosenCarId})")[0].ToString();
            stopsAllTxtBox.Text = da.GetRow($"* FROM  stops_at_road({chosenRoadId})")[0].ToString();
            avgMpgTxtBox.Text = da.GetRow($"* FROM  avg_mpg_for_car({chosenCarId})")[0].ToString();
        }
    }
}
