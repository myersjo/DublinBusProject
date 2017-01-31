public class LineView implements IView {
  LineController controller;
  BarChartController BCControl;
  PieChartController PCControl;
  ArrayList<StopModel> allStops;
  ArrayList<Widget> widgets;
  ArrayList<Widget>overviewWidgets;
  ArrayList<Widget>specificWidgets;
  MapBarchart averageDelaysBC;
  PieChart breakdownCongestionPC;
  UnfoldingMap lineMap;
  MarkerManager<Marker> mm;
  PApplet main;
  int currentLine=747;
  Sidebar sidebar;
  UIList list;
  String details;

  final int MAP_WIDTH=250;
  final int MAP_HEIGHT=250;
  final int MAP_BORDER =3;
  final int MAPX = SCREENX-MAP_WIDTH-MAP_BORDER;
  final int MAPY = SCREENY-MAP_HEIGHT-MAP_BORDER;

  public LineView (PApplet main, LineController controller, BarChartController BCControl, PieChartController PCControl) {
    this.main=main;
    widgets=new ArrayList<Widget>();
    overviewWidgets=new ArrayList<Widget>();
    specificWidgets=new ArrayList<Widget>();
    this.controller=controller;
    this.BCControl=BCControl;
    this.PCControl=PCControl;
    allStops=controller.getAllStops();
    createInitialScreen();
    createOverviewScreen();
    details=createDetails();
  }

  void click() {
    for (Widget w : widgets) {
      w.click();
    }
    Marker hitMarker = lineMap.getFirstHitMarker((float)mouseX, (float)mouseY);
    if (hitMarker != null) {
      // Deselect all markers
      for (Marker marker : lineMap.getMarkers()) {
        marker.setSelected(false);
      }
      // Select current marker 
      hitMarker.setSelected(true);
    } else {
      // Deselect all other markers
      for (Marker marker : lineMap.getMarkers()) {
        marker.setSelected(false);
      }
    }
  }

  void keyPressed() {
    for (Widget w : widgets) {
      w.keyPressed();
    }
  }

  void draw() {
    if (currentLine >0) {
      for (Widget w : specificWidgets) {
        w.draw();
      }
      pushStyle();
      textFont(stdFont25);
      fill(255);
      rect(500-textWidth(details)/2, 150, textWidth(details)+10, 110);
      fill(0);
      text(details, 500, 200); 
      textFont(lcd48);
      fill(0);
      rect(SCREENX/2-50,TAB_HEIGHT+18, 100,70, 25);
      fill(255,105,0);
      text(currentLine, SCREENX/2-5, TAB_HEIGHT+42);
      popStyle();
    } else if (currentLine<0) {
      for (Widget w : overviewWidgets) {
        w.draw();
      }
    }
    for (Widget w : widgets) {
      w.draw();
    }
    fill(0);
    rect(MAPX-MAP_BORDER, MAPY-MAP_BORDER, MAP_WIDTH+2*MAP_BORDER, MAP_HEIGHT+2*MAP_BORDER);
    lineMap.draw();
    sidebar.draw();
  }
  //Called when the view is made active - does not initialise the view, use the constructor
  void onMadeActive() {
  }
  //Called when the view is removed from the active position - does not destroy the view, so don't remove anything here
  void onRemoved() {
  }
  //The name of the view, which is displayed on the tab for the view - (getName() is used by processing)
  String getViewName() {
    return "Line View";
  }

  ArrayList<StopModel> getAllStops() {
    return allStops;
  }
  ArrayList<String> getLinesForStop(StopModel stop) {
    return controller.getLinesForStop(stop);
  }
  void updateCurrentLine(int line) {
    this.currentLine=line;
    mm.clearMarkers();
    createStopMarkers();
    createDetails();

    if (currentLine>0) {
      String[] lines = new String[1];
      lines[0]= Integer.toString(line);//""+line;

      updateBarChart(lines);
    } else {
      String[] lines = {
        "1", "4", "7", "9", "13", "15", "123", "747"};
      updateBarChart(lines);
    }
  }
  void mouseWheel(MouseEvent e) {
    for (Widget w : widgets) {
      w.mouseWheel(e);
    }
  }
  void createInitialScreen () {

    widgets.add(new TextEntry(75, 500, 250, 20, 1, "Enter a series of comma-seperated routes", this) {
      @Override
        public void submitted() {
        try {
          ((LineView)parent).updateBarChart(this.getStoredString().split(","));
        }
        catch(Exception e) {
        }
      }
    }
    );
    String[] lines = {
      "1", "4", "7", "9", "13", "15", "123", "747"
    };

    widgets.add(averageDelaysBC=new MapBarchart("Average Delays per Line (seconds)", BCControl.getAverageDelayForLine(lines), 280, 280, 75, 175) {
      @Override
        public void submitted() {
        try {
        }
        catch(Exception e) {
        }
      }
    }
    );

    lineMap = new UnfoldingMap(main, MAPX, MAPY, MAP_WIDTH, MAP_HEIGHT, new Google.GoogleMapProvider());
    MapUtils.createDefaultEventDispatcher(main, lineMap);
    Location dublinLocation = new Location(53.35f, -6.26f);
    lineMap.zoomAndPanTo(dublinLocation, 11);
    lineMap.setPanningRestriction(dublinLocation, 20);
    lineMap.setZoomRange(11, 18);
    mm= new MarkerManager();
    lineMap.addMarkerManager(mm);
    mm.setMap(lineMap);
    createStopMarkers();

    sidebar= new Sidebar(0, 40, 300, 560);
    sidebar.addWidget((Widget)new TextEntry(0, 8 + TAB_HEIGHT, 200, 20, 1, "Search", null));
    ArrayList<LineModel> allLines = new ArrayList<LineModel>();

    allLines.add(new LineModel("Overview", -1));
    ArrayList<String> lineStrings = controller.getAllLines();
    for (String s : lineStrings) {
      println(s);
      try {
        allLines.add(new LineModel("Line " + s, Integer.parseInt(s)));
      }
      catch(Exception e) {
      }
    }

    list =new UIList<LineModel>(40, 100, 260, 400, allLines, color(0, 128, 128), this) {
      @Override
        public void selected(final LineModel s) {
        updateCurrentLine(s.lineID);
      }
    };
    sidebar.addWidget(list);
    widgets.add(sidebar);
  }

  void createOverviewScreen() {
    overviewWidgets.add(breakdownCongestionPC=new PieChart(520, 300, 150, PCControl.getBreakdownCongestionAllLines(), "Breakdown of Number of buses with \n congestion per line") {
      @Override
        public void submitted() {
        try {
        }
        catch(Exception e) {
        }
      }
    }
    );
  }

  // Creates markers for a line if selected, if line<0, shows all stops (for overview)
  void createStopMarkers() {
    String line = Integer.toString(currentLine);
    ArrayList<StopModel> stops = (currentLine<0)?controller.getAllStops():controller.getStopsForLine(line);
    for (int i=0; i<stops.size (); i++) {
      StopModel stop = stops.get(i);
      Location location = new Location(stop.getLatitude(), stop.getLongitude());
      CustomMarker marker = new CustomMarker(location, stopMarker, lineMap, false, false, stop, null);
      mm.addMarker(marker);
    }
  }
  String createDetails () {
    String line = "Total number of stops: " + controller.getNumberOfStopsForLine(Integer.toString(currentLine)) 
      + "\n Average delay for line: " + controller.getAverageDelayForLine(Integer.toString(currentLine))
      + "\n Total number of buses: " + controller.getNumberOfStopsForLine(Integer.toString(currentLine));
    this.details=line;
    return line;
  }
  void updateBarChart(String[] lines) {
    averageDelaysBC.Update(BCControl.getAverageDelayForLine(lines));
  }
  void mouseDragged() {
  }
  void mouseReleased() {
  }
}