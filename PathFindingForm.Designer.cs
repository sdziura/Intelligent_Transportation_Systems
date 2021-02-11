
namespace Intelligent_Transportation
{
    partial class PathFindingForm
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
            this.fromListBox = new System.Windows.Forms.ListBox();
            this.toListBox = new System.Windows.Forms.ListBox();
            this.dateTimePicker1 = new System.Windows.Forms.DateTimePicker();
            this.checkAvgButton = new System.Windows.Forms.Button();
            this.label7 = new System.Windows.Forms.Label();
            this.fromRoadTxtBox = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.toRoadTxtBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.radiusTxtBox = new System.Windows.Forms.TextBox();
            this.pathListBox = new System.Windows.Forms.ListBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // fromListBox
            // 
            this.fromListBox.FormattingEnabled = true;
            this.fromListBox.ItemHeight = 16;
            this.fromListBox.Location = new System.Drawing.Point(12, 130);
            this.fromListBox.Name = "fromListBox";
            this.fromListBox.Size = new System.Drawing.Size(120, 308);
            this.fromListBox.TabIndex = 0;
            this.fromListBox.SelectedValueChanged += new System.EventHandler(this.fromListBox_SelectedValueChanged);
            // 
            // toListBox
            // 
            this.toListBox.FormattingEnabled = true;
            this.toListBox.ItemHeight = 16;
            this.toListBox.Location = new System.Drawing.Point(160, 130);
            this.toListBox.Name = "toListBox";
            this.toListBox.Size = new System.Drawing.Size(120, 308);
            this.toListBox.TabIndex = 1;
            this.toListBox.SelectedValueChanged += new System.EventHandler(this.toListBox_SelectedValueChanged);
            // 
            // dateTimePicker1
            // 
            this.dateTimePicker1.CustomFormat = "yyyy-MM-dd HH:mm:ss";
            this.dateTimePicker1.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            this.dateTimePicker1.Location = new System.Drawing.Point(311, 130);
            this.dateTimePicker1.Name = "dateTimePicker1";
            this.dateTimePicker1.ShowUpDown = true;
            this.dateTimePicker1.Size = new System.Drawing.Size(164, 22);
            this.dateTimePicker1.TabIndex = 2;
            // 
            // checkAvgButton
            // 
            this.checkAvgButton.Location = new System.Drawing.Point(326, 290);
            this.checkAvgButton.Name = "checkAvgButton";
            this.checkAvgButton.Size = new System.Drawing.Size(105, 60);
            this.checkAvgButton.TabIndex = 14;
            this.checkAvgButton.Text = "Check";
            this.checkAvgButton.UseVisualStyleBackColor = true;
            this.checkAvgButton.Click += new System.EventHandler(this.checkAvgButton_Click);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(534, 45);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(78, 17);
            this.label7.TabIndex = 31;
            this.label7.Text = "From Node";
            // 
            // fromRoadTxtBox
            // 
            this.fromRoadTxtBox.Location = new System.Drawing.Point(652, 40);
            this.fromRoadTxtBox.Name = "fromRoadTxtBox";
            this.fromRoadTxtBox.ReadOnly = true;
            this.fromRoadTxtBox.Size = new System.Drawing.Size(100, 22);
            this.fromRoadTxtBox.TabIndex = 30;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(549, 423);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(63, 17);
            this.label5.TabIndex = 29;
            this.label5.Text = "To Node";
            // 
            // toRoadTxtBox
            // 
            this.toRoadTxtBox.Location = new System.Drawing.Point(652, 416);
            this.toRoadTxtBox.Name = "toRoadTxtBox";
            this.toRoadTxtBox.ReadOnly = true;
            this.toRoadTxtBox.Size = new System.Drawing.Size(100, 22);
            this.toRoadTxtBox.TabIndex = 28;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(308, 181);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(52, 17);
            this.label1.TabIndex = 33;
            this.label1.Text = "Radius";
            // 
            // radiusTxtBox
            // 
            this.radiusTxtBox.Location = new System.Drawing.Point(375, 181);
            this.radiusTxtBox.Name = "radiusTxtBox";
            this.radiusTxtBox.Size = new System.Drawing.Size(100, 22);
            this.radiusTxtBox.TabIndex = 34;
            this.radiusTxtBox.Text = "0.005";
            // 
            // pathListBox
            // 
            this.pathListBox.FormattingEnabled = true;
            this.pathListBox.ItemHeight = 16;
            this.pathListBox.Location = new System.Drawing.Point(652, 79);
            this.pathListBox.Name = "pathListBox";
            this.pathListBox.Size = new System.Drawing.Size(100, 308);
            this.pathListBox.TabIndex = 35;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 98);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(40, 17);
            this.label4.TabIndex = 38;
            this.label4.Text = "From";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(157, 98);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(25, 17);
            this.label2.TabIndex = 39;
            this.label2.Text = "To";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(506, 224);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(106, 17);
            this.label3.TabIndex = 40;
            this.label3.Text = "Through Edges";
            // 
            // PathFindingForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.pathListBox);
            this.Controls.Add(this.radiusTxtBox);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.fromRoadTxtBox);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.toRoadTxtBox);
            this.Controls.Add(this.checkAvgButton);
            this.Controls.Add(this.dateTimePicker1);
            this.Controls.Add(this.toListBox);
            this.Controls.Add(this.fromListBox);
            this.Name = "PathFindingForm";
            this.Text = "PathFindingForm";
            this.Load += new System.EventHandler(this.PathFindingForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox fromListBox;
        private System.Windows.Forms.ListBox toListBox;
        private System.Windows.Forms.DateTimePicker dateTimePicker1;
        private System.Windows.Forms.Button checkAvgButton;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox fromRoadTxtBox;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox toRoadTxtBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox radiusTxtBox;
        private System.Windows.Forms.ListBox pathListBox;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
    }
}