// By Brian Whelan - all views/screens implement this interface
public interface IView {
  //The draw code 
  void draw();
  //Called when the view is made active - does not initialise the view, use the constructor
  void onMadeActive(); 
  //Called when the view is removed from the active position - does not destroy the view, so don't remove anything here
  void onRemoved();
  //The name of the view, which is displayed on the tab for the view - (getName() is used by processing)
  String getViewName();
  //Mouse clicked
  void click();
  void keyPressed();
  void mouseWheel(MouseEvent e);
  void mouseDragged();
  void mouseReleased();
}