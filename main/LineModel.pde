// By Brian Whelan. Holds data for LineView
public class LineModel{
     String line;
     int lineID;
     public LineModel(String linename, int lineid){
         line = linename;
         lineID = lineid;
     }
     
     String toString(){
          return line;   
     }
}