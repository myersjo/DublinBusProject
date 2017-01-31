// By Jordan Myers. Containes queries used by Stop View.
public class StopController {
  SQLite db;
  MapController mapControl;

  public StopController (SQLite db, MapController mc) {
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

  // Gets the location for a given stop
  StopModel getStop(String stopID) {
    StopModel stop;
    if ( db.connect() )
    {
      String query = "SELECT longitude, latitude FROM busData WHERE atstop = 1 AND Stop_ID='"+stopID+"' GROUP BY Stop_ID ORDER BY Stop_ID LIMIT 5000;";
      db.query(query);
      while ( db.next ()) {
        stop = new StopModel (Integer.parseInt(stopID), db.getFloat("Longitude"), db.getFloat("Latitude"));
        return stop;
      }
    }
    return null;
  }
  // Returns the total number of stops
  int getTotalNumberOfStops () {
    int stops=0;
    if ( db.connect() )
    {
      String query = "SELECT COUNT(DISTINCT Stop_ID) FROM busData;";
      db.query(query);
      while ( db.next ()) {
        stops=db.getInt("COUNT(DISTINCT Stop_ID)");
      }
    }
    return stops;
  }
}