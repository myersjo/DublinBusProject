// DEPRECATED - use MapBarchart instead
// Written by Florent Goumot-Labesse
class Barchart{
  String[] xLabel;
  String title, tmp;
  float[] yBar;
  color[] colors;
  int x, y;
  float minValue, maxValue, wid, ht;
  
  Barchart(String t, String[] labels, float[] values, float w, float h, int xPos, int yPos){
    title = t;
    xLabel = labels;
    yBar = values;
    wid = w;
    ht = h;
    x = xPos;
    y = yPos;
    maxValue = values[0];
    minValue = 0;
    colors = new color[values.length];
    // Calculate min/max values; used to draw the bars with a height relative to the highest and lowest
    for(int i=0;i<values.length;i++){
      colors[i] = color(int(random(256)),int(random(256)),int(random(256)));
      if(values[i]>maxValue){
        maxValue = values[i];
      }
      if(values[i]<minValue) {
        minValue = values[i];  
      }
    }
  }
  
  void draw(){
    // Draw the axis
    line(x, y, x, y+ht);
    //line(x, y+ht, x+wid, y+ht);
    line(x, y+ht+minValue*ht/(maxValue-minValue), x+wid, y+ht+minValue*ht/(maxValue-minValue));
    // Draw the title
    fill(0,0,0);
    textAlign(CENTER);
    text(title, x+wid*0.5, y);
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
    for(int i = 0;i<xLabel.length;i++){
      xAxis = y+ht+minValue*ht/(maxValue-minValue);
      fill(colors[i]);//fill(255,255,255); // white filling for rectangles
      rect(x+i*(wid*0.9/xLabel.length), xAxis-((yBar[i]/(maxValue-minValue))*ht*0.9), wid*0.9/xLabel.length, (yBar[i]/(maxValue-minValue))*ht*0.9);
      fill(0,0,0); // black filling for values on the axis
      // To draw values along axis, we align the text to the right
      textAlign(RIGHT);
      boolean display = true;
      tmp = str(yBar[i]);
      for(int j = 0; j < i; j++) {
        if(abs(xAxis-((yBar[i]/(maxValue-minValue))*ht*0.85) - (xAxis-((yBar[j]/(maxValue-minValue))*ht*0.85))) < textAscent()+textDescent()) {
          display = false;  
        }
      }
      if(display) { 
        text(yBar[i],x,xAxis-((yBar[i]/(maxValue-minValue))*ht*0.85));
      }
      /*
      This part will draw the xLabels value, which are the strings along the x axis
      If the string is too long, we'll cut it to fit in the barchart
      As long as the width is too big, we remove the last letter that should be displayed
      */
      tmp = xLabel[i];
      while(textWidth(tmp)>(wid*0.9/xLabel.length)) {
        tmp = tmp.substring(0, tmp.length()-1 );
      }
      // To draw values along axis, we align the text to the center
      textAlign(CENTER);
      text(tmp, x+i*(wid*0.9/xLabel.length)+0.5*wid/xLabel.length, y+ht+16);
    }
  }
  
}