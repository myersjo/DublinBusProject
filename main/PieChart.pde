// Written by Sean Raeside
import java.util.Map;
class PieChart extends Widget {
  int x, y, diameter, textX, textY;
  color[] segColors = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 140, 0), color(255, 255, 0), color(128, 0, 128), color(218, 165, 32), color(255, 120, 147)};
  color[] colorArray;
  String[] labels;
  String title;
  Float[] values, segments;
  float totalVal=0;
  float multiplier;
  /*
    PieChart takes in x position, y position (x, y is the centre of the pie), diameter length, an array of Strings for labels, an array of floats for 
   values and a string as a title. It matches the values with the labels in the same position in the label array. If the label array is shorter, no label
   is printed for the surplus values. If the value array is shorter, surplus labels are not printed. The colours of the segments are chosen from an array of
   colors, if the array length is succeeded, a random number is selected.
   */
  PieChart(int xpos, int ypos, int d, HashMap<String, Float> map, String t) {
    super(xpos, ypos, d, d);
    x=xpos; 
    y=ypos; 
    diameter=d;
    labels=map.keySet().toArray(new String[0]);
    values= map.values().toArray(new Float[0]);
    title = t;
    segments = new Float[values.length];

    for (int i=0; i<values.length; i++) {
      totalVal += values[i];
    }

    multiplier = (2*PI)/totalVal;

    for (int i=0; i<segments.length; i++) {
      segments[i] = values[i] * multiplier;
    }

    if (values.length>segColors.length) {
      colorArray = new color[values.length];
      for (int i=0; i<colorArray.length; i++) {
        if (i<segColors.length) {
          colorArray[i] = segColors[i];
        } else colorArray[i] = color(random(0, 256), random(0, 256), random(0, 256));
      }
    } else colorArray = segColors;
  }

  void draw() {

    textAlign(LEFT);
    textX=x+(diameter/2)+30;
    textY = y-diameter/4;
    fill(0);
    text(title, x, y-(diameter/2)-15);
    fill(250);
    float start = 0;
    float addOn = 0;

    for (int i=0; i<segments.length; i++) {
      color currentColor;
      currentColor = colorArray[i];
      fill(currentColor);
      stroke(255, 255, 255);
      arc(x, y, diameter, diameter, start, ((segments[i]))+addOn, PIE);
      stroke(128, 128, 128);
      start = (segments[i])+addOn;
      addOn = start;
      if (i<labels.length) {
        rect(textX-15, textY-10, 10, 10);
        fill(0);
        text(labels[i]+" = "+values[i], textX, textY);
        textY+=15;
        fill(currentColor);
      }
    }
  }
}