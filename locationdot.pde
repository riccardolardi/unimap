public class LocationDot {
  
	int dotSize = 30 / divider;
	int selectedDotSize = 60 / divider;
	int unselectedDotSize = 30 / divider;
	float xpos, ypos, origxpos, origypos, xoff, yoff;
  float xtap, ytap;
  
  boolean zoomed = false;
	boolean hasInfoCard = false;
	boolean showInfo = false;
	boolean showLocDotStaticLines = false;
	boolean isSelected = false;
  
  String locCountry, locCity, locName;
         
  ArrayList locFaculties, locPartners;
        
  int locPopulation, locClimate, locFees, locWater;

	InfoCard myInfoCard;
	
	LocationDotStatic myLocDotStatic;
  
  LocationDot(String tmpLocCountry, String tmpLocCity, String tmpLocName, 
                     String tmpLocFaculties, String tmpLocPartners, 
                     int tmpLocPopulation, int tmpLocClimate, int tmpLocFees, 
                     int tmpLocWater, int tmpxpos, int tmpypos, LocationDotStatic tmpLocDotStatic) {
    
    locCountry = tmpLocCountry;
    locCity = tmpLocCity;
    locName = tmpLocName;
    locFaculties = new ArrayList();
    getFaculties(tmpLocFaculties);
    locPartners = new ArrayList();
    getPartners(tmpLocPartners);
    locPopulation = tmpLocPopulation;
    locClimate = tmpLocClimate;
    locFees = tmpLocFees;
    locWater = tmpLocWater;
    origxpos = tmpxpos;
    xpos = tmpxpos;
    origypos = tmpypos;
    ypos = tmpypos;
		myLocDotStatic = tmpLocDotStatic;
    
    registerMouseEvent(this);
    
  }
  
  void move() {
    
		// nuthin
    
  }
  
  void display() {
    
    // paint the dot
		if (showInfo == true) {
			
			drawSelectedDot();
			
		} else {
			
    	fill(#FFFFFF, 85);
    	ellipse(xpos, ypos, dotSize, dotSize);

		}

		// show lines
		if (showInfo == true) {
			showLines();
			showInfocard();
		}
		
		// show lines to static loc dot
		if (showLocDotStaticLines == true) {
			stroke(255, 75);
			line(xpos, ypos, myLocDotStatic.xpos, myLocDotStatic.ypos);
			noStroke();
		}
    
  }
  
  // get faculties from string into arraylist
  void getFaculties(String tmpLocFaculties) {
    
    boolean endFlag = false;
    int beginVal = 0, endVal = 0;
    
    // read out from string into arraylist
    while(endFlag == false) {
      
      endVal = tmpLocFaculties.indexOf(",", beginVal);
      
      if ((endVal == -1) || (endVal > tmpLocFaculties.length())) {
        endFlag = true;
        endVal = tmpLocFaculties.length();
      }
      
      String tmpNew = tmpLocFaculties.substring(beginVal, endVal);

			tmpNew = tmpNew.toLowerCase();
			
			if (faculties.contains(tmpNew) == true) {
      	locFaculties.add(tmpNew);
			}
			
      beginVal = endVal + 2;
      
    }

		locFaculties.add("other");
    
  }
  
  // get partners from string into arraylist
  void getPartners(String tmpLocPartners) {
    
    boolean endFlag = false;
    int beginVal = 0, endVal = 0;
    
    // read out from string into arraylist
    while(endFlag == false) {
      
      endVal = tmpLocPartners.indexOf(",", beginVal);
      
      if ((endVal == -1) || (endVal > tmpLocPartners.length())) {
        endFlag = true;
        endVal = tmpLocPartners.length();
      }
      
      String tmpNew = tmpLocPartners.substring(beginVal, endVal);
      locPartners.add(tmpNew);
      beginVal = endVal + 2;
      
    }
    
  }

	void zoomIn() {
		
	  Ani.to(this, 1, "dotSize", selectedDotSize);
	  zoomed = true;
		showLocDotStaticLines = true;
	
	}
			
	void zoomOut() {
		
    Ani.to(this, 1, "dotSize", unselectedDotSize);
    Ani.to(this, 1, "xpos", this.origxpos);
    Ani.to(this, 1, "ypos", this.origypos);
    zoomed = false;
		showInfo = false;
		showLocDotStaticLines = false;
		isSelected = false;
	
	}
	
	void showLines() {
		
		for (int i = 0; i < locPartners.size(); i++) {
			
			stroke(255, 50);
			noFill();
		  beginShape();
		  vertex(xpos, ypos - selectedDotSize / 2);
			
			String tmpLocPartner = (String) locPartners.get(i);
			String tmpLocPartnerX = tmpLocPartner.substring(0, tmpLocPartner.indexOf("/"));
			String tmpLocPartnerY = tmpLocPartner.substring(tmpLocPartner.indexOf("/") + 1);
			
			bezierDetail(50);
	  	bezierVertex(xpos, ypos-100, width/2, 200, Integer.parseInt(tmpLocPartnerX) / divider, Integer.parseInt(tmpLocPartnerY) / divider);
	
		  endShape();
			noStroke();
	
		}
		
	}
	
	void showInfocard() {
		
		if (hasInfoCard == false) {
			myInfoCard = new InfoCard(this);
			infoCards.add(myInfoCard);
			hasInfoCard = true;
		} else {
			myInfoCard.display();
		}
		
	}
	
	void drawSelectedDot() {
		
	  for (int i = 0; i < locationDots.size(); i++) {
	    LocationDot tmpLocDot = (LocationDot) locationDots.get(i);
	    tmpLocDot.isSelected = false;
	  }
	
		isSelected  = true;
		
		int tmpAngle = 360 / locFaculties.size();
		float lastAng = 0;

		for (int i = 0; i < locFaculties.size(); i++) {
			
			int tmpColor = #ffffff;
			String tmpFaculty = (String) locFaculties.get(i);
			
			// TODO has to be customized to the database
			if (tmpFaculty.equals("produktdesign")) {
				tmpColor = #ff00f6;
			} else if (tmpFaculty.equals("interiordesign")) {
				tmpColor = #ff0060;
			} else if (tmpFaculty.equals("industrial design")) {
				tmpColor = #ff3600;
			} else if (tmpFaculty.equals("modedesign")) {
				tmpColor = #ff6600;
			} else if (tmpFaculty.equals("kommunikationsdesign")) {
				tmpColor = #00aeff;
			} else if (tmpFaculty.equals("visuelle kommunikation")) {
				tmpColor = #0054ff;
			} else if (tmpFaculty.equals("fotografie")) {
				tmpColor = #682cff;
			} else if (tmpFaculty.equals("interfacedesign")) {
				tmpColor = #00ff1e;
			} else if (tmpFaculty.equals("motion design")) {
				tmpColor = #ffde00;
			} else if (tmpFaculty.equals("digitale medien")) {
				tmpColor = #098500;
			} else {
				tmpColor = #979797;
			}
			
		  fill(tmpColor);
		  arc(xpos, ypos, selectedDotSize, selectedDotSize, lastAng, lastAng+radians(tmpAngle));
		  lastAng += radians(tmpAngle);
		
			// draw info button
    	fill(#ffffff);
    	ellipse(xpos, ypos, selectedDotSize / 3, selectedDotSize / 3);
		
		}
		
	}
  
  void mouseEvent(MouseEvent event) {
	
		if (tappingOn == true) {
			return;
		}
    
    switch(event.getID()) {
      
      case MouseEvent.MOUSE_CLICKED:
      
        if ((dist(mouseX, mouseY, xpos, ypos) < dotSize / 2) && (dist(mouseX, mouseY, xpos, ypos) > dotSize / 4)) {
          
					// kill all other info
					for (int i = 0; i < locationDots.size(); i++) {
					
						LocationDot tmpLocDot = (LocationDot) locationDots.get(i);
						tmpLocDot.showInfo = false;
						
					}

          // show infocard, display lines
					showInfo = true;
            
        } else if (dist(mouseX, mouseY, xpos, ypos) < dotSize / 4) {
					// show main infocard
				}

        break;
      
    }
    
  }

	void tapEvent(float xtapIn, float ytapIn, int taptype) {
		
		if (tappingOn == false) {
			return;
		}
		
		xtap = xtapIn;
		ytap = ytapIn;
		
		switch (taptype) {
			
			case 3:
			
      if ((dist(xtap, ytap, xpos, ypos) < dotSize / 2) && (dist(xtap, ytap, xpos, ypos) > dotSize / 4)) {

				// kill all other info
				for (int i = 0; i < locationDots.size(); i++) {

					LocationDot tmpLocDot = (LocationDot) locationDots.get(i);
					tmpLocDot.showInfo = false;

				}

	      // show infocard, display lines
				showInfo = true;

			}	else if (dist(xtap, ytap, xpos, ypos) < dotSize / 4) {
				// show main infocard
			}
			
			break;
			
		}
		
	}
  
}
