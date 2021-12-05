
class formatTime{
  //format 24hr time to 12hr time
  timeFormat(String time) {
    switch (time) {
      case "12":
        {
          time = "12:00pm";
        }
        break;
      case "13":
        {
          time = "1:00pm";
        }
        break;
      case "14":
        {
          time = "2:00pm";
        }
        break;
      case "15":
        {
          time = "3:00pm";
        }
        break;
      case "16":
        {
          time = "4:00pm";
        }
        break;
      case "17":
        {
          time = "5:00pm";
        }
        break;
      case "18":
        {
          time = "6:00pm";
        }
        break;
      case "19":
        {
          time = "7:00pm";
        }
        break;
      case "20":
        {
          time = "8:00pm";
        }
        break;
      case "21":
        {
          time = "9:00pm";
        }
        break;
      case "22":
        {
          time = "10:00pm";
        }
        break;
      case "23":
        {
          time = "11:00pm";
        }
        break;
    }
    return time;
  }


}