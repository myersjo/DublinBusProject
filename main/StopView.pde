// Outline by Jordan Myers, contributions by Brian Whelan
public class StopView implements IView {
  PApplet main;
  StopController controller;
  BarChartController BCControl;
  PieChartController PCControl;
  int currentStopNum=181;
  StopModel currentStop;
  ArrayList<StopModel> allStops;
  ArrayList<Widget> widgets;
  ArrayList<Widget>overviewWidgets;
  ArrayList<Widget>specificWidgets;
  UnfoldingMap stopMap;
  MarkerManager<Marker> mm;
  Location dublinLocation;
  Sidebar sidebar;
  UIList l;
  String lineList;
  PieChart congestionPC;


  final int MAP_WIDTH=250;
  final int MAP_HEIGHT=250;
  final int MAP_BORDER =3;
  final int MAPX = SCREENX-MAP_WIDTH-MAP_BORDER;
  final int MAPY = SCREENY-MAP_HEIGHT-MAP_BORDER;

  public StopView (PApplet main, StopController controller, BarChartController BCControl, PieChartController PCControl) {
    this.main=main;
    this.controller=controller;
    this.BCControl=BCControl;
    this.PCControl=PCControl;
    dublinLocation = new Location(53.35f, -6.26f);
    widgets=new ArrayList<Widget>();
    overviewWidgets=new ArrayList<Widget>();
    specificWidgets=new ArrayList<Widget>();
    createInitialScreen();
    createOverviewScreen();
    lineList=createListOfLines();
    specificWidgets.add(congestionPC=new PieChart(500, 330, 150, PCControl.getNumberBusesVsCongestionForStop(Integer.toString(currentStopNum)), "Breakdown of Number of buses \n with congestion"));
  }

  //The draw code 
  void draw() {
    if (currentStopNum >0) {
      for (Widget w : specificWidgets) {
        w.draw();
      }
      fill(0);
      textFont(stdFont25);
      textAlign(LEFT);
      text("Stop " + currentStop.stopID, 120, TAB_HEIGHT + 120);
      textFont(stdFont11);

      text("Lines: ", 100, TAB_HEIGHT + 160);
      for (String l : currentStop.getLines()) {
        text(l, 100, 20 * currentStop.getLines().indexOf(l) + 220    );
      }
    } else if (currentStopNum<0) {
      for (Widget w : overviewWidgets) {
        w.draw();
      }
    }
    for (Widget w : widgets) {
      w.draw();
    }
    fill(0);
    rect(MAPX-MAP_BORDER, MAPY-MAP_BORDER, MAP_WIDTH+2*MAP_BORDER, MAP_HEIGHT+2*MAP_BORDER);
    stopMap.draw();
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
    return "Stop View";
  }
  //Mouse clicked
  void click() {
    for (Widget w : widgets) {
      //if (mouseX > w.x && mouseX < w.x + w.width && mouseY < w.y + w.height && mouseY > w.y) { 
      w.click();
      //}
    }
  }
  void keyPressed() {
    for (Widget w : widgets) {
      w.keyPressed();
    }
  }
  void mouseWheel(MouseEvent e) {
    for (Widget w : widgets)
      w.mouseWheel(e);
  }

  // Updates the current selected stop
  void updateCurrrentStop(int stopNum) {
    currentStopNum=stopNum;
    StopModel stop = controller.getStop(Integer.toString(stopNum));
    stop.setLines(controller.getLinesForStop(stop));
    currentStop=stop;
    createListOfLines();
    congestionPC=new PieChart(520, 300, 150, PCControl.getNumberBusesVsCongestionForStop(Integer.toString(currentStopNum)), "Breakdown of Number of buses \n with congestion");
    mm.clearMarkers();
    createStopMarkers();
    stopMap.zoomAndPanTo( (currentStopNum<0) ? (dublinLocation) : ((new Location(currentStop.getLatitude(), currentStop.getLongitude()))), 13 );
  }

  // Updates the current selected stop
  void updateCurrrentStop(StopModel stop) {
    currentStopNum=stop.stopID;
    stop.setLines(controller.getLinesForStop(stop));   
    currentStop=stop;
    createListOfLines();
    congestionPC=new PieChart(520, 300, 150, PCControl.getNumberBusesVsCongestionForStop(Integer.toString(currentStopNum)), "Breakdown of Number of buses \n with congestion");
    mm.clearMarkers();
    createStopMarkers();
    stopMap.zoomAndPanTo( (currentStopNum<0) ? (dublinLocation) : ((new Location(currentStop.getLatitude(), currentStop.getLongitude()))), 13 );
  }

  // Gets all stops
  ArrayList<StopModel> getAllStops() {
    return controller.getAllStops();
  }

  // Creates initial screen
  void createInitialScreen () {

    widgets.add(new TextEntry(375, 100, 250, 20, 2, "Enter a stop number (or -1 for an overview)", this) {
      @Override
        public void submitted() {
        try {
          ((StopView)parent).updateCurrrentStop(Integer.parseInt(this.getStoredString().split(",")[0]));
        }
        catch(Exception e) {
        }
      }
    }
    );

    stopMap = new UnfoldingMap(main, MAPX, MAPY, MAP_WIDTH, MAP_HEIGHT, new Google    .GoogleMapProvider());
    MapUtils.createDefaultEventDispatcher(main, stopMap);
    Location dublinLocation = new Location(53.35f, -6.26f);
    stopMap.zoomAndPanTo(dublinLocation, 10);
    stopMap.setPanningRestriction(dublinLocation, 20);
    stopMap.setZoomRange(10, 18);
    mm= new MarkerManager();
    stopMap.addMarkerManager(mm);
    mm.setMap(stopMap);
    allStops=getAllStops();
    updateCurrrentStop(181);
    ArrayList<StopModel> stops = controller.getAllStops();
    sidebar= new Sidebar(0, 40, 300, 560);
    l =new UIList<StopModel>(40, 100, 260, 400, stops, color(0, 128, 128), this) {
      @Override
        public void selected(final StopModel s) {

        println(s.toString());
        stopMap.panTo(new Location(s.getLatitude(), s.getLongitude()));
        stopMap.zoomLevel(20);
        ((StopView)parent).updateCurrrentStop(s);
      }
    };

    sidebar.addWidget((Widget)new TextEntry(0, 8 + TAB_HEIGHT, 260, 24, 1, "Search", this) {
      @Override
        public void submitted() {
        ((StopView)parent).l.search(getStoredString());
        ((StopView)parent).updateCurrrentStop(Integer.parseInt(this.getStoredString().split(",")[0]));
      }
    }
    );
    sidebar.addWidget(l);
    widgets.add(sidebar);
  }

  void createOverviewScreen() {
  }

  // Creates stop markers for map
  void createStopMarkers () {
    if (currentStopNum<0) {
      for (int i=0; i<allStops.size (); i++) {
        StopModel stop = allStops.get(i);
        Location location = new Location(stop.getLatitude(), stop.getLongitude());
        CustomMarker marker = new CustomMarker(location, stopMarker, stopMap, false);
        mm.addMarker(marker);
      }
    } else {
      Location location = new Location(currentStop.getLatitude(), currentStop.getLongitude());
      CustomMarker marker = new CustomMarker(location, stopMarker, stopMap, true);
      mm.addMarker(marker);
    }
  }
  // Creates a list of lines for the currently selected stop
  String createListOfLines() {
    ArrayList<String> lines = controller.getLinesForStop(currentStop);
    String lineList = "      Lines for this stop:       ";
    for (int i=0; i<lines.size(); i++) {
      lineList=lineList+"\n  " + lines.get(i);
    }
    this.lineList=lineList;
    return lineList;
  }
  void mouseDragged() {
  }
  void mouseReleased() {
  }
}