//Brian Whelan
public class Tabs {
  ArrayList<IView> views;
  int activeView = 0;
  IView currentView;
  //The parameter for the construction ensures that there is always at least 1 view present in the tab - it is the active view at launch
  public Tabs(IView v) { 
    views = new ArrayList<IView>();
    views.add(v);
    currentView = views.get(0);
  }

  //Register a new View - creates a tab for that view
  void registerView(IView v) {
    views.add(v);
  }

  void mouseWheel(MouseEvent e) {
    currentView.mouseWheel(e);
  }

  //Draw the tabs and current view
  void draw() {
    currentView.draw();
    int width = 1000/views.size(); 
    for (IView v : views) {
      strokeWeight(2);
      if (views.indexOf(v) == activeView) {
        stroke(43, 43, 43);
        fill(43, 43, 43);
        rect(width*views.indexOf(v), 0, width, 40);
        fill(255, 255, 255);
        textAlign(CENTER, CENTER);
        text(v.getViewName(), width*views.indexOf(v) + (width/2), 20);
      } else {
        fill(23, 23, 23);
        stroke(23, 23, 23);
        rect(width*views.indexOf(v), 0, width, 40);
        fill(162, 162, 162);
        textAlign(CENTER, CENTER);
        text(v.getViewName(), width*views.indexOf(v) + (width/2), 20);
      }
    }
  }

  void keyPressed() {
    currentView.keyPressed();
  }
  void mouseDragged() {
    currentView.mouseDragged();
  }
  void mouseReleased() {
    currentView.mouseReleased();
  }

  //Handle tab switching
  void click() {
    int width = 1000/views.size();  
    for (IView v : views) {
      if (mouseX > width*views.indexOf(v) && mouseX < width*views.indexOf(v) + width && mouseY < 40 && mouseY > 0) {
        currentView.onRemoved();
        currentView = v;
        activeView = views.indexOf(v);
        currentView.onMadeActive();
        return;
      }
    }
    currentView.click();
  }
}