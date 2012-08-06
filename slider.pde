public class Slider {
	
	float xpos, ypos, origxpos, origypos, xoff, yoff, xlast, ylast;
	float xtap, ytap;
	
	boolean on = false;
	boolean isDrag = false;
	
	int tolerance = 30 / divider;
	int position;
	
	String sliderType;
	
	PImage sliderImg;

	Slider(int xposIn, int yposIn, String sliderTypeIn) {
		
		xpos = xposIn / divider;
		ypos = yposIn / divider;
		origxpos = xpos;
		origypos = ypos;
		sliderType = sliderTypeIn;
		
		// register mouse event
		registerMouseEvent(this);
		
		// load image and resize
	  sliderImg = loadImage("img/slider_off.png");
	  sliderImg.resize(sliderImg.width / divider, sliderImg.height / divider);
	
	}
	
	void move() {
		
		if (ypos <= origypos - 80 / divider) {

			isDrag = false;
			ypos = ypos + 10 / divider;
			
		} else if (ypos >= origypos + 80 / divider) {
			
			isDrag = false;
			ypos = ypos - 10 / divider;
			
		}
		
		if (isDrag == true) {
			
			if (tappingOn == true) {
				
				ypos = ytap - yoff;
				
			} else {
				
				ypos = mouseY - yoff;
				
			}
			
		}
		
	}
	
	void display() {
		
		image(sliderImg, xpos, ypos);
		
	}
	
	void snapIn() {
		
		if (ypos <= origypos - 40 / divider) {
			position = 3;
			filter();
			Ani.to(this, 1, "ypos", origypos - 70 / divider);
		} else if ((ypos >= origypos - 40 / divider) && (ypos <= origypos + 40 / divider)) {
			position = 2;
			filter();
			Ani.to(this, 1, "ypos", origypos);
		} else if (ypos > origypos + 40 / divider) {
			position = 1;
			filter();
			Ani.to(this, 1, "ypos", origypos + 70 / divider);
		}
		
	}
	
	void filter() {
		
		locationDots.clear();
		createLocDots(sliderType, position);

	}
	
  void mouseEvent(MouseEvent event) {
	
		if (tappingOn == true) {
			return;
		}
	
		if ((mouseX >= xpos) && (mouseX <= xpos + sliderImg.width) && (mouseY >= ypos) && (mouseY <= ypos + sliderImg.height)) {
		
	    switch(event.getID()) {
      
	      case MouseEvent.MOUSE_CLICKED:
				
					if (on == false) {
						on = true;
						sliderImg = loadImage("img/slider_on.png");
						sliderImg.resize(sliderImg.width / divider, sliderImg.height / divider);
					} else if (on == true) {
						on = false;
						sliderImg = loadImage("img/slider_off.png");
						sliderImg.resize(sliderImg.width / divider, sliderImg.height / divider);
						createLocDots("all", 0);
					}
				
					break;
				
				case MouseEvent.MOUSE_PRESSED:
			
					xoff = mouseX - xpos;
					yoff = mouseY - ypos;
					isDrag = true;
					on = true;
					sliderImg = loadImage("img/slider_on.png");
					sliderImg.resize(sliderImg.width / divider, sliderImg.height / divider);
					
	        break;

	      case MouseEvent.MOUSE_RELEASED:

					if (isDrag == true) {
				
						xoff = mouseX - xpos;
						yoff = mouseY - ypos;
						isDrag = false;
		
						snapIn();
		
					}
					
					break;
				
			}
			
		}
	
	}
	
	void tapEvent(float xtapIn, float ytapIn, int taptype) {

		if (tappingOn == false) {
			return;
		}
		
		xtap = xtapIn;
		ytap = ytapIn;
		
		if ((xtap >= xpos - tolerance) && (xtap <= xpos + sliderImg.width + tolerance) 
			&& (ytap >= ypos - tolerance) && (ytap <= ypos + sliderImg.height + tolerance)) {
			
			switch (taptype) {
			
				case 1:
				
					xlast = xpos;
					ylast = ypos;
					xoff = xtap - xpos;
					yoff = ytap - ypos;
					isDrag = true;
					on = true;
					sliderImg = loadImage("img/slider_on.png");
					sliderImg.resize(sliderImg.width / divider, sliderImg.height / divider);
					
				break;
				
				case 2:
				
					// nuthin
				
				break;
				
				case 3:
				
					if (isDrag == true) {

						if (dist(xpos, ypos, xlast, ylast) < 30 / divider) {
							if (on == false) {
								on = true;
								sliderImg = loadImage("img/slider_on.png");
								sliderImg.resize(sliderImg.width / divider, sliderImg.height / divider);
							} else {
								on = false;
								sliderImg = loadImage("img/slider_off.png");
								sliderImg.resize(sliderImg.width / divider, sliderImg.height / divider);
								createLocDots("all", 0);
							}

							break;
						}
				
						xoff = xtap - xpos;
						yoff = ytap - ypos;
						isDrag = false;
						
						snapIn();
						
					}
				
				break;
			
			}
			
		} else {
			isDrag = false;

		}
	
	}
	
}
