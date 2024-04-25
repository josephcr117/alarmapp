using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Alarm.Models
{
    public class AlarmModel
    {
        public DateTime Time { get; set; }
        public string Name { get; set; }
        public List<DayOfWeek> Days { get; set; }
        public bool IsActive { get; set; }
    }
}