// By Jordan Myers. Used by LineView
public class LineController {
  SQLite db;
  MapController mapControl;

  public LineController (SQLite db, MapController mc) {
    this.db=db;
    this.mapControl=mc;
  }

  // Gets the longitude and latitude of all stops
  ArrayList<StopModel> getAllStops () {
    return mapControl.getAllStops();
  }

  // Gets the lines for a stop and returns the list
  ArrayList<String> getLinesForStop (StopModel stop) {
    return mapControl.getLinesForStop(stop);
  }
  
  // Gets the stops for a line and returns the list
  ArrayList<StopModel> getStopsForLine (String line) {
    return mapControl.getStopsForLine(line);
  }
  
  ArrayList<String> getAllLines () {
    ArrayList<String> lines = new ArrayList<String>();
    if ( db.connect() )
    {
      String query = "SELECT DISTINCT Line FROM busData;";
      db.query(query);
      while ( db.next ()) {
        lines.add(db.getString("Line"));
      }
    }
    return lines;
  }
  String getNumberOfStopsForLine (String line) {
    String number="";
    if ( db.connect() )
    {
      String query = "SELECT COUNT(DISTINCT STOP_ID) FROM busData WHERE Line=" + line + " AND AtStop=1;";
      db.query(query);
      while ( db.next ()) {
        number=(db.getString("COUNT(DISTINCT STOP_ID)"));
      }
    }
    return number;
  }
  // Returns the average delay for all entries, where -181<averageDelay<181
  int getAverageDelayForLine (String line) {
    int delay=0;
    if ( db.connect() )
    {
      String query = "SELECT AVG(Delay) FROM busData WHERE Line=" + line + " AND Delay>-181 GROUP BY Line ORDER BY Line;";
      db.query(query);
      while ( db.next ()) {
        delay=db.getInt("AVG(Delay)");
      }
    }
    return delay;
  }
  
  String getNumberOfBusesForLine (String line) {
    String number="";
    if ( db.connect() )
    {
      String query = "SELECT COUNT(DISTINCT Vehicle_ID) FROM busData WHERE Line=" + line + ";";
      db.query(query);
      while ( db.next ()) {
        number=(db.getString("COUNT(DISTINCT Vehicle_ID)"));
      }
    }
    return number;
  }
  
}