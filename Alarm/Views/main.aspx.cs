using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Alarm.Models;

namespace Alarm.Views
{
    public partial class main : System.Web.UI.Page
    {
        private List<AlarmModel> alarms = new List<AlarmModel>();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}