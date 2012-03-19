using System;

namespace InfoReadOut
{
    public class MyConfig
    {
        public String FolderPath { set; get; }
        public UInt16 Width { set; get; }
        public UInt16 Height { set; get; }
        public UInt16 Useless { set; get; }
        public UInt16 Front { set; get; }
        public UInt16 Behind { set; get; }

        public void SetDefault()
        {
            this.Width = DefaultSetting.width;
            this.Height = DefaultSetting.height;
            this.Useless = DefaultSetting.useless;
            this.Front = DefaultSetting.front;
            this.Behind = DefaultSetting.behind;
        }
    }
    public static class DefaultSetting
    {
        public static UInt16 width = 80, height = 120, useless = 0, front = 6, behind = 20;
    }
}
