//by Sean Raeside, Brian Whelan. Used to get user input
class TextEntry extends Widget {
  int  wid, ht, event;
  String hint = "";
  color defaultOutline = color(0);
  boolean changed = false;
  String textString = "";
  String storedString = "";
  color objectColor = color(255);
  color objectTextColor = color(0);
  int alpha = 255;
  int additive = 5;
  IView parent;
  TextEntry(int xpos, int ypos, int w, int h, int ev, String hint, IView currentView) {
    super(xpos, ypos, w, h);
    this.hint = hint;
    this.x=xpos;
    this.y=ypos;
    this.wid=w;
    this.ht=h;
    this.event=ev;
    parent = currentView;
  }
  void draw() {
    int mX = mouseX;
    int mY = mouseY;
    fill(objectColor);
    stroke(defaultOutline);
    rect(x, y, wid, ht);
    fill(0, 0, 0, constrain(alpha, 0, 255));
    if (alpha > 350) {
      additive = -7;
    }
    if (alpha < -20) {
      alpha = 255;  
      additive = 7;
    }
    if (additive == 0) {
      additive = -7;
    }
    alpha+=additive;
    noStroke();
    if (changed())
      rect(x+textWidth(textString)+4, y+4, 1, ht-8);
    if (getEvent(mX, mY)==event) {
      defaultOutline = color(255, 0, 0);
      //stroke(defaultOutline);
    } else {
      if (!changed) {
        defaultOutline = color(0);
      }
    }
    fill(0);
    textAlign(LEFT, CENTER);
    if (textString.length() == 0) {
      fill(100, 100, 100);
      text(hint, x+4, y+(ht/2));
      fill(0, 0, 0);
    }
    text(textString, x+4, y+(ht/2));
  }
  int getEvent(int mX, int mY) {
    if (mX>this.x && mX<this.x+this.wid && mY>this.y && mY<this.y+this.ht) {
      return event;
    } else return -1;
  }
  void changeDefaultOutline(color c) {
    defaultOutline = c;
    if (changed) {
      changed = false;
    } else changed = true;
  }
  int event() {
    return event;
  }
  color defaultOutline() {
    return defaultOutline;
  }
  boolean changed() {
    return changed;
  }
  void addToString(char s) {
    textString += s;
  }
  void removeLastChar() {
    if (!textString.equals("")) {
      textString = textString.substring(0, textString.length()-1);
    }
  }
  void storeString() {
    storedString = textString;
  }
  void clearBox() {
    textString = "";
    changed = false;
  }
  String getStoredString() {
    return storedString;
  }


  @Override
    public void keyPressed() {
    if (this.changed()) {
      switch(key) {
      case BACKSPACE:
        this.removeLastChar();
        alpha = 255;
        additive = 0;
        break;
      case SHIFT:
        break;
      case ENTER:
        this.storeString();
        this.clearBox();
        this.submitted();
        break;
      default:
        if (wid-12 > textWidth(textString)) {
          this.addToString(key);
          textChanged(textString);
          alpha = 255;
          additive = 0;
        }
      }
    }
  }
  @Override
    public void click() {
    if (this.getEvent(mouseX, mouseY)==this.event) {
      if (this.changed()) {
        this.changeDefaultOutline(color(0));
      } else this.changeDefaultOutline(color(255, 0, 0));
    }
    if (this.changed() && this.getEvent(mouseX, mouseY) != this.event) {
      changed = false;
    }
  }

  public void submitted() {
  }
  public void textChanged(String text) {
  }
}