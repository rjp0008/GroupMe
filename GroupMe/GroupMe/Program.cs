using GroupMe;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace GroupMe
{
    class Program
    {
        static void Main(string[] args)
        {
            ParseMessages();
        }

        static void MakeText()
        {
            StreamReader read = new StreamReader("54790.json");
            string text = read.ReadToEnd();
            var test = (Response)JsonConvert.DeserializeObject(text);
            StreamWriter allText = new StreamWriter("text.txt");
            Console.WriteLine(test.GetType().ToString());
            Console.ReadKey();
            allText.Close();
        }

        static void MakeJSON()
        {
            StreamReader test = new StreamReader("54790.txt");
            StreamWriter output = new StreamWriter("54790.json");
            while (!test.EndOfStream)
            {
                output.WriteLine(test.ReadLine() + ",");
            }
            test.Close();
            output.Close();
        }

        static void ParseMessages()
        {
            string urlString = "https://api.groupme.com/v3/groups/3000143/messages?token=" + ConnectionInfo.APIKEY + "&limit=100";
            string beforeID = "&before_id=";
            List<Message> allMessages = new List<Message>();
            for (int i = 0; i < 1000; i++)
            {
                var httpWebRequest = (HttpWebRequest)WebRequest.Create(urlString + (beforeID == "&before_id=" ? "" : beforeID));
                httpWebRequest.ContentType = "text/json";
                httpWebRequest.Method = "GET";

                string data = "";
                HttpWebResponse httpResponse;
                try
                {
                    httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
                }
                catch (WebException)
                {
                    break;
                }
                if (httpResponse.StatusCode == HttpStatusCode.OK)
                {
                    Stream receiveStream = httpResponse.GetResponseStream();
                    StreamReader readStream = null;

                    if (httpResponse.CharacterSet == null)
                    {
                        readStream = new StreamReader(receiveStream);
                    }
                    else
                    {
                        readStream = new StreamReader(receiveStream, Encoding.GetEncoding(httpResponse.CharacterSet));
                    }

                    data = readStream.ReadToEnd();

                    httpResponse.Close();
                    readStream.Close();
                }
                RootObject m = JsonConvert.DeserializeObject<RootObject>(data);
                allMessages.AddRange(m.response.messages);
                beforeID = "&before_id=" + allMessages.Last().id;

            }
            StreamWriter test = new StreamWriter(allMessages.Count.ToString() + ".txt");
            foreach (Message message in allMessages)
            {
                test.WriteLine(JsonConvert.SerializeObject(message));
            }
            test.Close();
        }
    }
}
