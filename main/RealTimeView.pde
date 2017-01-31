//Brian Whelan
import java.util.Date;
import java.text.DateFormat;
public class RealTimeView implements IView {
  RealTimeController controller;
  String stopID = "181";
  RealTimeResponse model;
  ArrayList<Widget> widgets = new ArrayList<Widget>();
  Date d;
  PImage accesible = loadImage("wheelchair.png");
  public RealTimeView(RealTimeController r) {
    controller = r;
    try {
      model = controller.Query(stopID);
    }
    catch (Exception e) {
      println(e);
    }

    //Example of Anonymous classes to handle events - place the code you want to run when the enter key is pressed inside submitted()
    widgets.add(new TextEntry(130, 101, 250, 20, 1, "Enter a stop number", this) {
      @Override
        public void submitted() {
        try {
          ((RealTimeView)parent).stopID = this.getStoredString();
          refresh();
        }
        catch(Exception e) {
        }
      }
    }
    );

    widgets.add(new RefreshButton(778, 98, 32, 32, loadImage("refresh.png"), loadImage("wait.png")) {
      @Override
        public void click() {

        if (model.fresh) {
          println("click");
          refresh();
        }
      }
    }
    );
  }

  String getViewName() {
    return "Real-Time Data";
  }

  void onMadeActive() {
    refresh();
  }

  Thread refresh() {
    d = new Date(); //get date time
    //Thread is used to query the online service without freezing
    Thread queryThread = new Thread(new Runnable() {
      public void run() {
        try {
          model.fresh = false;
          model = controller.Query(stopID);
        }
        catch(Exception e) {
          println("Failed to retrieve stop data: " + e);
        }
      }
    }
    );  
    queryThread.start();
    return queryThread;
  }

  void onRemoved() {
    return;
  }

  void click() {
    for (Widget w : widgets) {
      w.click();
    }
  }

  void mouseWheel(MouseEvent e) {
  }

  void keyPressed() {
    for (Widget w : widgets) {
      w.keyPressed();
    }
  }

  void draw() {

    fill(0, 0, 0);
    textAlign(LEFT);
    textFont(stdFont25);
    text("Stop " + stopID, 10, 120);
    textFont(stdFont11);
    text("Last Updated: " + d.toString(), 500, 120);
    fill(255, 204, 0);
    noStroke();
    rect(10, 130, 800, 20);
    fill(0, 0, 0);
    textAlign(LEFT, CENTER);
    text("Route", 16, 140);
    text("Destination", 119, 140);
    text("Expected Time", 320, 140);
    text("Accesible", 725, 140);
    if (model != null) {
      if (model.errorCode != 0 ) {
        switch(model.errorCode) {
        case 1:
          text("No results found", 16, 160);  
          break;
        case 2:
          text("Please enter a stop number", 16, 160);
          break;
        case 3:
          text("Invalid stop number", 16, 160);  
          break;
        case 4:
          text("The Real-Time Bus service is currently undergoing scheduled maintenance. Please try again later", 16, 160);  
          break;
        case 5:
          text("Unexpected System Error!", 16, 160);  
          break;
        }
      } else if (model.fresh) {
        for (int i = 0; i < model.values().size(); i++) {
          RealTimeBus m = model.values().get(i);
          fill(229, 229, 229);
          rect(10, 150 + (i)*23, 800, 20);
          fill(0, 0, 0);
          text(m.getRoute(), 16, 160+(i)*23);   
          text(m.getOrigin() + " to " + m.getDestination(), 119, 160+(i)*23); 
          text(m.getDueTime() + ((m.getDueTime().equals("Due"))?"":" mins"), 320, 160+(i)*23);
          if (m.isAccesible())
            image(accesible, 725, 150 + (i)*23);
        }
      } else {
        pushMatrix();
        translate(400, 170);
        rotate(radians(frameCount*4));
        image(loadImage("refresh.png"), -16, -16);
        popMatrix();
      }
    }
    for (Widget w : widgets) {
      w.draw();
    }
  }
  void mouseDragged() {
  }
  void mouseReleased() {
  }
}