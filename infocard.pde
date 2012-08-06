public class InfoCard {
  
	LocationDot tmpLocDot;
	
	PImage infoCardImg;
	
	float xpos, ypos, xoff, yoff, xlast, ylast;
  float xtap, ytap;
	
	boolean isDrag = false;
	boolean isDockedToDot = true;
	boolean isDockedToBoard = false;
	
	String cardCity, cardType, cardLastType;
  
  InfoCard(LocationDot inTmpLocDot) {
			
		tmpLocDot = inTmpLocDot;
		
		cardCity = tmpLocDot.locCity.toLowerCase();
		
		xpos = tmpLocDot.xpos + 50 / divider;
		ypos = tmpLocDot.ypos + 50 / divider;
		
	  // TODO setup infocard image
		loadCard("_allgemein.png");
	
		// register mouse event
		registerMouseEvent(this);
			
  }

	void move() {

		// if docked to location dot
		if (isDockedToDot == true) {
			xpos = tmpLocDot.xpos + 50 / divider;
			ypos = tmpLocDot.ypos + 50 / divider;
		}
		
		if (isDockedToBoard == true) {
			// TODO
		}
		
    // if dragging, move
    if (isDrag == true) {
	
			if (tappingOn == true) {
	
				xpos = xtap - xoff;
	      ypos = ytap - yoff;
			
			} else {
			
				xpos = mouseX - xoff;
	      ypos = mouseY - yoff;
			
			}
			
		isDockedToDot = false;
		
    }
		
	}

	void display() {
		
		// display card
		image(infoCardImg, xpos, ypos);
		
	}
	
	void loadCard(String inType) {
		
		cardType = inType;
		
		File f = new File(dataPath("infocards/" + cardCity + cardType));
		if (!f.exists()) {
		  cardCity = "potsdam";
			cardType = "_allgemein.png";
		}
		
		infoCardImg = loadImage("infocards/" + cardCity + cardType);
		infoCardImg.resize(infoCardImg.width / divider, infoCardImg.height / divider);
		
	}

	void putToBoard() {
		
		int putOffset = 0;
		
		cardLastType = cardType;
		
		if (isDockedToBoard == false) {
			putOffset = dockedCards.size() * 50 / divider;
			infoCardImg.resize(infoCardImg.width / 2, infoCardImg.height / 2);
			isDockedToBoard = true;
			dockedCards.add(this);
		}
		
    Ani.to(this, 1, "xpos", cardBoard.xpos + 20 / divider + putOffset);
    Ani.to(this, 1, "ypos", cardBoard.ypos + infoCardImg.height + 30 / divider);
		
	}
	
	void releaseFromBoard() {
		
		isDockedToBoard = false;
		dockedCards.remove(this);
		loadCard(cardLastType);
		
	}
	
  void mouseEvent(MouseEvent event) {
	
		if (tappingOn == true) {
			return;
		}
	
		if ((mouseX >= xpos) && (mouseX <= xpos + infoCardImg.width) && (mouseY >= ypos) && (mouseY <= ypos + infoCardImg.height)) {
    
	    switch(event.getID()) {
      
	      case MouseEvent.MOUSE_CLICKED:
          
					if ((mouseX >= cardBoard.xpos) && (mouseX <= cardBoard.xpos + cardBoard.boardSize[0]) && 
							(mouseY >= cardBoard.ypos) && (mouseY <= cardBoard.ypos + cardBoard.boardSize[1])) {
								
						// zoom card
						// TODO
								
					}	else {

						// kill me
						infoCards.remove(this);
						dockedCards.remove(this);
						tmpLocDot.hasInfoCard = false;
					
					}
					
	        break;

	      case MouseEvent.MOUSE_PRESSED:
			
					xoff = mouseX - xpos;
					yoff = mouseY - ypos;
	        isDrag = true;
	
	        break;

	      case MouseEvent.MOUSE_RELEASED:

					if (isDrag == true) {
				
						xoff = mouseX - xpos;
						yoff = mouseY - ypos;
		        isDrag = false;

						if ((mouseX >= cardBoard.xpos) && (mouseX <= cardBoard.xpos + cardBoard.boardSize[0]) && 
								(mouseY >= cardBoard.ypos) && (mouseY <= cardBoard.ypos + cardBoard.boardSize[1])) {
									
							putToBoard();
							
						} else {
							
							releaseFromBoard();
							
						}
					
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
		
		if ((xtap >= xpos) && (xtap <= xpos + infoCardImg.width) && (ytap >= ypos) && (ytap <= ypos + infoCardImg.height)) {
			
			switch (taptype) {
				
				case 1:
					
					xlast = xtap;
					ylast = ytap;
					xoff = xtap - xpos;
					yoff = ytap - ypos;
					isDrag = true;

				break;

				case 2:
				
					// nuthin
				
				break;
				
				case 3:
				
					if (isDrag == true) {
			
						xoff = xtap - xpos;
						yoff = ytap - ypos;
						isDrag = false;

						if ((xtap >= cardBoard.xpos) && (xtap <= cardBoard.xpos + cardBoard.boardSize[0]) && 
								(ytap >= cardBoard.ypos) && (ytap <= cardBoard.ypos + cardBoard.boardSize[1])) {
								
							putToBoard();
						
						} else {
						
							releaseFromBoard();
						
						}
						
						if (dist(xpos, ypos, xlast, ylast) < 140 / divider) {
							
							// kill me
							infoCards.remove(this);
							dockedCards.remove(this);
							tmpLocDot.hasInfoCard = false;
							
						}
				
					}
				
				break;
				
			}
			
		}
		
	}

}
