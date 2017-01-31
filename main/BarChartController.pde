// Written by Jordan Myers
import de.bezier.data.sql.*;
public class BarChartController {
  main s;
  SQLite db;

  public BarChartController(main sketch, String connectionString) {
    s = sketch;
    db = new SQLite(s, connectionString);
  }

  // Gets the average delay for a line
  HashMap<String, Float> getAverageDelayForLine (String[] lines) {
    HashMap<String, Float> averageDelays = new HashMap<String, Float>();
    String queryLines = "";
    if (lines!=null) {
      int i=0;
      queryLines = "Line='" + lines[0]+"'";
      for (i=1; i<lines.length; i++) {
        queryLines = queryLines + " OR Line='" + lines[i]+"'";
      }
    }
    if ( db.connect() )
    {
      String query = "SELECT Line, AVG(Delay) FROM busData WHERE (" + queryLines + ") AND Delay>-181 GROUP BY Line ORDER BY Line;";
      db.query(query);
      while ( db.next ()) {
        averageDelays.put(db.getString("Line"), ((float)round(db.getFloat("AVG(Delay)"))));
      }
    }
    return averageDelays;
  }

  // Gets the total number of buses by operator
  HashMap<String, Float> getNumberOfBusesPerOperator () {
    HashMap<String, Float> busesPerOperator = new HashMap<String, Float>();
    if ( db.connect() )
    {
      String query = "SELECT BusOperator, COUNT(DISTINCT Vehicle_ID) FROM busData GROUP BY BusOperator ORDER BY BusOperator;";
      db.query(query);
      while ( db.next ()) {
        busesPerOperator.put(db.getString("BusOperator"), (db.getFloat("COUNT(DISTINCT Vehicle_ID)")));
      }
    }
    return busesPerOperator;
  }
  // Gets the average delay by hour, returning the results as a HashMap
  HashMap<String, Float> getAverageDelayByHour () {
    HashMap<String, Float> delays = new HashMap<String, Float>();
    if ( db.connect() )
    {
      for (int i=0; i<24; i++) {
        String beginTime = "";
        String endTime="";
        if (i<10) { 
          beginTime="0";
          endTime="0";
        }
        beginTime = beginTime + i +":00:00 ";
        endTime = endTime + i+":59:59";
        String query = "SELECT AVG(Delay) FROM busData WHERE Reading_Date_Time BETWEEN DATETIME('2013-01-01 "+ beginTime +"') AND DATETIME('2013-01-01 "+ endTime +"') ;";
        db.query(query);
        while ( db.next ()) {
          float avg = db.getFloat("AVG(Delay)");
          delays.put(beginTime, avg);
        }
      }
    }
    return delays;
  }

  // Gets the average delay by hour, returning the results as a TreeMap
  TreeMap<String, Float> getAverageDelayByHourTree () {
    TreeMap<String, Float> delays = new TreeMap<String, Float>();
    if ( db.connect() )
    {
      for (int i=6; i<24; i++) {
        String beginTime = "";
        String endTime="";
        if (i<10) { 
          beginTime="0";
          endTime="0";
        }
        beginTime = beginTime + i +":00:00 ";
        endTime = endTime + i+":59:59";
        String query = "SELECT AVG(Delay) FROM busData WHERE (Delay BETWEEN -181 AND 181) AND (Reading_Date_Time BETWEEN DATETIME('2013-01-01 "+ beginTime +"') AND DATETIME('2013-01-01 "+ endTime +"')) ;";
        db.query(query);
        while ( db.next ()) {
          float avg = db.getFloat("AVG(Delay)");
          delays.put(endTime.substring(0, 2), avg);
        }
      }
    }
    return delays;
  }
}