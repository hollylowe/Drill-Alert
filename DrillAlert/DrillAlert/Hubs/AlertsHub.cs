using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace DrillAlert.Hubs
{
    public class AlertsHub : Hub
    {
        public void Hello()
        {
            Clients.All.hello();
        }
    }
}