using System.IO;
using Newtonsoft.Json;

namespace InfoReadOut
{
    public class ConfigWorker
    {
        public enum States
        {
            OK,
            Exception
        }
        private static States state = States.OK;
        public static States State
        {
            get
            {
                return state;
            }
        }
        /// <summary>  
        /// 检测配置文件是否存在
        /// </summary>  
        /// <returns>文件存在状态</returns>   
        public static States FileDetect()
        {
            if (File.Exists("Config.ini"))
            {
                return States.OK;
            } 
            else
            {
                return States.Exception;
            }
        }
        /// <summary>  
        /// 生成新的配置文件
        /// </summary>  
        /// <param name="config">配置</param>
        /// <returns>状态</returns>   
        public static States CreatNew(ref MyConfig config)
        {
            try
            {
                using (StreamWriter sw = new StreamWriter("Config.ini"))
                {
                    config.SetDefault();
                    sw.Write(JsonConvert.SerializeObject(config));
                    return States.OK;
                }
            }
            catch (System.Exception ex)
            {
                MessageSender.e = ex;
                return States.Exception;
            }
        }
        /// <summary>  
        /// 保存配置文件
        /// </summary>  
        /// <param name="config">配置</param>
        /// <returns>状态</returns>   
        public static States Save(MyConfig config)
        {
            try
            {
                using (StreamWriter sw = new StreamWriter("Config.ini"))
                {
                    sw.Write(JsonConvert.SerializeObject(config));
                    return States.OK;
                }
            }
            catch (System.Exception ex)
            {
                MessageSender.e = ex;
                return States.Exception;
            }

        }
        /// <summary>  
        /// 读取配置文件
        /// </summary>  
        /// <param name="config">配置</param>
        /// <returns>状态</returns>   
        public static States Load(ref MyConfig config)
        {
            try
            {
                using (StreamReader sr = new StreamReader("Config.ini"))
                {
                    config = JsonConvert.DeserializeObject<MyConfig>(sr.ReadToEnd());
                    return States.OK;
                }
            }
            catch (System.Exception ex)
            {
                MessageSender.e = ex;
                return States.Exception;
            }
        }
    }
}
