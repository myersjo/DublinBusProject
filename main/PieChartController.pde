// Written by Jordan Myers. Containes all queries used to create pie charts
import de.bezier.data.sql.*;
import java.util.Map;
public class PieChartController {
  main s;
  SQLite db;

  public PieChartController(main sketch, String connectionString) {
    s = sketch;
    db = new SQLite(s, connectionString);
  }

  // Returns the number of buses that have congestion vs those that don't 
  HashMap<String, Float> getNumberBusesVsCongestion () {
    HashMap<String, Float> congestion = new HashMap<String, Float>();
    Float totalBuses=0.0;
    Float busesCongested=0.0;

    if ( db.connect() )
    {
      String query = "SELECT COUNT(DISTINCT Vehicle_ID) FROM busData;";
      db.query(query);
      while ( db.next ()) {
        totalBuses = db.getFloat("COUNT(DISTINCT Vehicle_ID)");
      }
      query = "SELECT COUNT(DISTINCT Vehicle_ID) FROM busData WHERE Congestion=1;";
      db.query(query);
      while (db.next()) {
        busesCongested=db.getFloat("COUNT(DISTINCT Vehicle_ID)");
      }
      congestion.put("Buses Without Congestion", (totalBuses-busesCongested));
      congestion.put("Buses With Congestion", busesCongested);
    }
    return congestion;
  }
  // Returns the number of buses that have congestion vs those that don't for a specific stop
  HashMap<String, Float> getNumberBusesVsCongestionForStop (String stop) {
    HashMap<String, Float> congestion = new HashMap<String, Float>();
    Float totalBuses=0.0;
    Float busesCongested=0.0;

    if ( db.connect() )
    {
      String query = "SELECT COUNT(DISTINCT Vehicle_ID) FROM busData WHERE AtStop=1 AND Stop_ID=" + stop + ";";
      db.query(query);
      while ( db.next ()) {
        totalBuses = db.getFloat("COUNT(DISTINCT Vehicle_ID)");
      }
      query = "SELECT COUNT(DISTINCT Vehicle_ID) FROM busData WHERE Congestion=1 AND AtStop=1 AND Stop_ID=" + stop + ";";
      db.query(query);
      while (db.next()) {
        busesCongested=db.getFloat("COUNT(DISTINCT Vehicle_ID)");
      }
      congestion.put("Buses Without Congestion", (totalBuses-busesCongested));
      congestion.put("Buses With Congestion", busesCongested);
    }
    return congestion;
  }

  /** Gets the number of buses with congestion per line for all lines. Returns results as HashMap with String=Line and Float=numberBusesCongested */
  /** *********LIMITED TO 15************ */
  HashMap<String, Float> getBreakdownCongestionAllLines() {
    HashMap<String, Float> breakdown = new HashMap<String, Float>();
    if ( db.connect() )
    {
      String query = "SELECT a.line, COUNT(a.Vehicle_ID) FROM busData a INNER JOIN "
        + "(SELECT vehicle_id, line, MAX(Reading_Date_Time) AS MaxDateTime FROM busData "
        + "WHERE Reading_Date_Time BETWEEN DATETIME('2013-01-01 00:00:01') AND DATETIME('2013-01-01 23:59:59') AND congestion = 1 GROUP BY Vehicle_ID) "
        + "grouped ON a.Vehicle_ID = grouped.Vehicle_ID AND a.Reading_Date_Time = grouped.MaxDateTime group by a.line order by a.line LIMIT 15;";
      db.query(query);
      while ( db.next ()) {
        breakdown.put( (db.getString("Line")), (db.getFloat("COUNT(a.Vehicle_ID)")));
      }
    }
    return breakdown;
  }
}