
namespace Intelligent_Transportation
{
    partial class Form1
    {
        /// <summary>
        /// Wymagana zmienna projektanta.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Wyczyść wszystkie używane zasoby.
        /// </summary>
        /// <param name="disposing">prawda, jeżeli zarządzane zasoby powinny zostać zlikwidowane; Fałsz w przeciwnym wypadku.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Kod generowany przez Projektanta formularzy systemu Windows

        /// <summary>
        /// Metoda wymagana do obsługi projektanta — nie należy modyfikować
        /// jej zawartości w edytorze kodu.
        /// </summary>
        private void InitializeComponent()
        {
            this.roadInfoButton = new System.Windows.Forms.Button();
            this.carInfoButton = new System.Windows.Forms.Button();
            this.pathFindingButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // roadInfoButton
            // 
            this.roadInfoButton.Cursor = System.Windows.Forms.Cursors.Hand;
            this.roadInfoButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.roadInfoButton.Location = new System.Drawing.Point(508, 323);
            this.roadInfoButton.Name = "roadInfoButton";
            this.roadInfoButton.Size = new System.Drawing.Size(194, 47);
            this.roadInfoButton.TabIndex = 0;
            this.roadInfoButton.Text = "Road Statistics";
            this.roadInfoButton.UseVisualStyleBackColor = true;
            this.roadInfoButton.Click += new System.EventHandler(this.RoadInfoButton_Click);
            // 
            // carInfoButton
            // 
            this.carInfoButton.Cursor = System.Windows.Forms.Cursors.Hand;
            this.carInfoButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.carInfoButton.Location = new System.Drawing.Point(508, 254);
            this.carInfoButton.Name = "carInfoButton";
            this.carInfoButton.Size = new System.Drawing.Size(194, 46);
            this.carInfoButton.TabIndex = 1;
            this.carInfoButton.Text = "Car Statistics";
            this.carInfoButton.UseVisualStyleBackColor = true;
            this.carInfoButton.Click += new System.EventHandler(this.carInfoButton_Click);
            // 
            // pathFindingButton
            // 
            this.pathFindingButton.Cursor = System.Windows.Forms.Cursors.Hand;
            this.pathFindingButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.pathFindingButton.Location = new System.Drawing.Point(57, 63);
            this.pathFindingButton.Name = "pathFindingButton";
            this.pathFindingButton.Size = new System.Drawing.Size(318, 78);
            this.pathFindingButton.TabIndex = 2;
            this.pathFindingButton.Text = "Path Finding";
            this.pathFindingButton.UseVisualStyleBackColor = true;
            this.pathFindingButton.Click += new System.EventHandler(this.pathFindingButton_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.pathFindingButton);
            this.Controls.Add(this.carInfoButton);
            this.Controls.Add(this.roadInfoButton);
            this.Name = "Form1";
            this.Text = "Path Finding";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button roadInfoButton;
        private System.Windows.Forms.Button carInfoButton;
        private System.Windows.Forms.Button pathFindingButton;
    }
}

