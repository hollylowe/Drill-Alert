using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Script.Services;
using DrillAlert.Models;
using Newtonsoft.Json;

namespace DrillAlert.Controllers
{
    public class DataController : ApiController
    {
        // GET api/<controller>
        [Route("api/data/{id}")]
        public Alert Get(int id)
        {
            return AlertDatabse.GetAlert(id);
        }
    }
}