// Written by Brian Whelan, Florent Goumot
import java.util.Map;
class MapBarchart extends Widget {
  Map<String, Float> values;
  TreeMap<String, Float> tValues;
  String title, tmp;

  color[] colors;
  int x, y;
  float minValue, maxValue, wid, ht;

  MapBarchart(String t, Map<String, Float> m, float w, float h, int xPos, int yPos) {
    super(xPos, yPos, (int)w, (int)h);
    title = t;
    values = m;
    wid = w;
    ht = h;
    x = xPos;
    y = yPos;
    maxValue = values.values().toArray(new Float[0])[0];
    minValue = min(0, maxValue);
    colors = new color[values.values().size()];
    // Calculate max value; used to draw the bars with a height relative to the highest one
    for (int i=0; i<values.values ().size(); i++) {
      colors[i] = color(int(random(256)), int(random(256)), int(random(256)));
      if (values.values().toArray(new Float[0])[i]>maxValue) {
        maxValue = values.values().toArray(new Float[0])[i];
      }
      if (values.values().toArray(new Float[0])[i]<minValue) {
        minValue = values.values().toArray(new Float[0])[i];
      }
    }
  }

  MapBarchart(String t, TreeMap<String, Float> m, float w, float h, int xPos, int yPos) {
    super(xPos, yPos, (int)w, (int)h);
    title = t;
    tValues = m;
    wid = w;
    ht = h;
    x = xPos;
    y = yPos;
    maxValue = tValues.values().toArray(new Float[0])[0];
    minValue = min(0, maxValue);
    colors = new color[tValues.values().size()];
    // Calculate max value; used to draw the bars with a height relative to the highest one
    for (int i=0; i<tValues.values ().size(); i++) {
      colors[i] = color(int(random(256)), int(random(256)), int(random(256)));
      if (tValues.values().toArray(new Float[0])[i]>maxValue) {
        maxValue = tValues.values().toArray(new Float[0])[i];
      }
      if (tValues.values().toArray(new Float[0])[i]<minValue) {
        minValue = tValues.values().toArray(new Float[0])[i];
      }
    }
  }

  void Update(Map<String, Float> m) {
    values = m;
    maxValue = values.values().toArray(new Float[0])[0];
    minValue = min(0, maxValue);
    colors = new color[values.values().size()];
    // Calculate max value; used to draw the bars with a height relative to the highest one
    for (int i=0; i<values.values ().size(); i++) {
      colors[i] = color(int(random(256)), int(random(256)), int(random(256)));
      if (values.values().toArray(new Float[0])[i]>maxValue) {
        maxValue = values.values().toArray(new Float[0])[i];
      }
      if (values.values().toArray(new Float[0])[i]<minValue) {
        minValue = values.values().toArray(new Float[0])[i];
      }
    }
  }
  void Update(TreeMap<String, Float> m) {
    tValues = m;
    maxValue = values.values().toArray(new Float[0])[0];
    minValue = min(0, maxValue);
    colors = new color[values.values().size()];
    // Calculate max value; used to draw the bars with a height relative to the highest one
    for (int i=0; i<values.values ().size(); i++) {
      colors[i] = color(int(random(256)), int(random(256)), int(random(256)));
      if (values.values().toArray(new Float[0])[i]>maxValue) {
        maxValue = values.values().toArray(new Float[0])[i];
      }
      if (values.values().toArray(new Float[0])[i]<minValue) {
        minValue = values.values().toArray(new Float[0])[i];
      }
    }
  }

  void draw() {
    // Draw the y-axis
    stroke(128);
    line(x, y, x, y+ht);
    //line(x, y+ht, x+wid, y+ht);
    // Draw the title
    fill(0, 0, 0);
    textAlign(CENTER);
    text(title, x+wid*0.5, y-(textAscent()+textDescent()));
    /*
    Loop through the values. How the rectangles are drawn:
     x1: x+i*(wid*0.9/xLabel.length), x to draw from the left corner of the barchart,
     +i*(wid*0.9/xLabel.length) to draw the bar after the previous one
     we use wid*0.9 instead of wid in order to stop a bit before the end of the axis, so that it still appears
     x2: y+ht-((yBar[i]/maxValue)*ht*0.9), y+ht to draw at the x axis height,
     -((yBar[i]/maxValue)*ht*0.9) because we have to substract the rectangle height, else it will be displayed under the x axis
     width: wid*0.9/xLabel.length; each bar will have the same width to fit in the barchart 
     height: (yBar[i]/maxValue)*ht*0.9); height of a bar is relative to the highest bar value 
     */
    float xAxis;
    if (values != null) {
      if (values.size()==0 || (minValue==maxValue && values.values().toArray(new Float[0])[0]>=0)) {
        String message = "No results found";
        fill(0);
        textFont(stdFont11);
        text(message, (x+(wid/2)-(textWidth(message)/2)), (y+(ht/2)));
        line(x, y+(ht*2/3), x+wid, y+(ht*2/3));
      } else {
        // Draw x-axis
        line(x, max(y, y+ht+minValue*ht/(maxValue-minValue)), x+wid, max(y, y+ht+minValue*ht/(maxValue-minValue)));
        for (int i = 0; i<values.keySet ().size(); i++) {
          xAxis = max(y, y+ht+minValue*ht/(maxValue-minValue));
          fill(colors[i]);//fill(255,255,255); // white filling for rectangles
          float iBar = values.values().toArray(new Float[0])[i];
          int size = values.keySet().size();
          float diff = maxValue-minValue;
          if (maxValue<0) diff = abs(minValue);
          rect(x+i*(wid*0.9/size), xAxis-((iBar/diff)*ht*0.9), wid*0.9/size, (iBar/diff)*ht*0.9);
          fill(0, 0, 0); // black filling for values on the axis
          // To draw values along axis, we align the text to the right
          textAlign(RIGHT);

          /* Draw values along Y axis, old version
           boolean display = true;
           tmp = str(iBar);
           for(int j = 0; j < i; j++) {
           float jBar = values.values().toArray(new Float[0])[j];
           if(abs(xAxis-((iBar/diff)*ht*0.85) - (xAxis-((jBar/diff)*ht*0.85))) < textAscent()+textDescent()) {
           display = false;  
           }
           }
           if(display) { 
           text(iBar,x,xAxis-((iBar/diff)*ht*0.85));
           }*/
          // New version here :
          int val; 
          float increment;
          if(diff > 9) {
            increment = ht*0.1;
          }
          else {
            increment = ht*(1/diff);
          }
          for (float j = xAxis; j < y+ht; j+= increment) {
            val = (int) (((xAxis-j)/(ht*0.85))*diff);
            text(val, x-5, j);
          }
          for (float j = xAxis; j > y; j-= increment) {
            val = (int) (((xAxis-j)/(ht*0.85))*diff);
            text(val, x-5, j);
          }

          /*
      This part will draw the xLabels value, which are the strings along the x axis
           If the string is too long, we'll cut it to fit in the barchart
           As long as the width is too big, we remove the last letter that should be displayed
           */
          tmp = values.keySet().toArray(new String[0])[i];
          while (textWidth (tmp)>(wid*0.9/values.values().size())) {
            tmp = tmp.substring(0, tmp.length()-1 );
          }
          // To draw values along axis, we align the text to the center
          textAlign(CENTER);
          text(tmp, x+i*(wid*0.9/values.values().size())+0.5*wid/values.values().size(), y+ht+16);
        }
      }
    } else if (tValues != null) {
      if (tValues.size()==0 || (minValue==maxValue && tValues.values().toArray(new Float[0])[0]>=0)) {
        String message = "No results found";
        fill(0);
        textFont(stdFont11);
        text(message, (x+(wid/2)-(textWidth(message)/2)), (y+(ht/2)));
        line(x, y+(ht*2/3), x+wid, y+(ht*2/3));
      } else {
        line(x, max(y, y+ht+minValue*ht/(maxValue-minValue)), x+wid, max(y, y+ht+minValue*ht/(maxValue-minValue)));
        for (int i = 0; i<tValues.keySet ().size(); i++) {
          xAxis = max(y, y+ht+minValue*ht/(maxValue-minValue));
          fill(colors[i]);
          float iBar = tValues.values().toArray(new Float[0])[i];
          int size = tValues.keySet().size();
          float diff = maxValue-minValue;
          if (maxValue<0) diff = abs(minValue);
          rect(x+i*(wid*0.9/size), xAxis-((iBar/diff)*ht*0.9), wid*0.9/size, (iBar/diff)*ht*0.9);
          fill(0, 0, 0); 
          textAlign(RIGHT);
          int val;
          for (float j = xAxis; j < y+ht; j+= (ht*0.1)) {
            val = (int) (((xAxis-j)/(ht*0.85))*diff);
            text(val, x-5, j);
          }
          for (float j = xAxis; j > y; j-= (ht*0.1)) {
            val = (int) (((xAxis-j)/(ht*0.85))*diff);
            text(val, x-5, j);
          }
          tmp = tValues.keySet().toArray(new String[0])[i];
          while (textWidth (tmp)>(wid*0.9/tValues.values().size())) {
            tmp = tmp.substring(0, tmp.length()-1 );
          }
          textAlign(CENTER);
          text(tmp, x+i*(wid*0.9/tValues.values().size())+0.5*wid/tValues.values().size(), y+ht+16);
        }
      }
    }
  }
}