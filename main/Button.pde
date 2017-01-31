// By Brian Whelan
public class Button extends Widget {
  String label;
  boolean hover;
  public Button(int x, int y, int width, int height, String text) {
    super(x, y, width, height);         
    label = text;
  }

  void draw() {
    pushStyle();
    if (checkHover())
      stroke(255);
    else
      stroke(0);
    fill(255, 255, 255);
    rect(x, y, width, height);
    fill(0);
    textAlign(LEFT, CENTER);
    text(label, x + 10, y + (this.height/2));
    popStyle();
  }
  boolean checkHover() {
    if (mouseX > this.x && mouseX < (this.x + this.width) && mouseY > this.y && mouseY < this.y + this.height) {
      return false;
    } else {
      return true;
    }
  }
  void click() {
  }
}