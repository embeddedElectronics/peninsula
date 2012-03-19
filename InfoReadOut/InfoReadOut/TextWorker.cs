using System;
using System.IO;
using System.Globalization;

namespace InfoReadOut
{
    public class TextWorker
    {
        /// <summary>  
        /// 图像信息读入
        /// </summary>  
        /// <param name="_info">文件名</param>  
        /// <param name="_width">图像的宽</param>  
        /// <param name="_height">图像的高</param> 
        /// <param name="_front">首行缩进</param>  
        /// <param name="_behind">尾行缩进</param>  
        /// <returns>得到的byte数组</returns>   
        public static byte[] Readin(String _fileName, UInt16 _width, UInt16 _height, UInt16 _front, UInt16 _behind)
        {
            try
            {
                // Create an instance of StreamReader to read from a file.
                // The using statement also closes the StreamReader.
                using (StreamReader sr = new StreamReader(_fileName))
                {
                    String line, info = "";
                    // Read and display lines from the file until the end of 
                    // the file is reached.
                    while ((line = sr.ReadLine()) != null)
                    {
                        info += UsefulReadout(line, _front, _behind) + " ";
                    }
                    return ConvertInfo(info, _width, _height);
                }
            }
            catch (Exception e)
            {
                // Let the user know what went wrong.
                MessageSender.e = e;
                return new byte[1];
            }
        }
        /// <summary>  
        /// 将有用的图像信息提取
        /// </summary>  
        /// <param name="_line">一行字符串</param>  
        /// <param name="_front">首行缩进</param>  
        /// <param name="_behind">尾行缩进</param>  
        /// <returns>处理过的字符串</returns>  
        private static String UsefulReadout(String _line, UInt16 _front, UInt16 _behind)
        {
            try
            {
                if (_line != "")
                {
                    _line = _line.Substring(_front);
                    _line = _line.Substring(0, _line.Length - _behind);
                    _line = _line.TrimEnd(" ".ToCharArray());
                }

            }
            catch (System.Exception ex)
            {
                MessageSender.e = ex;
            }

            return _line;
        }
        /// <summary>  
        /// 字符串转换成数值
        /// </summary>  
        /// <param name="_info">字符串</param>  
        /// <param name="_width">图像的宽</param>  
        /// <param name="_height">图像的高</param>  
        /// <returns>得到的byte数组</returns>  
        private static byte[] ConvertInfo(String _info, UInt16 _width, UInt16 _height)
        {
            byte[] bytearray = new byte[_width * _height];
            UInt16 hex, width = _width, height = _height;
            String debug;
            try
            {

                foreach (String s in _info.Split(' '))
                {
                    debug = s;
                    if (s != "")
                    {
                        hex = UInt16.Parse(s, NumberStyles.HexNumber);
                        bytearray[width + (height - 1) * _width - 1] = Convert.ToByte(hex);
                        width--;
                        if (width == 0)
                        {
                            width = _width;
                            height--;
                        }
                        if (_height == 0)
                        {
                            break;
                        }
                    }

                }


            }
            catch (System.Exception ex)
            {
                MessageSender.e = ex;
            }
            return bytearray;
        }
    }
}
