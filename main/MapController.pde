// By Jordan Myers. Contains queries for MapView and HomeView
import de.bezier.data.sql.*;
public class MapController {
  main s;
  SQLite db;

  public MapController(main sketch, String connectionString) {
    s = sketch;
    db = new SQLite(s, connectionString);
  }

  // Returns the last recorded position of all buses within a given time period - minimum details
  ArrayList<ModelBus> getLonLatAllBusesShort (String beginTime, String endTime) {
    ArrayList<ModelBus> buses = new ArrayList<ModelBus>();
    if ( db.connect() )
    {
      // Date can be changed/passed as a String
      String query = "SELECT a.Vehicle_ID, a.Longitude, a.Latitude, a.Reading_Date_Time FROM busData a INNER JOIN "
        + "(SELECT Vehicle_ID, MAX(Reading_Date_Time) AS MaxDateTime FROM busData WHERE Reading_Date_Time BETWEEN DATETIME('2013-01-01 "+ beginTime +"') AND DATETIME('2013-01-01 "+ endTime +"') " 
        + "GROUP BY Vehicle_ID) grouped ON a.Vehicle_ID = grouped.Vehicle_ID AND a.Reading_Date_Time = grouped.MaxDateTime order by a.Vehicle_ID;";
      db.query(query);
      print(" Longitude and Latitude of all buses between " + beginTime + " and " + endTime);
      while ( db.next ()) {
        ModelBus bus = new ModelBus (db.getInt("Vehicle_ID"), db.getFloat("Longitude"), db.getFloat("Latitude"));
        db.getDate("Reading_Date_Time");
        buses.add(bus);
      }
    }
    return buses;
  }

  // Returns the last recorded position of all buses within a given time period - including more details
  ArrayList<ModelBus> getLonLatAllBuses (String beginTime, String endTime) {
    ArrayList<ModelBus> buses = new ArrayList<ModelBus>();
    if ( db.connect() )
    {
      // Date can be changed/passed as a String
      String query = "SELECT a.Vehicle_ID, a.Longitude, a.Latitude, a.Line, a.Congestion, a.Delay FROM busData a INNER JOIN "
        + "(SELECT Vehicle_ID, MAX(Reading_Date_Time) AS MaxDateTime FROM busData WHERE Reading_Date_Time BETWEEN DATETIME('2013-01-01 "+ beginTime +"') AND DATETIME('2013-01-01 "+ endTime +"') " 
        + "GROUP BY Vehicle_ID) grouped ON a.Vehicle_ID = grouped.Vehicle_ID AND a.Reading_Date_Time = grouped.MaxDateTime order by a.Vehicle_ID;";
      db.query(query);
      print(" Longitude and Latitude of all buses between " + beginTime + " and " + endTime);
      while ( db.next ()) {
        ModelBus bus = new ModelBus (db.getInt("Vehicle_ID"), db.getFloat("Longitude"), db.getFloat("Latitude"), db.getInt("Line"), db.getBoolean("Congestion"), db.getInt("Delay"));
        buses.add(bus);
      }
    }
    return buses;
  }

  // Gets the longitude and latitude of all stops
  ArrayList<StopModel> getAllStops () {
    ArrayList<StopModel> stops = new ArrayList<StopModel>();
    if ( db.connect() )
    {
      String query = "SELECT Stop_ID, longitude, latitude FROM busData WHERE atstop = 1 GROUP BY Stop_ID ORDER BY Stop_ID LIMIT 5000;";
      db.query(query);
      while ( db.next ()) {
        StopModel stop = new StopModel (db.getInt("Stop_ID"), db.getFloat("Longitude"), db.getFloat("Latitude"));
        stops.add(stop);
      }
    }
    return stops;
  }

  // Gets the longitude and latitude of stops on a line
  ArrayList<StopModel> getStopsForLine (String line) {
    ArrayList<StopModel> stops = new ArrayList<StopModel>();
    if ( db.connect() )
    {
      String query = "SELECT Stop_ID, longitude, latitude FROM busData WHERE atstop = 1 AND Line=" + line + " GROUP BY Stop_ID ORDER BY Stop_ID LIMIT 100;";
      db.query(query);
      while ( db.next ()) {
        StopModel stop = new StopModel (db.getInt("Stop_ID"), db.getFloat("Longitude"), db.getFloat("Latitude"));
        stops.add(stop);
      }
    }
    return stops;
  }

  // Sets the lines for a stop and returns the list
  ArrayList<String> getLinesForStop (StopModel stop) {
    ArrayList<String> lines = new ArrayList<String>();
    if ( db.connect() )
    {
      String query = "SELECT Line FROM busData WHERE Atstop=1 AND Stop_ID="+stop.getStopID()+ " GROUP BY Line ORDER BY Line;";
      db.query(query);
      while ( db.next ()) {
        lines.add(db.getString("Line"));
      }
    }
    stop.setLines(lines);
    return lines;
  }

  // Returns the total number of unique buses (vehicles)
  int getTotalNumberOfBuses() {
    int totalNumberOfBuses=0;
    if ( db.connect() )
    {
      String query = "SELECT COUNT(DISTINCT Vehicle_ID) FROM busData;";
      db.query(query);
      while ( db.next ()) {
        totalNumberOfBuses=db.getInt("COUNT(DISTINCT Vehicle_ID)");
      }
    }
    return totalNumberOfBuses;
  }
  // Returns the total number of unique lines
  int getTotalNumberOfLines() {
    int totalNumberOfLines=0;
    if ( db.connect() )
    {
      String query = "SELECT COUNT(DISTINCT Line) FROM busData;";
      db.query(query);
      while ( db.next ()) {
        totalNumberOfLines=db.getInt("COUNT(DISTINCT Line)");
      }
    }
    return totalNumberOfLines;
  }
  // Returns the total number of unique stops
  int getTotalNumberOfStops() {
    int totalNumberOfStops=0;
    if ( db.connect() )
    {
      String query = "SELECT COUNT(DISTINCT Stop_ID) FROM busData;";
      db.query(query);
      while ( db.next ()) {
        totalNumberOfStops=db.getInt("COUNT(DISTINCT Stop_ID)");
      }
    }
    return totalNumberOfStops;
  }

  // Returns the total number of unique operators
  int getTotalNumberOfOperators() {
    int operators=0;
    if ( db.connect() )
    {
      String query = "SELECT COUNT(DISTINCT BusOperator) FROM busData;";
      db.query(query);
      while ( db.next ()) {
        operators=db.getInt("COUNT(DISTINCT BusOperator)");
      }
    }
    return operators;
  }

  // Returns the average delay for all entries, where -181<averageDelay<181
  int getOverallAverageDelay () {
    int delay=0;
    if ( db.connect() )
    {
      String query = "SELECT AVG(Delay) FROM busData WHERE Delay BETWEEN -181 AND 181;";
      db.query(query);
      while ( db.next ()) {
        delay=db.getInt("AVG(Delay)");
      }
    }
    return delay;
  }
}