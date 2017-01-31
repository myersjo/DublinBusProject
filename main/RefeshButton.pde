// By Brian Whelan
public class RefreshButton extends Widget {
  PImage ready;
  PImage working;
  PImage current;
  public RefreshButton(int x, int y, int width, int height, final PImage ready, final PImage working) {
    super(x, y, width, height);         
    this.ready = ready;
    this.working = working;
    current = ready;
  }

  void draw() {
    noStroke();
    fill(255, 255, 255);
    rect(x, y, width, height);
    image(ready, x, y);
  }

  void click() {
  }
}