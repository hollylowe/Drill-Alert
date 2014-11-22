using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DrillAlertServer.Models
{
    [Serializable]
    public class TimePoint
    {
        internal double X;
        internal double Y;
        public TimePoint(double x, double y)
        {
            this.X = x;
            this.Y = y;
        }
    }
}
