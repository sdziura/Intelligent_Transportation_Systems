
namespace Intelligent_Transportation
{
    partial class RoadInfoForm
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
            this.roadsListBox = new System.Windows.Forms.ListBox();
            this.avgSpeedTxtBox = new System.Windows.Forms.TextBox();
            this.avgSpeedMoveTxtBox = new System.Windows.Forms.TextBox();
            this.avgRpmTxtBox = new System.Windows.Forms.TextBox();
            this.avgRpmMoveTxtBox = new System.Windows.Forms.TextBox();
            this.avgMpgTxtBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.checkAvgButton = new System.Windows.Forms.Button();
            this.roadIdTxtBox = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // roadsListBox
            // 
            this.roadsListBox.FormattingEnabled = true;
            this.roadsListBox.ItemHeight = 16;
            this.roadsListBox.Location = new System.Drawing.Point(12, 67);
            this.roadsListBox.Name = "roadsListBox";
            this.roadsListBox.Size = new System.Drawing.Size(224, 324);
            this.roadsListBox.TabIndex = 0;
            this.roadsListBox.SelectedValueChanged += new System.EventHandler(this.roadsListBox_SelectedValueChanged);
            // 
            // avgSpeedTxtBox
            // 
            this.avgSpeedTxtBox.Location = new System.Drawing.Point(664, 117);
            this.avgSpeedTxtBox.Name = "avgSpeedTxtBox";
            this.avgSpeedTxtBox.ReadOnly = true;
            this.avgSpeedTxtBox.Size = new System.Drawing.Size(100, 22);
            this.avgSpeedTxtBox.TabIndex = 1;
            // 
            // avgSpeedMoveTxtBox
            // 
            this.avgSpeedMoveTxtBox.Location = new System.Drawing.Point(664, 167);
            this.avgSpeedMoveTxtBox.Name = "avgSpeedMoveTxtBox";
            this.avgSpeedMoveTxtBox.ReadOnly = true;
            this.avgSpeedMoveTxtBox.Size = new System.Drawing.Size(100, 22);
            this.avgSpeedMoveTxtBox.TabIndex = 2;
            // 
            // avgRpmTxtBox
            // 
            this.avgRpmTxtBox.Location = new System.Drawing.Point(664, 221);
            this.avgRpmTxtBox.Name = "avgRpmTxtBox";
            this.avgRpmTxtBox.ReadOnly = true;
            this.avgRpmTxtBox.Size = new System.Drawing.Size(100, 22);
            this.avgRpmTxtBox.TabIndex = 3;
            // 
            // avgRpmMoveTxtBox
            // 
            this.avgRpmMoveTxtBox.Location = new System.Drawing.Point(664, 278);
            this.avgRpmMoveTxtBox.Name = "avgRpmMoveTxtBox";
            this.avgRpmMoveTxtBox.ReadOnly = true;
            this.avgRpmMoveTxtBox.Size = new System.Drawing.Size(100, 22);
            this.avgRpmMoveTxtBox.TabIndex = 4;
            // 
            // avgMpgTxtBox
            // 
            this.avgMpgTxtBox.Location = new System.Drawing.Point(664, 339);
            this.avgMpgTxtBox.Name = "avgMpgTxtBox";
            this.avgMpgTxtBox.ReadOnly = true;
            this.avgMpgTxtBox.Size = new System.Drawing.Size(100, 22);
            this.avgMpgTxtBox.TabIndex = 5;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(588, 122);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(49, 17);
            this.label1.TabIndex = 6;
            this.label1.Text = "Speed";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(495, 172);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(142, 17);
            this.label2.TabIndex = 7;
            this.label2.Text = "Speed (only in move)";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(439, 226);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(198, 17);
            this.label3.TabIndex = 8;
            this.label3.Text = "Revolutions Per Minute (RPM)";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(346, 283);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(291, 17);
            this.label4.TabIndex = 9;
            this.label4.Text = "Revolutions Per Minute (RPM) (only in move)";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(481, 344);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(156, 17);
            this.label5.TabIndex = 10;
            this.label5.Text = "Miles Per Gallon (MPG)";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.label6.Location = new System.Drawing.Point(564, 82);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(73, 18);
            this.label6.TabIndex = 11;
            this.label6.Text = "Average:";
            // 
            // checkAvgButton
            // 
            this.checkAvgButton.Location = new System.Drawing.Point(283, 67);
            this.checkAvgButton.Name = "checkAvgButton";
            this.checkAvgButton.Size = new System.Drawing.Size(75, 23);
            this.checkAvgButton.TabIndex = 12;
            this.checkAvgButton.Text = "Check";
            this.checkAvgButton.UseVisualStyleBackColor = true;
            this.checkAvgButton.Click += new System.EventHandler(this.checkAvgButton_Click);
            // 
            // roadIdTxtBox
            // 
            this.roadIdTxtBox.Location = new System.Drawing.Point(664, 37);
            this.roadIdTxtBox.Name = "roadIdTxtBox";
            this.roadIdTxtBox.ReadOnly = true;
            this.roadIdTxtBox.Size = new System.Drawing.Size(100, 22);
            this.roadIdTxtBox.TabIndex = 13;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(578, 42);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(59, 17);
            this.label7.TabIndex = 14;
            this.label7.Text = "Road ID";
            // 
            // RoadInfoForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.roadIdTxtBox);
            this.Controls.Add(this.checkAvgButton);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.avgMpgTxtBox);
            this.Controls.Add(this.avgRpmMoveTxtBox);
            this.Controls.Add(this.avgRpmTxtBox);
            this.Controls.Add(this.avgSpeedMoveTxtBox);
            this.Controls.Add(this.avgSpeedTxtBox);
            this.Controls.Add(this.roadsListBox);
            this.Name = "RoadInfoForm";
            this.Text = "RoadInfoForm";
            this.Load += new System.EventHandler(this.RoadInfoForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox roadsListBox;
        private System.Windows.Forms.TextBox avgSpeedTxtBox;
        private System.Windows.Forms.TextBox avgSpeedMoveTxtBox;
        private System.Windows.Forms.TextBox avgRpmTxtBox;
        private System.Windows.Forms.TextBox avgRpmMoveTxtBox;
        private System.Windows.Forms.TextBox avgMpgTxtBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Button checkAvgButton;
        private System.Windows.Forms.TextBox roadIdTxtBox;
        private System.Windows.Forms.Label label7;
    }
}