namespace InfoReadOut
{
    partial class FilterForm
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
            this.textBox_ImageFile = new System.Windows.Forms.TextBox();
            this.textBox_DataFile = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // textBox_ImageFile
            // 
            this.textBox_ImageFile.Location = new System.Drawing.Point(125, 12);
            this.textBox_ImageFile.Name = "textBox_ImageFile";
            this.textBox_ImageFile.Size = new System.Drawing.Size(102, 21);
            this.textBox_ImageFile.TabIndex = 0;
            // 
            // textBox_DataFile
            // 
            this.textBox_DataFile.Location = new System.Drawing.Point(125, 62);
            this.textBox_DataFile.Name = "textBox_DataFile";
            this.textBox_DataFile.Size = new System.Drawing.Size(102, 21);
            this.textBox_DataFile.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(28, 15);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(77, 12);
            this.label1.TabIndex = 2;
            this.label1.Text = "图像文件过滤";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(28, 65);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(77, 12);
            this.label2.TabIndex = 3;
            this.label2.Text = "数据文件过滤";
            // 
            // FilterForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(252, 105);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBox_DataFile);
            this.Controls.Add(this.textBox_ImageFile);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "FilterForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "FilterForm";
            this.Load += new System.EventHandler(this.FilterForm_Load);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.FilterForm_FormClosing);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBox_ImageFile;
        private System.Windows.Forms.TextBox textBox_DataFile;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
    }
}