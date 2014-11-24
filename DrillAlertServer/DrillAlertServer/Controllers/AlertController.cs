using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using DrillAlertServer.Models;

namespace DrillAlertServer.Controllers
{
    public class AlertController : ApiController
    {
        //GET: api/Alert/{id}
        public Alert Get(int id)
        {
            return AlertDatabase.GetAlert(id);
        }
    }
}
