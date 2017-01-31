// By Brian Whelan. Used in all screens except Home
public class Sidebar extends Widget implements IView {
  ArrayList<Widget> items = new ArrayList<Widget>();
  boolean open = false;
  PImage menu;
  public Sidebar(int x, int y, int width, int height) {
    super(x, y, width, height);
    menu = loadImage("hamburgermenu.png");
  }

  void addWidget(Widget w) {
    w.setX(w.getX() + 40);
    items.add(w);
  }

  void open() {
    open = true;
  }

  boolean isOpen() {
    return open;
  }

  void close() {
    open = false;
  }

  String getViewName() {
    return "Sidebar";
  }

  void onMadeActive() {
  }

  void onRemoved() {
  }

  void mouseWheel(MouseEvent e) {
    println("sidebar");
    if (!open)
      return;
    for (Widget w : items) {
      w.mouseWheel(e);
    }
  }

  void draw() {
    pushStyle();
    noStroke();
    if (open) {
      fill(128, 128, 128, 128);
      rect(0, TAB_HEIGHT, 1000, 600);
      fill(0, 128, 128);
      rect(x, y, this.width, height);
      for (Widget w : items) {
        w.draw();
      }
    } else {
      fill(0, 128, 128);
      rect(x, y, 40, height);
    }

    image(menu, 0, TAB_HEIGHT);
    popStyle();
  }


  void click() {

    for (Widget w : items) {
      if (open)
        w.click();
    }
    if (mouseX > this.width)
      close();
    if ((mouseX > 0 && mouseX < 40 && mouseY > y && mouseY < y + 40) || (open && mouseX > this.width))
      open = !open;
  }

  void keyPressed() {
    if (!open)
      return;
    for (Widget w : items) {
      w.keyPressed();
    }
  }
  void mouseReleased() {
  }
  void mouseDragged() {
  }
}