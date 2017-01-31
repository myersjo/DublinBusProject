// Written by Brian Whelan. Holds data used by Stop Maps
public class StopModel {

  int stopID=-1;
  float latitude = 0.0f;
  float longitude = 0.0f;  
  boolean hasBus = false;
  ArrayList<String> lines;
  public StopModel(int stopID, float longi, float lat) {
    this.stopID=stopID;
    longitude = longi;
    latitude = lat;
  }   

  int getStopID() {
    return stopID;
  }
  float getLatitude() {
    return latitude;
  }
  float getLongitude() {
    return longitude;
  }
  ArrayList<String> getLines() {
    return lines;
  }

  void setStopID(int id) {
    this.stopID=id;
  }
  void setLatitude(float l) {
    latitude = l;
  }
  void setLongitude(float l) {
    longitude = l;
  }
  void setLines(ArrayList<String> lines) {
    this.lines=lines;
  }

  String toString() {
    return "Stop " + stopID;
  }
}