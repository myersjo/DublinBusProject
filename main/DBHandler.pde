// DEPRECATED - queries are now in their relevant controllers
// Outline by Brian Whelan, queries by Jordan Myers
import de.bezier.data.sql.*;
public class DBHandler {
  main s;
  SQLite db;

  public DBHandler(main sketch, String connectionString) {
    s = sketch;
    db = new SQLite(s, connectionString);
  }   

  //Query the database using the query string passed through. Returns an ArrayList of ModelBus based on query, or an empty arraylist if no results were found
  ArrayList<ModelBus> busQuery(String query) {
    ArrayList<ModelBus> buses = new ArrayList<ModelBus>();
    if (db.connect()) {
      db.query(query);
      while (db.next ()) {
        ModelBus b = new ModelBus(db.getLong("Reading_Date_Time"), db.getInt("Line"), db.getInt("Congestion"), db.getFloat("Longitude"), 
        db.getFloat("Latitude"), db.getInt("Delay"), db.getInt("Vehicle_ID"), db.getInt("Stop_ID"), db.getBoolean("AtStop"));
        buses.add(b);
      }
    }
    return buses;
  }

  


}