// By Brian Whelan. Used for lists in the sidebars
public class UIList<T> extends Widget {
  ArrayList<T> items = new ArrayList<T>();
  ArrayList<ListItem> buttons = new ArrayList<ListItem>();
  int scrollOffset = 0;
  int x, y, width, height;
  color bgColor;
  IView parent;
  public UIList(int x, int y, int width, int height, ArrayList<T> m, color c, IView p) {
    super(x, y, width, height);
    bgColor = c;
    this.x = x;
    this.y = y;
    parent = p;
    this.width = width;
    this.height = height;
    items = m;
    for (int i = 0; i < items.size(); i++) {
      buttons.add(new ListItem<T>(x, y + (40 * (i+1)), width, 40, this, items.get(i)));
    }
  }

  void selected(T item) {
    println(item.toString());
  }

  void search(String query) {
    scrollOffset = 0;
    buttons = new ArrayList<ListItem>();
    for (int i = 0; i < items.size(); i++) {
      println(items.get(i).toString());
      if (items.get(i).toString().toLowerCase().indexOf(query.toLowerCase()) > -1) {
        buttons.add(new ListItem<T>(x, y + (40 * (i+1)), width, 40, this, items.get(i)));
      }
    }
    println("queried " + query + " found " + buttons.size());
  }
  void draw() {
    pushStyle();
    fill(bgColor);
    rect(x, y, width, height);
    for (ListItem<T> b : buttons) {
      b.y = y + scrollOffset + (40 * (buttons.indexOf(b) + 1));

      if (!(b.y <= y || b.y+b.height >= y + height)) {
        b.draw();
      }
    }
    rect(x, y, width, 40);
    rect(x, (y+height)-40, width, 40);
    //draw a rect at the top that covers outgoing objects
    popStyle();
  }
  @Override
    public void mouseWheel(MouseEvent e) {
    if (mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height) {
      scrollOffset += -5 *  ceil(e.getCount());
    }
  }

  public void click() {
    for (ListItem<T> l : buttons) {
      l.click();
    }
  }
}