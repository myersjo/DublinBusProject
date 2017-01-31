//by Sean Raeside, 02/04/2016
class Slider extends Widget {
  int x, y, wid, ht, sliderY, event, numOfDivs, inX, inY, inWid;
  int sliderX;
  int sliderRad = 14;
  int inHt = 2;
  //String[] divisions;
  float sliderValue;
  int margin = 5;
  color objectColor = color(0, 80, 239);
  color defaultOutline = color(0);
  color labelColor = color(255);
  boolean sliderDragged;
  String[] labels;
  boolean continuous = false;

  /*
    To get a continuous Slider call continuous constructer and vice versa for a Slider with divisions. Use get sliderValue to retrieve the float sliderValue. If it is a
   continuous Slider, sliderValue will range from 0-1. If it is a division Slider, the sliderValue will return the index of the label selected. The sliderValue is changed
   when the mouse is released. The label and object colors can be changed through the changeColor methods
   
   */

  //Div Slider
  Slider(int xpos, int ypos, int w, int h, int e, String[] l) {
    super(xpos, ypos, w, h);
    x=xpos;
    y=ypos;
    wid=w;
    ht=h;
    inWid=wid-margin*2;
    event=e;
    labels=l;
    inX=x+margin;
    inY=y+(ht/2)-(inHt/2);
    sliderX=x+(wid/2);
    sliderY=y+(ht/2);
    continuous=false;
  }

  //Continuous Slider
  Slider(int xpos, int ypos, int w, int h, int e) {
    super(xpos, ypos, w, h);
    x=xpos;
    y=ypos;
    wid=w;
    ht=h;
    inWid=wid-margin*2;
    event=e;
    inX=x+margin;
    inY=y+(ht/2)-(inHt/2);
    sliderX=x+(wid/2);
    sliderY=y+(ht/2);
    continuous=true;
  }

  void draw(int mX, int mY) {
    fill(objectColor);
    stroke(defaultOutline);
    rect(x, y, wid, ht);
    //rect(inX,inY,inWid,inHt);
    drawIn();
  }

  void move(int mX, int mY) {
    if (sliderDragged) {
      sliderX = mX;
    }
  }

  int getEvent(int mX, int mY) {
    if (mX>sliderX-sliderRad/2 && mY>sliderY-sliderRad/2 && mX< sliderX+sliderRad/2 && mY<(sliderY)+sliderRad/2) {
      return event;
    } else return -1;
  }

  float getSliderValue() {
    return sliderValue;
  }

  void sliderDragged() {
    sliderDragged = true;
  }

  void mouseReleased() {
    //sliderValue = (float)closestPoint(x, (int)((sliderX-x)), wid);
    if (!continuous) {
      sliderValue = decide(sliderX, labels, wid, x);
    } else {
      sliderValue = ((float)(sliderX)-(float)(inX+(sliderRad/2)))/((float)inWid-(float)sliderRad);
    }
    sliderDragged = false;
  }

  boolean getSliderBoolean() {
    return sliderDragged;
  }

  void drawIn() {
    if (sliderX<inX+sliderRad/2) {
      sliderX = inX+sliderRad/2;
    } else if (sliderX>inX+inWid-sliderRad/2) {
      sliderX = inX+inWid-sliderRad/2;
    }
    fill(0);
    stroke(0);
    rect(inX, inY, sliderX-inX, inHt);
    fill(255);
    stroke(255);
    rect(sliderX, inY, inX+inWid-sliderX, inHt);
    if (!continuous) {
      drawLabels(labels);
    }
    fill(objectColor);
    ellipse(sliderX, sliderY, sliderRad, sliderRad);
  }

  int decide(int sliderX, String[] divs, int wid, int x) {
    int divIndex = 0;
    for (int i=0; i<divs.length; i++) {
      if (sliderX>x+((wid/divs.length)*i)) {
        divIndex = i;
      }
    }
    return divIndex;
  }

  void mousePressed() {
    if (this.getEvent(mouseX, mouseY)==this.event) {
      this.sliderDragged();
    }
  }
  void mouseDragged() {
    if (this.getSliderBoolean()) {
      this.move(mouseX, mouseY);
    }
  }
  String cal() {
    fill(255);
    return ((float)(sliderX)-(float)(inX+(sliderRad/2)))+"/"+((float)inWid-(float)sliderRad);
  }
  void drawLabels(String[] l) {
    fill(labelColor);
    for (int i=0; i<l.length; i++) {
      text(l[i], x+(wid/l.length*i), y-1);
      if (i>0) {
        line(x+(wid/l.length*i), y+1, x+(wid/l.length*i), y+ht-1);
      }
    }
  }
  void changeLabelColor(color c) {
    labelColor = c;
  }
  void changeObjectColor(color c) {
    objectColor = c;
  }
  void changeOutline(color c) {
    defaultOutline = c;
  }
}