using DrillAlertServer.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace DrillAlertServer.Controllers
{
    public class WellboreDataController : ApiController
    {
        /// <summary>
        /// Gets the time points.
        /// </summary>
        /// <param name="num">The number.</param>
        /// <returns>num random points with an x and y value</returns>
        [HttpGet]
        [Route("api/WellboreData/{num}")]
        public TimePoint[] GetTimePoints(int num)
        {
            Random rand = new Random();

            TimePoint[] timePoints = new TimePoint[num];
            for (int i = 0; i < num; i++)
            {
                timePoints[i] = new TimePoint(Double.Parse((rand.NextDouble() * 10).ToString("0.00")),
                    Double.Parse((rand.NextDouble() * 10).ToString("0.00")));
            }

            return timePoints;
        }
    }
}
