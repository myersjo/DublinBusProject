//by Sean Raeside
class CheckBox extends Widget{
  boolean checked = false;
  String label = "";
  int event, x, y, side;
  PImage whiteTick = loadImage("whiteTick.png");
  color labelC = color(255);
  /*
    Use getChecked() method to return a boolean as to whether the box is checked or not
  */
  CheckBox(int xpos, int ypos, int s, int e, String l){
    super(xpos,ypos,s,s);
    x=xpos;
    y=ypos;
    side = s;
    event = e;
    label = l;
  }
  CheckBox(int xpos, int ypos, int s, int e){
    this(xpos, ypos, s, e, "");
  }
  CheckBox(int xpos, int ypos, int e){
    this(xpos, ypos, 20, e, "");
  }
  CheckBox(int xpos, int ypos, int e, String l){
    this(xpos, ypos, 20, e, l);
  }
  void draw(){
      stroke(255);
    fill(0, 80, 239);
    rect(x, y, side, side);
    if(checked){
      image(whiteTick, x+2, y+2, side-2, side-2);
    }
    stroke(255);
    fill(labelC);
    text(label, x+side+5, y+side/2);
  }
  void mousePressed(int mX, int mY){
    if(getEvent(mX, mY)==event){
      if(!checked){
        checked = true;
      }
      else checked = false;
    }
  }
  int getEvent(int mX, int mY){
    if(mX>x && mX<x+side && mY>y && mY<y+side){
      return event;
    }
    else return -1;
  }
  boolean getChecked(){
    return checked;
  }
  void changeLabelColor(color c){
    labelC = c;
  }
}