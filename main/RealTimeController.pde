// By Brian Whelan
import java.io.*;
import java.net.*;
public class RealTimeController {

  public RealTimeController() {
  }

  public RealTimeResponse Query(String stopID) throws MalformedURLException, IOException {
    return parse(getXML(stopID));
  }

  private String getXML(String stopID) throws MalformedURLException, IOException {    
    StringBuilder result = new StringBuilder();
    String surl = "https://data.dublinked.ie/cgi-bin/rtpi/realtimebusinformation?stopid=" + stopID + "&format=xml";
    URL url = new URL(surl);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    String line;
    while ((line = rd.readLine()) != null) {
      result.append(line);
    }
    rd.close();
    return result.toString();
  }
  //Simple XML parser to convert returned XML to RealTimeModel 
  private RealTimeResponse parse(String xml) {
    int numberOfResults = Integer.parseInt(getValue("numberofresults", xml, 0));
    println("number of results: " + numberOfResults);
    int lastIndex = 0;
    int errorCode = Integer.parseInt(getValue("errorcode", xml, lastIndex));
    String query = getValue("timestamp", xml, lastIndex);
    String stopID = getValue("stopid", xml, lastIndex);
    RealTimeResponse response = new RealTimeResponse(errorCode, query, stopID);
    for (int i = 0; i < numberOfResults; i++) {
      RealTimeBus m = new RealTimeBus();
      m.setDueTime(getValue("duetime", xml, lastIndex));
      m.setDestination(getValue("destination", xml, lastIndex));
      m.setOrigin(getValue("origin", xml, lastIndex));
      m.setRoute(getValue("route", xml, lastIndex));
      m.setAccesible(getValue("lowfloorstatus", xml, lastIndex));
      println(m.toString());
      lastIndex = xml.indexOf("</result>", lastIndex) + "</result>".length();
      response.Add(m);
    }
    response.fresh = true;
    return response;
  }

  String getValue(String label, String xml, int lastIndex) {
    return xml.substring(xml.indexOf("<" + label + ">", lastIndex) + ("<" + label + ">").length(), xml.indexOf("</" + label + ">", lastIndex));
  }
}