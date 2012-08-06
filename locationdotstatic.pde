public class LocationDotStatic {
  
  int dotSize = 10 / divider;
	int xpos, ypos;
  
  LocationDotStatic(int xposIn, int yposIn) {

		xpos = xposIn;
		ypos = yposIn;
    
  }
  
  void move() {
    
		// nuthin
    
  }
  
  void display() {
			
  	fill(#FFFFFF, 85);
    ellipse(xpos, ypos, dotSize, dotSize);

  }

}