//Brian Whelan - A Bus object - an arraylist of this object is stored as part of the RealTimeResponse
public class RealTimeBus {
  String dueTime;
  String destination;
  String origin;
  String route;
  boolean lowFloor;
  public RealTimeBus() {
  }

  boolean isAccesible() {
    return lowFloor;
  }

  String getDueTime() {
    return dueTime;
  }

  String getRoute() {
    return route;
  }

  String getOrigin() {
    return origin;
  }

  String getDestination() {
    return destination;
  }

  void setDueTime(String time) {
    dueTime = time;
  }

  void setRoute(String id) {
    route = id;
  }

  void setOrigin(String from) {
    origin = from;
  }

  void setDestination(String dest) {
    destination = dest;
  }

  void setAccesible(String hasLowFloor) {
    lowFloor = (hasLowFloor.equals("no"))? true: false;
  }

  String toString() {
    String endText = (getDueTime().equals("Due"))?"": "mins";
    return "Route: " + getRoute() + " " + getOrigin() + " to " + getDestination() + " Due: " + getDueTime() + " " + endText;
  }
}