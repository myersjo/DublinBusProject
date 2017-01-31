// By Jordan Myers. Keyboard controls listed under keyPressed() at the bottom
class MapView implements IView {
  UnfoldingMap map;
  MapController MapControl;
  MarkerManager<Marker> mm;
  Location dublinLocation;
  Sidebar s ;
  UIList l;
  ArrayList<Widget> widgets = new ArrayList<Widget>();
  ArrayList<ModelBus> buses;
  ArrayList<StopModel> stops;
  public MapView(processing.core.PApplet main, MapController m) {
    MapControl = m;
    map = new UnfoldingMap(main, 0, TAB_HEIGHT, SCREENX, (SCREENY-TAB_HEIGHT), new Google.GoogleMapProvider());
    mm = new MarkerManager();
    buses = MapControl.getLonLatAllBuses("13:00:00", "13:02:00");
    stops = MapControl.getAllStops();
    MapUtils.createDefaultEventDispatcher(main, map);
    dublinLocation = new Location(53.35f, -6.26f);
    map.zoomAndPanTo(dublinLocation, 11);
    map.setPanningRestriction(dublinLocation, 20);
    map.setZoomRange(11, 18);
    map.addMarkerManager(mm);
    mm.setMap(map);
    createStopMarkers(stopMarker);
    ArrayList<StopModel> stops = MapControl.getAllStops();
    s= new Sidebar(0, 40, 300, 560);
    l =new UIList<StopModel>(40, 100, 260, 540, stops, color(0, 128, 128), s) {
      @Override
        public void selected(StopModel s) {
        println(s.toString());
        map.panTo(new Location(s.getLatitude(), s.getLongitude()));
        map.zoomLevel(20);
      }
    };
    s.addWidget((Widget)new TextEntry(0, 8 + TAB_HEIGHT, 240, 24, 1, "Enter a time (HH MM)", this) {
      @Override
        public void submitted() {
        ((MapView)parent).createBusMarkers(busMarker, getStoredString());
        println(getStoredString());
      }
    }
    );
    s.addWidget((Widget)new TextEntry(0, 8 + TAB_HEIGHT + 26, 240, 24, 1, "Search for stop", this) {
      @Override
        public void submitted() {
        ((MapView)parent).l.search(getStoredString());
      }
    }
    );
    s.addWidget(l);
    widgets.add(s);
  }

  //The draw code 
  void draw() {
    map.draw();
    if (s.isOpen()) {
      map.move(300, TAB_HEIGHT);
    } else {
      map.move(40, TAB_HEIGHT);
    }
    for (Widget w : widgets) {
      w.draw();
    }
    // Temporary code for testing stop locations on map p displays lat/lon of mouse 
    Location location = map.getLocation(mouseX, mouseY);
    fill(0);
    text(location.getLat() + ", " + location.getLon(), mouseX, mouseY);
  }

  // Creates a single marker
  void createMarker(PImage stopMarker, Location location) {
    CustomMarker marker = new CustomMarker(location, stopMarker, selectedStop, map);
    mm.addMarker(marker);
  }

  // Creates markers for all stops
  void createStopMarkers(final PImage stopMarker) {

    for (int i=0; i<stops.size (); i++) {
      StopModel stop = stops.get(i);
      Location location = new Location(stop.getLatitude(), stop.getLongitude());
      CustomMarker marker = new CustomMarker(location, stopMarker, map, false, false, stop, null);
      mm.addMarker(marker);
    }
  }
  // Create bus markers for the default time
  void createBusMarkers(final PImage busMarker) {

    for (int i=0; i<buses.size (); i++) {
      ModelBus bus = buses.get(i);
      Location location = new Location(bus.getLatitude(), bus.getLongitude());
      CustomMarker marker = new CustomMarker(location, busMarker, map, false, true, null, bus);
      mm.addMarker(marker);
    }
  }
  // Create bus markers for the user-specified time
  void createBusMarkers(final PImage busMarker, String time) {
    println(time);
    Scanner scanner = new Scanner(time);
    scanner.useDelimiter(" ");
    int beginHour=0;
    if (scanner.hasNextInt())
      beginHour = scanner.nextInt();
    int beginMin=0;
    if (scanner.hasNextInt()) 
      beginMin=scanner.nextInt();
    scanner.close();
    String beginTime ="";
    if (time.length()>5)
      beginTime=time.substring(0, 2)+":"+time.substring(3, 5)+":00";
    int endMin, endHour;
    String endTime;
    // determine if time 'overflows'
    if (beginMin==58 || beginMin==59) {
      switch(beginMin) {
      case 58:
        endMin=00;
        break;
      case 59: 
        endMin=01;
        break;
      default: 
        endMin=(beginMin+2);
      }
      if (beginHour==23)
        endHour=0;
      else
        endHour=(beginHour+1);
    } else {
      endHour=beginHour;
      endMin=(beginMin+2);
    }
    // create endTime in format 'HH:MM:SS'
    if (endHour<10) {
      if (endMin<10)
        endTime="0"+endHour+":0"+endMin+":00";
      else
        endTime="0"+endHour+":"+endMin+":00";
    } else {
      if (endMin<10)
        endTime=Integer.toString(endHour)+":0"+Integer.toString(endMin)+":00";
      else
        endTime=endHour+":"+endMin+":00";
    }
    buses = MapControl.getLonLatAllBuses(beginTime, endTime);
    mm.clearMarkers();
    for (int i=0; i<buses.size (); i++) {
      ModelBus bus = buses.get(i);
      Location location = new Location(bus.getLatitude(), bus.getLongitude());
      CustomMarker marker = new CustomMarker(location, busMarker, map, false, true, null, bus);
      mm.addMarker(marker);
    }
  }
  //Called when the view is made active - does not initialise the view, use the constructor
  void onMadeActive() {
    map.zoomAndPanTo(dublinLocation, 11);
  }
  //Called when the view is removed from the active position - does not destroy the view, so don't remove anything here
  void onRemoved() {
    s.close();
  }
  //The name of the view, which is displayed on the tab for the view - (getName() is used by processing)
  String getViewName() {
    return "Map View";
  }
  void click() {
    for (Widget w : widgets) {
      w.click();
    }
    Marker hitMarker = map.getFirstHitMarker((float)mouseX, (float)mouseY);
    if (hitMarker != null) {
      // Deselect all markers
      for (Marker marker : map.getMarkers()) {
        marker.setSelected(false);
      }
      // Select current marker 
      hitMarker.setSelected(true);
    } else {
      // Deselect all other markers
      for (Marker marker : map.getMarkers()) {
        marker.setSelected(false);
      }
    }
  }

  void mouseWheel(MouseEvent e) {
    println("Map");
    for (Widget w : widgets) {
      w.mouseWheel(e);
    }
  }

  void keyPressed() {
    for (Widget w : widgets) {
      w.keyPressed();
    }
    if (key=='c') 
      mm.clearMarkers();
    else if (key=='s') 
      createStopMarkers(stopMarker);
    else if (key=='b') {

      createBusMarkers(busMarker);
    }
  }
  void mouseDragged() {
  }
  void mouseReleased() {
  }
}