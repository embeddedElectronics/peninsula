﻿using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace InfoReadOut
{
    public class ImageWorker
    {
        /// <summary>  
        /// 将一个字节数组转换为8bit灰度位图  
        /// </summary>  
        /// <param name="rawValues">显示字节数组</param>  
        /// <param name="width">图像宽度</param>  
        /// <param name="height">图像高度</param>  
        /// <returns>位图</returns>  
        public static Bitmap ToGrayBitmap(byte[] rawValues, int width, int height)
        {
            //// 申请目标位图的变量，并将其内存区域锁定  
            Bitmap bmp = new Bitmap(width, height, PixelFormat.Format8bppIndexed);
            BitmapData bmpData = bmp.LockBits(new Rectangle(0, 0, width, height),
            ImageLockMode.WriteOnly, PixelFormat.Format8bppIndexed);

            //// 获取图像参数  
            int stride = bmpData.Stride;  // 扫描线的宽度  
            int offset = stride - width;  // 显示宽度与扫描线宽度的间隙  
            IntPtr iptr = bmpData.Scan0;  // 获取bmpData的内存起始位置  
            int scanBytes = stride * height;// 用stride宽度，表示这是内存区域的大小  

            //// 下面把原始的显示大小字节数组转换为内存中实际存放的字节数组  
            int posScan = 0, posReal = 0;// 分别设置两个位置指针，指向源数组和目标数组  
            byte[] pixelValues = new byte[scanBytes];  //为目标数组分配内存  

            for (int x = 0; x < height; x++)
            {
                //// 下面的循环节是模拟行扫描  
                for (int y = 0; y < width; y++)
                {
                    pixelValues[posScan++] = rawValues[posReal++];
                }
                posScan += offset;  //行扫描结束，要将目标位置指针移过那段“间隙”  
            }

            //// 用Marshal的Copy方法，将刚才得到的内存字节数组复制到BitmapData中  
            System.Runtime.InteropServices.Marshal.Copy(pixelValues, 0, iptr, scanBytes);
            bmp.UnlockBits(bmpData);  // 解锁内存区域  

            //// 下面的代码是为了修改生成位图的索引表，从伪彩修改为灰度  
            ColorPalette tempPalette;
            using (Bitmap tempBmp = new Bitmap(1, 1, PixelFormat.Format8bppIndexed))
            {
                tempPalette = tempBmp.Palette;
            }
            for (int i = 0; i < 256; i++)
            {
                tempPalette.Entries[i] = Color.FromArgb(i, i, i);
            }

            bmp.Palette = tempPalette;

            //// 算法到此结束，返回结果  
            return bmp;
        }
        /// <summary>
        /// 放大图像
        /// </summary>
        /// <param name="orign">原始图像</param>
        /// <param name="iMagnify">放大倍数</param>
        /// <returns>处理后的图像</returns>
        public static Bitmap ImageStretch(Bitmap orign, int iMagnify)
        {
            int iWidth, iHeight;
            Color myColor;
            int i, j, i0, j0, i1, j1;

            Bitmap bmpTmp = orign;
            Bitmap bmpNew = new Bitmap(bmpTmp.Width * iMagnify, bmpTmp.Height * iMagnify);
            Graphics g = Graphics.FromImage(bmpNew);

            iWidth = bmpTmp.Width;
            iHeight = bmpTmp.Height;

            try
            {
                for (i = 0; i < iWidth; i++)
                {
                    i0 = i * iMagnify;
                    for (j = 0; j < iHeight; j++)
                    {
                        j0 = j * iMagnify;
                        myColor = bmpTmp.GetPixel(i, j);
                        for (i1 = i0; i1 < i0 + iMagnify; i1++)
                            for (j1 = j0; j1 < j0 + iMagnify; j1++)
                                bmpNew.SetPixel(i1, j1, myColor);
                    }
                }
            }
            catch { }


            bmpTmp.Dispose();
            g.Dispose();
            return bmpNew;
        }
        /// <summary>
        /// 整体处理图像
        /// </summary>
        /// <param name="rawValues">图像源数据</param>
        /// <param name="width">宽度</param>
        /// <param name="height">高度</param>
        /// <param name="iMagnify">放大倍数</param>
        /// <returns>处理后的图像</returns>
        public static Bitmap ImageDraw(byte[] rawValues, int width, int height,int iMagnify)
        {
            return ImageStretch(ToGrayBitmap(rawValues, width, height),iMagnify);

        }
    }
}
