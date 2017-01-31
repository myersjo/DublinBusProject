// By Jordan Myers
public class CustomMarker extends AbstractMarker {
  PImage marker;
  PImage selectedMarker;
  UnfoldingMap map;
  boolean isStopMap;
  boolean isBusMap;
  int size;
  StopModel stop;
  ModelBus bus;

  public CustomMarker (Location location, PImage img, UnfoldingMap map, boolean isStopMap, boolean isBusMap, StopModel stop, ModelBus bus) {
    super(location);
    this.marker = img;
    this.map=map;
    this.isStopMap=isStopMap;
    this.isBusMap=isBusMap;
    this.stop=stop;
    this.bus=bus;
  }

  public CustomMarker (Location location, PImage img, UnfoldingMap map, boolean isStopMap, boolean isBusMap) {
    this(location, img, map, isStopMap, isBusMap, null, null);
  }
  public CustomMarker (Location location, PImage img, UnfoldingMap map) {
    this(location, img, map, false, false, null, null);
  }
  public CustomMarker (Location location, PImage img, UnfoldingMap map, boolean isStopMap) {
    this(location, img, map, isStopMap, false, null, null);
  }

  public CustomMarker (Location location, PImage img, PImage sel, UnfoldingMap map) {
    this(location, img, map, false, false, null, null);
    selectedMarker = sel;
  }

  public CustomMarker (Location location, PImage img, PImage sel, UnfoldingMap map, boolean isStopMap, boolean isBusMap) {
    this(location, img, map, isStopMap, false, null, null);
    selectedMarker = sel;
  }

  public void draw(PGraphics pg, float x, float y) {
    if (isStopMap)
      size=map.getZoomLevel()-2;
    else if (isBusMap)
      size=(int)(map.getZoomLevel()*1.5);
    else 
    size=map.getZoomLevel()*2/3;
    if (selected)
      size*=2;
    pg.pushStyle();
    pg.imageMode(PConstants.CORNER);
    // The image is drawn in object coordinates, i.e. the marker's origin (0,0) is at its geo-location.
    if (selected && selectedMarker != null)
      pg.image(selectedMarker, x, y, size, size);
    else
      pg.image(marker, x, y, size, size);

    // draw information labels
    if (selected && bus!=null) {
      pg.textFont(stdFont11);
      String label = "Vehicle ID: " + bus.getID() + "\n Line: " + bus.getLine() + "\n Congested: " + ((bus.getCongested())? "Yes " : "No ")
        + "\n Current Delay: " + bus.getDelay() + " seconds "+ "\n Current Position: " + bus.getLatitude() + ", " + bus.getLongitude();
      pg.fill(255);
      pg.rect(x+size, y-12, textWidth(label)+8, 68);
      pg.fill(0);
      pg.text(label, (x+size+3), y);
    } else if (selected && stop!=null) {
      pg.textFont(stdFont11);
      ArrayList<String> lines = MapControl.getLinesForStop(stop);
      String label = " Stop ID: " + stop.getStopID() + "\n Latitude: " + stop.getLatitude() + "\n Longitude: " + stop.getLongitude() + "\n Lines: ";
      println(lines.size());
      int i = 1;
      for (i = 0; i<lines.size(); i++) {
        label=label+ "\n    " + lines.get(i);
      }
      pg.fill(255);
      pg.rect(x+size, y-12, textWidth(label)+5, 62 + i*12);
      pg.fill(0);
      pg.text(label, (x+size+3), y);
    }
    pg.popStyle();
  }
  
  // Required by Super class AbstractMarker for checking hits
  protected boolean isInside(float checkX, float checkY, float x, float y) {
    return checkX > x && checkX < x + size && checkY > y && checkY < y + size;
  }
}