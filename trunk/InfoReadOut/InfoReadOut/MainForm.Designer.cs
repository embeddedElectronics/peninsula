namespace InfoReadOut
{
    partial class MainForm
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.button_OpenFile = new System.Windows.Forms.Button();
            this.button_OpenFolder = new System.Windows.Forms.Button();
            this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.textBox_Width = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.textBox_Height = new System.Windows.Forms.TextBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.textBox_Behind = new System.Windows.Forms.TextBox();
            this.textBox_Front = new System.Windows.Forms.TextBox();
            this.textBox_Useless = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.folderBrowserDialog = new System.Windows.Forms.FolderBrowserDialog();
            this.button_Show = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // button_OpenFile
            // 
            this.button_OpenFile.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.button_OpenFile.Location = new System.Drawing.Point(46, 271);
            this.button_OpenFile.Name = "button_OpenFile";
            this.button_OpenFile.Size = new System.Drawing.Size(105, 32);
            this.button_OpenFile.TabIndex = 0;
            this.button_OpenFile.Text = "打开文件";
            this.button_OpenFile.UseVisualStyleBackColor = true;
            this.button_OpenFile.Click += new System.EventHandler(this.button_OpenFile_Click);
            // 
            // button_OpenFolder
            // 
            this.button_OpenFolder.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.button_OpenFolder.Location = new System.Drawing.Point(46, 319);
            this.button_OpenFolder.Name = "button_OpenFolder";
            this.button_OpenFolder.Size = new System.Drawing.Size(105, 32);
            this.button_OpenFolder.TabIndex = 1;
            this.button_OpenFolder.Text = "打开文件夹";
            this.button_OpenFolder.UseVisualStyleBackColor = true;
            this.button_OpenFolder.Click += new System.EventHandler(this.button_OpenFolder_Click);
            // 
            // openFileDialog
            // 
            this.openFileDialog.Filter = "TXT|*.txt";
            this.openFileDialog.Multiselect = true;
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox1.Controls.Add(this.textBox_Width);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.textBox_Height);
            this.groupBox1.Location = new System.Drawing.Point(14, 21);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(160, 95);
            this.groupBox1.TabIndex = 3;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "图像信息";
            // 
            // textBox_Width
            // 
            this.textBox_Width.Location = new System.Drawing.Point(92, 30);
            this.textBox_Width.Name = "textBox_Width";
            this.textBox_Width.Size = new System.Drawing.Size(49, 21);
            this.textBox_Width.TabIndex = 0;
            this.textBox_Width.TextChanged += new System.EventHandler(this.textBox_Width_TextChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(54, 33);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(29, 12);
            this.label2.TabIndex = 2;
            this.label2.Text = "列数";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(54, 66);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(29, 12);
            this.label1.TabIndex = 1;
            this.label1.Text = "行数";
            // 
            // textBox_Height
            // 
            this.textBox_Height.Location = new System.Drawing.Point(92, 63);
            this.textBox_Height.Name = "textBox_Height";
            this.textBox_Height.Size = new System.Drawing.Size(49, 21);
            this.textBox_Height.TabIndex = 1;
            this.textBox_Height.TextChanged += new System.EventHandler(this.textBox_Height_TextChanged);
            // 
            // groupBox2
            // 
            this.groupBox2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox2.Controls.Add(this.textBox_Behind);
            this.groupBox2.Controls.Add(this.textBox_Front);
            this.groupBox2.Controls.Add(this.textBox_Useless);
            this.groupBox2.Controls.Add(this.label5);
            this.groupBox2.Controls.Add(this.label4);
            this.groupBox2.Controls.Add(this.label3);
            this.groupBox2.Location = new System.Drawing.Point(14, 122);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(160, 126);
            this.groupBox2.TabIndex = 4;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "无用字符消除";
            // 
            // textBox_Behind
            // 
            this.textBox_Behind.Location = new System.Drawing.Point(92, 85);
            this.textBox_Behind.Name = "textBox_Behind";
            this.textBox_Behind.Size = new System.Drawing.Size(49, 21);
            this.textBox_Behind.TabIndex = 5;
            this.textBox_Behind.TextChanged += new System.EventHandler(this.textBox_Behind_TextChanged);
            // 
            // textBox_Front
            // 
            this.textBox_Front.Location = new System.Drawing.Point(92, 55);
            this.textBox_Front.Name = "textBox_Front";
            this.textBox_Front.Size = new System.Drawing.Size(49, 21);
            this.textBox_Front.TabIndex = 4;
            this.textBox_Front.TextChanged += new System.EventHandler(this.textBox_Front_TextChanged);
            // 
            // textBox_Useless
            // 
            this.textBox_Useless.Location = new System.Drawing.Point(92, 27);
            this.textBox_Useless.Name = "textBox_Useless";
            this.textBox_Useless.Size = new System.Drawing.Size(49, 21);
            this.textBox_Useless.TabIndex = 3;
            this.textBox_Useless.TextChanged += new System.EventHandler(this.textBox_Useless_TextChanged);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(30, 88);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(53, 12);
            this.label5.TabIndex = 2;
            this.label5.Text = "行末缩进";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(30, 58);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(53, 12);
            this.label4.TabIndex = 1;
            this.label4.Text = "行前缩进";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(6, 30);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(77, 12);
            this.label3.TabIndex = 0;
            this.label3.Text = "起始跳过行数";
            // 
            // button_Show
            // 
            this.button_Show.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.button_Show.Location = new System.Drawing.Point(46, 371);
            this.button_Show.Name = "button_Show";
            this.button_Show.Size = new System.Drawing.Size(105, 35);
            this.button_Show.TabIndex = 5;
            this.button_Show.Text = "显示图像";
            this.button_Show.UseVisualStyleBackColor = true;
            this.button_Show.Click += new System.EventHandler(this.button_Show_Click);
            // 
            // MainForm
            // 
            this.AcceptButton = this.button_Show;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(200, 429);
            this.Controls.Add(this.button_Show);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.button_OpenFolder);
            this.Controls.Add(this.button_OpenFile);
            this.MaximizeBox = false;
            this.Name = "MainForm";
            this.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "MainForm";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MainForm_FormClosing);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button button_OpenFile;
        private System.Windows.Forms.Button button_OpenFolder;
        private System.Windows.Forms.OpenFileDialog openFileDialog;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TextBox textBox_Width;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBox_Height;
        private System.Windows.Forms.TextBox textBox_Behind;
        private System.Windows.Forms.TextBox textBox_Front;
        private System.Windows.Forms.TextBox textBox_Useless;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog;
        private System.Windows.Forms.Button button_Show;
    }
}

