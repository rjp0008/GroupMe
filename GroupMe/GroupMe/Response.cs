using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GroupMe
{
    public class Response
    {
        public int count { get; set; }
        public List<Message> messages { get; set; }
    }
}
