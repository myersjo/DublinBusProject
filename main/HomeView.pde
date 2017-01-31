// Outline by Jordan Myers (following IView interface), contributions from the whole team
public class HomeView implements IView {
  BarChartController BCControl;
  PieChartController PCControl;
  ArrayList<Widget> widgets;
  Slider slider; 
  MapBarchart delaysBC;
  String details;

  public HomeView (BarChartController BCControl, PieChartController PCControl) {
    this.BCControl=BCControl;
    this.PCControl=PCControl;
    widgets= new ArrayList<Widget>();
    widgets.add(new MapBarchart("Total Number of Buses per Operator", BCControl.getNumberOfBusesPerOperator(), 400, 150, 50, 400));
    widgets.add(delaysBC=new MapBarchart("Delay (in seconds) by Hour", BCControl.getAverageDelayByHourTree(), 400, 220, 550, 100));
    widgets.add(new PieChart(650, 500, 175, PCControl.getNumberBusesVsCongestion(), "Total Number of Buses With and Without Congestion"));
    //String[] labels = new String[24];
    String[] labels = BCControl.getAverageDelayByHourTree().keySet().toArray(new String[0]);
    for (int i=6; i< labels.length; i++) {
      if (i<10)
        labels[i]= "0" +i + ":00";
      else 
      labels[i]= i + ":00";
    }
    slider = new Slider(50, 550, 200, 20, 1, labels);
    createDetails();
  }

  //The draw code 
  void draw() {
    for (Widget w : widgets) {
      w.draw();
    }
    slider.draw();
    fill(0);
    textFont(stdFont25);
    text(details, 100, 150);
    textFont(stdFont11);
  }
  //Called when the view is made active - does not initialise the view, use the constructor
  void onMadeActive() {
  }
  //Called when the view is removed from the active position - does not destroy the view, so don't remove anything here
  void onRemoved() {
  }
  //The name of the view, which is displayed on the tab for the view - (getName() is used by processing)
  String getViewName() {
    return "Home";
  }
  //Mouse clicked
  void click() {
    slider.mousePressed();
  }
  void keyPressed() {
    for (Widget w : widgets) {
      w.keyPressed();
    }
  }
  void mouseWheel(MouseEvent e) {
    for (Widget w : widgets) {
      w.mouseWheel(e);
    }
  }
  void mousePressed() {
    slider.mousePressed();
  }
  void mouseDragged() {
    slider.mouseDragged();
  }
  void mouseReleased() {
    slider.mouseReleased();
  }

  void sliderUpdate() {
    int index=(int)slider.getSliderValue();
    TreeMap<String, Float> bc = BCControl.getAverageDelayByHourTree();
    String[] labels=bc.keySet().toArray(new String[0]);
    Float[] values= bc.values().toArray(new Float[0]);
    TreeMap<String, Float> newBC = new TreeMap<String, Float>();
    for (int i =0; (i<=index && i<labels.length); i++) {
      newBC.put(labels[i], values[i]);
    }
    delaysBC=new MapBarchart("Delay (in seconds) by Hour", newBC, 400, 400, 50, 100);
  }
  
  String createDetails () {
   String line = "Total number of stops: " + MapControl.getTotalNumberOfStops()  
     + "\n Total number of buses: " + MapControl.getTotalNumberOfBuses()
     + "\n Total number of lines: " + MapControl.getTotalNumberOfLines()
     + "\n Total number of operators: " + MapControl.getTotalNumberOfOperators()
     + "\n Average delay for all lines: " + MapControl.getOverallAverageDelay();
   this.details=line;
   return line;
  }
}