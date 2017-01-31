// By Brian Whelan. Used by List class
public class ListItem<T> extends Widget {
  String label;
  boolean hover;
  UIList parent;
  T object;
  public ListItem(int x, int y, int width, int height, UIList<T> l, T t) {
    super(x, y, width, height);         
    label = t.toString();
    parent = l;
    object = t;
  }

  void draw() {
    pushStyle();
    if (checkHover())
      fill(255, 255, 255);
    else
      fill(200, 200, 200);

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
    if (mouseX > this.x && mouseX < (this.x + this.width) && mouseY > this.y && mouseY < this.y + this.height)
      parent.selected(object);
  }
}