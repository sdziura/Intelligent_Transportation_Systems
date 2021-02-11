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
    public partial class Form1 : Form
    {
        

        public Form1()
        {
            InitializeComponent();
        }

        private void RoadInfoButton_Click(object sender, EventArgs e)
        {
            var m = new RoadInfoForm();
            m.Show();
        }

        private void carInfoButton_Click(object sender, EventArgs e)
        {
            var m = new CarInfoForm();
            m.Show();
        }

        private void pathFindingButton_Click(object sender, EventArgs e)
        {
            var m = new PathFindingForm();
            m.Show();
        }
    }
}
