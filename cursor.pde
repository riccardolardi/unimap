public class Cursor {

  // cursor vars
  float xpos, ypos, xoff, yoff;
  float xtap, ytap;
  boolean isDrag = false;
  int cursorSize = 130 / divider;

  Cursor() {

    // place cursor somewhere
    xpos = width/2;
    ypos = height - 200 / divider;

    // register mouse events
    registerMouseEvent(this);
  }

  void move() {

    // if dragging, move
    if (isDrag == true) {

      if (tappingOn == true) {
        xpos = xtap - xoff;
        ypos = ytap - yoff;
      } else {
        xpos = mouseX - xoff;
        ypos = mouseY - yoff;
      }
    }

    // if zoomed dots exist, arrange them around cursor
    if (zoomedDots.size() > 0) {
      arrangeDots();
    }
  }

  void display() {

    // paint some kind of cursor
    fill(#FFFFFF, 20);
    ellipse(xpos, ypos, cursorSize, cursorSize);
    ellipse(xpos, ypos, cursorSize / 1.75, cursorSize / 1.75);
  }

  void arrangeDots() {

    float divAngle = 360 / zoomedDots.size();

    // TODO arrange zoomed dots around cursor
    for (int i = 0; i < zoomedDots.size(); i++) {

      LocationDot tmpLocDot = (LocationDot) zoomedDots.get(i);

      switch (zoomedDots.size()) {

      case 1:
        tmpLocDot.xpos = xpos;
        tmpLocDot.ypos = ypos - 57 / divider;
        break;

      case 2:
        if (i == 0) {
          tmpLocDot.xpos = xpos;
          tmpLocDot.ypos = ypos - 57 / divider;
        } 
        else if (i == 1) {
          tmpLocDot.xpos = xpos;
          tmpLocDot.ypos = ypos + 57 / divider;
        }
        break;

      case 3:
        if (i == 0) {
          tmpLocDot.xpos = xpos;
          tmpLocDot.ypos = ypos - 57 / divider;
        } 
        else if (i == 1) {
          tmpLocDot.xpos = xpos + 48 / divider;
          tmpLocDot.ypos = ypos + 30 / divider;
        } 
        else if (i == 2) {
          tmpLocDot.xpos = xpos - 48 / divider;
          tmpLocDot.ypos = ypos + 30 / divider;
        }
        break;

			case 4:
				if (i == 0) {
	        tmpLocDot.xpos = xpos - 48 / divider;
	        tmpLocDot.ypos = ypos - 30 / divider;
	      }
	      else if (i == 1) {
	        tmpLocDot.xpos = xpos + 48 / divider;
	        tmpLocDot.ypos = ypos - 30 / divider;
	      } 
	      else if (i == 2) {
	        tmpLocDot.xpos = xpos - 48 / divider;
	        tmpLocDot.ypos = ypos + 30 / divider;
	      }
	      else if (i == 3) {
	        tmpLocDot.xpos = xpos + 48 / divider;
	        tmpLocDot.ypos = ypos + 30 / divider;
	      }
	      break;
	
				case 5:
	        if (i == 0) {
	          tmpLocDot.xpos = xpos;
	          tmpLocDot.ypos = ypos - 57 / divider;
	        }
					else if (i == 1) {
		        tmpLocDot.xpos = xpos - 48 / divider;
		        tmpLocDot.ypos = ypos - 30 / divider;
		      }
		      else if (i == 2) {
		        tmpLocDot.xpos = xpos + 48 / divider;
		        tmpLocDot.ypos = ypos - 30 / divider;
		      } 
		      else if (i == 3) {
		        tmpLocDot.xpos = xpos - 48 / divider;
		        tmpLocDot.ypos = ypos + 30 / divider;
		      }
		      else if (i == 4) {
		        tmpLocDot.xpos = xpos + 48 / divider;
		        tmpLocDot.ypos = ypos + 30 / divider;
		      }
		      break;
		
					case 6:
		        if (i == 0) {
		          tmpLocDot.xpos = xpos;
		          tmpLocDot.ypos = ypos - 57 / divider;
		        }
						else if (i == 1) {
			        tmpLocDot.xpos = xpos - 48 / divider;
			        tmpLocDot.ypos = ypos - 30 / divider;
			      }
			      else if (i == 2) {
			        tmpLocDot.xpos = xpos + 48 / divider;
			        tmpLocDot.ypos = ypos - 30 / divider;
			      } 
			      else if (i == 3) {
			        tmpLocDot.xpos = xpos - 48 / divider;
			        tmpLocDot.ypos = ypos + 30 / divider;
			      }
			      else if (i == 4) {
			        tmpLocDot.xpos = xpos + 48 / divider;
			        tmpLocDot.ypos = ypos + 30 / divider;
			      }
			      else if (i == 5) {
			        tmpLocDot.xpos = xpos;
			        tmpLocDot.ypos = ypos + 57 / divider;
			      }
			      break;

      }

      /* TODO
       			pushMatrix();
       				translate(xpos, ypos);
       				rotate(radians(divAngle * i));
       				tmpLocDot.xpos = xpos;
       				if (i == 0) {
       					tmpLocDot.ypos = ypos - 25;
       				} else {
       					tmpLocDot.ypos = ypos + 25;
       				}
       			popMatrix();
       			*/
    }
  }

  void mouseEvent(MouseEvent event) {

    if (tappingOn == true) {
      return;
    }

    if (dist(mouseX, mouseY, xpos, ypos) < cursorSize / 2 - cursorSize / 4) {

      switch(event.getID()) {

      case MouseEvent.MOUSE_PRESSED:

        xoff = mouseX - xpos;
        yoff = mouseY - ypos;
        isDrag = true;

        break;

      case MouseEvent.MOUSE_RELEASED:

        isDrag = false;

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

    if (dist(xtap, ytap, xpos, ypos) < cursorSize / 2 - cursorSize / 4) {
      println("tap on cursor");
      switch(taptype) {

      case 1:

        xoff = xtap - xpos;
        yoff = ytap - ypos;
        isDrag = true;

        break;

      case 2:

        // nuthin

        break;

      case 3:

        isDrag = false;

        break;
      }

    }

  }

}

