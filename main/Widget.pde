// By Brian Whelan. All UI elements extend this class
class Widget {
  int width = 0;
  int height = 0;
  public int x = 0;
  int y = 0;
  public Widget(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
  }

  void setX(int x) {
    this.x = x;
  }

  int getX() {
    return x;
  }

  void draw() {
  }

  void mouseWheel(MouseEvent e) {
  }

  void click() {
  }

  void keyPressed() {
  }

  void submitted() {
  }
}