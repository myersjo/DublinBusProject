//Brian Whelan - encapsulates response from Dublin Bus API
public class RealTimeResponse {
  boolean fresh = false;//Is this response the most recent?
  int errorCode;
  String queryTime;
  String stopID;
  ArrayList<RealTimeBus> buses = new ArrayList<RealTimeBus>(); 
  public RealTimeResponse(int errorCode, String queryTime, String stopID) {
    this.errorCode = errorCode;
    this.queryTime = queryTime;
    this.stopID = stopID;
  }

  ArrayList<RealTimeBus> values() {
    return buses;
  }

  void Add(RealTimeBus b) {
    buses.add(b);
  }

  void Remove(RealTimeBus b) {
    buses.remove(b);
  }
}