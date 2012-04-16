﻿using System;

namespace InfoReadOut
{
    public class MyConfig
    {
        public String FilesPath { set; get; }
        public String FolderPath { set; get; }
        public Boolean NeedDecode { set; get; }
        public String Filter_DataFile { set; get; }
        public String Filter_ImageFile { set; get; }
        public UInt16 Width { set; get; }
        public UInt16 Height { set; get; }
        public UInt16 Useless { set; get; }
        public UInt16 Front { set; get; }
        public UInt16 Behind { set; get; }
        public UInt16 Magnify { set; get; }
        /// <summary>
        /// 设置默认配置
        /// </summary>
        public void SetDefault()
        {
            this.FilesPath = "";
            this.FolderPath = "";
            this.Filter_ImageFile = "IF*.txt";
            this.Filter_DataFile = "DF*.txt";
            this.Width = DefaultSetting.width;
            this.Height = DefaultSetting.height;
            this.Useless = DefaultSetting.useless;
            this.Front = DefaultSetting.front;
            this.Behind = DefaultSetting.behind;
            this.Magnify = DefaultSetting.magnify;
        }
    }
    public static class DefaultSetting
    {
        public static UInt16 width = 70, height = 90, useless = 0, front = 6, behind = 16, magnify = 4;
    }
}
