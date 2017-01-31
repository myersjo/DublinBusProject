// Written by Brian Whelan. Holds data for buses used in Map View.
public class ModelBus {
  long timeStamp;
  int id;
  int line;
  int congestion;
  boolean congested;
  float longitude;
  float latitude;
  int delay;
  boolean atStop;
  int stopID;


  public ModelBus(long Reading_Date_Time, int Line, int Congestion, float Longitude, 
  float Latitude, int Delay, int vID, int Stop_ID, boolean AtStop ) {
    id = vID;
    timeStamp = Reading_Date_Time;
    line = Line;
    congestion = Congestion;
    longitude = Longitude;
    latitude = Latitude;
    delay = Delay;
    stopID = Stop_ID;
    atStop = AtStop;
  }
  
  public ModelBus(int vehicleID, float longitude, float latitude) {
    this.id=vehicleID;
    this.longitude=longitude;
    this.latitude=latitude;        
  }
  public ModelBus(int vehicleID, float longitude, float latitude, int line, boolean congestion, int delay) {
    this.id=vehicleID;
    this.longitude=longitude;
    this.latitude=latitude;
    this.line=line;
    this.congested=congestion;
    this.delay=delay;
  }



  //Get-Set methods for the Bus - Use these rather than accessing the variables directly

  int getLine() { 
    return line;
  }
  int getID() { 
    return id;
  }
  boolean isAtStop() { 
    return atStop;
  }
  int getNextStop_ID() { 
    return stopID;
  }
  float getLatitude() {
    return latitude;
  }
  float getLongitude() {
    return longitude;
  }
  int getDelay() {
    return delay;
  }
  int getCongestion() {
    return congestion;
  }
  boolean getCongested() {
    return congested;
  }

  void setLine(int value) {
    line = value;
  }
  void setID(int value) {
    id = value;
  }
  void setLatitude(float value) {
    latitude = value;
  }
  void setLongitude(float value) {
    longitude = value;
  }
  void setAtStop(boolean value) { 
    atStop = value;
  }
  void setAtStop(boolean value, int id) { 
    atStop = value;
    stopID = id;
  }
}