
namespace Intelligent_Transportation
{
    partial class CarInfoForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.carsListBox = new System.Windows.Forms.ListBox();
            this.checkAvgButton = new System.Windows.Forms.Button();
            this.label7 = new System.Windows.Forms.Label();
            this.carIdTxtBox = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.avgMpgTxtBox = new System.Windows.Forms.TextBox();
            this.roadsListBox = new System.Windows.Forms.ListBox();
            this.label8 = new System.Windows.Forms.Label();
            this.roadIdTxtBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.stopsAllTxtBox = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.stopsTxtBox = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // carsListBox
            // 
            this.carsListBox.FormattingEnabled = true;
            this.carsListBox.ItemHeight = 16;
            this.carsListBox.Location = new System.Drawing.Point(12, 98);
            this.carsListBox.Name = "carsListBox";
            this.carsListBox.Size = new System.Drawing.Size(127, 324);
            this.carsListBox.TabIndex = 1;
            this.carsListBox.SelectedValueChanged += new System.EventHandler(this.carsListBox_SelectedValueChanged);
            // 
            // checkAvgButton
            // 
            this.checkAvgButton.Location = new System.Drawing.Point(332, 62);
            this.checkAvgButton.Name = "checkAvgButton";
            this.checkAvgButton.Size = new System.Drawing.Size(75, 23);
            this.checkAvgButton.TabIndex = 13;
            this.checkAvgButton.Text = "Check";
            this.checkAvgButton.UseVisualStyleBackColor = true;
            this.checkAvgButton.Click += new System.EventHandler(this.checkAvgButton_Click);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(554, 150);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(47, 17);
            this.label7.TabIndex = 27;
            this.label7.Text = "Car ID";
            // 
            // carIdTxtBox
            // 
            this.carIdTxtBox.Location = new System.Drawing.Point(640, 145);
            this.carIdTxtBox.Name = "carIdTxtBox";
            this.carIdTxtBox.ReadOnly = true;
            this.carIdTxtBox.Size = new System.Drawing.Size(100, 22);
            this.carIdTxtBox.TabIndex = 26;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(457, 196);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(156, 17);
            this.label5.TabIndex = 24;
            this.label5.Text = "Miles Per Gallon (MPG)";
            // 
            // avgMpgTxtBox
            // 
            this.avgMpgTxtBox.Location = new System.Drawing.Point(640, 191);
            this.avgMpgTxtBox.Name = "avgMpgTxtBox";
            this.avgMpgTxtBox.ReadOnly = true;
            this.avgMpgTxtBox.Size = new System.Drawing.Size(100, 22);
            this.avgMpgTxtBox.TabIndex = 19;
            // 
            // roadsListBox
            // 
            this.roadsListBox.FormattingEnabled = true;
            this.roadsListBox.ItemHeight = 16;
            this.roadsListBox.Location = new System.Drawing.Point(154, 98);
            this.roadsListBox.Name = "roadsListBox";
            this.roadsListBox.Size = new System.Drawing.Size(137, 324);
            this.roadsListBox.TabIndex = 28;
            this.roadsListBox.SelectedValueChanged += new System.EventHandler(this.roadsListBox_SelectedValueChanged);
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(542, 277);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(59, 17);
            this.label8.TabIndex = 30;
            this.label8.Text = "Road ID";
            // 
            // roadIdTxtBox
            // 
            this.roadIdTxtBox.Location = new System.Drawing.Point(640, 277);
            this.roadIdTxtBox.Name = "roadIdTxtBox";
            this.roadIdTxtBox.ReadOnly = true;
            this.roadIdTxtBox.Size = new System.Drawing.Size(100, 22);
            this.roadIdTxtBox.TabIndex = 29;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(498, 357);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(103, 17);
            this.label1.TabIndex = 32;
            this.label1.Text = "Stops (all cars)";
            // 
            // stopsAllTxtBox
            // 
            this.stopsAllTxtBox.Location = new System.Drawing.Point(640, 357);
            this.stopsAllTxtBox.Name = "stopsAllTxtBox";
            this.stopsAllTxtBox.ReadOnly = true;
            this.stopsAllTxtBox.Size = new System.Drawing.Size(100, 22);
            this.stopsAllTxtBox.TabIndex = 31;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(498, 318);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(104, 17);
            this.label2.TabIndex = 34;
            this.label2.Text = "Stops (this car)";
            // 
            // stopsTxtBox
            // 
            this.stopsTxtBox.Location = new System.Drawing.Point(640, 318);
            this.stopsTxtBox.Name = "stopsTxtBox";
            this.stopsTxtBox.ReadOnly = true;
            this.stopsTxtBox.Size = new System.Drawing.Size(100, 22);
            this.stopsTxtBox.TabIndex = 33;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(151, 68);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(46, 17);
            this.label3.TabIndex = 35;
            this.label3.Text = "Road:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 68);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(34, 17);
            this.label4.TabIndex = 36;
            this.label4.Text = "Car:";
            // 
            // CarInfoForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.stopsTxtBox);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.stopsAllTxtBox);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.roadIdTxtBox);
            this.Controls.Add(this.roadsListBox);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.carIdTxtBox);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.avgMpgTxtBox);
            this.Controls.Add(this.checkAvgButton);
            this.Controls.Add(this.carsListBox);
            this.Name = "CarInfoForm";
            this.Text = "CarInfoForm";
            this.Load += new System.EventHandler(this.CarInfoForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox carsListBox;
        private System.Windows.Forms.Button checkAvgButton;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox carIdTxtBox;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox avgMpgTxtBox;
        private System.Windows.Forms.ListBox roadsListBox;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox roadIdTxtBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox stopsAllTxtBox;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox stopsTxtBox;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
    }
}