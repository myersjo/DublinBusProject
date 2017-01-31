import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.utils.*;
import de.bezier.data.sql.*;
import java.lang.Math;
import java.util.Map;
import java.util.TreeMap;
import java.lang.Integer;
import java.util.Scanner;

Slider slider;
SQLite db;
MapBarchart busesPerOperatorBC, delayByHourBC;
PieChart allBusesCongestion, breakdownCongestion;
Tabs t;
TextEntry text1;
boolean initialised = false;

BarChartController BCControl;
PieChartController PCControl;
MapController MapControl;

PFont stdFont25, stdFont11, stdFont72, lcd48;
PImage stopMarker, selectedStop, busMarker;

void settings() {
  size(SCREENX, SCREENY, P2D);
}
void setup() {
  background(255, 204, 0);
  imageMode(CENTER);
  image(loadImage("load.png"), width/2, height/2);
  imageMode(CORNER);
  redraw();
}
void setUp () {
  stopMarker=loadImage("bus-station.png");
  busMarker=loadImage("bus.png");

  db=new SQLite(this, "busData.db");
  BCControl = new BarChartController(this, "busData.db");
  PCControl = new PieChartController(this, "busData.db");
  MapControl = new MapController(this, "busData.db");

  t = new Tabs(new HomeView(BCControl, PCControl));
  t.registerView(new RealTimeView(new RealTimeController()));
  t.registerView(new MapView(this, MapControl));
  t.registerView(new LineView(this, new LineController(db, MapControl), BCControl, PCControl));
  t.registerView(new StopView(this, new StopController(db, MapControl), BCControl, PCControl));

  stdFont25 = loadFont("SegoeUI-25.vlw");
  stdFont11 = loadFont("SegoeUI-11.vlw");
  stdFont72 = loadFont("SegoeUI-72.vlw");
  lcd48= loadFont("LCDReg-48.vlw");
  textFont(stdFont11);
}

void mousePressed() {
  t.click();
}
void keyPressed() {
  t.keyPressed();
}

void mouseWheel(MouseEvent e) {
  t.mouseWheel(e);
}
void mouseDragged() {
  t.mouseDragged();
}
void mouseReleased() {
  t.mouseReleased();
}
void draw() {
  if (!initialised) {
    setUp();
    initialised=true;
  }
  background(255, 255, 255);
  t.draw();
  if (t.activeView == 0) {
  }
}