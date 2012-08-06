public class RadialMenu {
	
	PFont font;
	String[] labels;
	String tmpString;
	String currentSelection;

	int countLabels;

	float centerX, centerY;
	float angleOffset = 0;
	float interactiveAngleDist = 0;

	int snapTicNumber;
	float snapAngleStep;
	
	ArrayList data;
	ArrayList selectionList;
	int type;

	RadialMenu(float xloc, float yloc, ArrayList _data, int _type) {
		
		data = new ArrayList(_data);
		selectionList = new ArrayList();
		type = _type;
		// 0 = unis, 1 = faculties
		
		centerX = xloc / divider;
		centerY = yloc / divider;
		
		font = createFont("sans-serif", 10);
		textFont(font, 10);
		
 		countLabels = data.size() - 2;
		
		snapTicNumber = countLabels;
		snapAngleStep = TWO_PI / snapTicNumber;

		createLabels();
		
	}

	void display() {

		fill(255);
		pushMatrix();
		translate(centerX, centerY);
		pushMatrix();
		rotate(angleOffset);
		float totalAngleDiffs = 0;
		float angleDiff = TWO_PI / countLabels;
		for (int i = 0; i < countLabels; i++) {
			pushMatrix();
			totalAngleDiffs += angleDiff;
			rotate(totalAngleDiffs);

			float totalAngle = totalAngleDiffs + angleOffset;
			float normAngle = abs(getRangedAngle(totalAngle));

			// String debug = i + ". " + nfs(totalAngleDiffs, 1, 2) + ", " + nfs(angleOffset, 1, 2) + "=" + nfs(totalAngle, 1, 2) + "(" + nfs(normAngle, 2, 1) + ")";

			float fontSize = map(normAngle, 0, TWO_PI, 4, 10) / divider;
			textFont(font, fontSize);
	    float alpha = map(normAngle, 0, TWO_PI, 0, 255);
	    fill(255, alpha);
	
			tmpString = labels[i];
			
			if ((degrees(normAngle) > 358) && (degrees(normAngle) < 360)) {
				currentSelection = tmpString;
			}
	
			if (tmpString.length() > 15) {
				tmpString = labels[i].substring(15).concat("..."); 
			}
	
			text(tmpString, 50 / divider, 0);
			// text(debug, 100, 0);
			fontSize -= 0.4;
			popMatrix();
		}
		popMatrix();

		fill(255);
		noStroke();
		// rect(0, 0, 40, 40);

		popMatrix();
		
		switch (type) {
			
			case 0:
			pushMatrix();
			translate(180 / divider, 1820 / divider);
			textFont(font, 10 / divider);
			for (int i = 0; i < selectionList.size(); i++) {
				String tmpSelectionItem = (String) selectionList.get(i);
				if (tmpSelectionItem.length() > 15) {
					tmpSelectionItem = tmpSelectionItem.substring(15).concat("..."); 
				}
				fill(#06b6ff);
				text(tmpSelectionItem, 0, i * 15 / divider);
			}
			popMatrix();
			break;
			
			case 1:
			pushMatrix();
			translate(895 / divider, 1820 / divider);
			textFont(font, 10 / divider);
			for (int i = 0; i < selectionList.size(); i++) {
				String tmpSelectionItem = (String) selectionList.get(i);
				if (tmpSelectionItem.length() > 15) {
					tmpSelectionItem = tmpSelectionItem.substring(15).concat("..."); 
				}
				fill(#06b6ff);
				text(tmpSelectionItem, 0, i * 15 / divider);
			}
			popMatrix();
			break;
			
		}
		
	}
	
	void createLabels() {
		
		labels = new String[countLabels];
		
	  for (int i = 0; i < countLabels; i++) {

	    String tmpData = (String) data.get(i);
			labels[i] = tmpData;

	  }
	
	}

	public float getSnappedAngle(float angle) {
	  return ceil(angle / snapAngleStep) * snapAngleStep;
	}

	public float getAngleBetween(PVector p1, PVector p2) {
	  return (float) Math.atan2(p2.y - p1.y, p2.x - p1.x);
	}

	protected float getRangedAngle(float angle) {
		float rangedAngle = angle;
		if (rangedAngle > TWO_PI) {
			rangedAngle = TWO_PI - rangedAngle;
		} else {
			if (rangedAngle < 0) {
				rangedAngle = TWO_PI + rangedAngle;
			}
		}
		return rangedAngle;
	}
	
	void drag() {
		
		if ((dist(mouseX, mouseY, centerX, centerY) < 85 / 2 / divider) && (dist(mouseX, mouseY, centerX, centerY) > 28 / 2 / divider)) {
		
		  PVector center = new PVector(centerX, centerY);
		  PVector check = new PVector(mouseX, mouseY);
		  float checkAngle = getAngleBetween(center, check);

		  PVector oldCheck = new PVector(pmouseX, pmouseY);
		  float oldAngle = getAngleBetween(center, oldCheck);

		  float diffAngle = oldAngle - checkAngle;

		  angleOffset -= diffAngle;
	
		}
		
	}
	
	void release() {
		
		if ((dist(mouseX, mouseY, centerX, centerY) < 85 / 2 / divider) && (dist(mouseX, mouseY, centerX, centerY) > 28 / 2 / divider)) {
			
			angleOffset = getSnappedAngle(angleOffset);
			
		}
		
		if (dist(mouseX, mouseY, centerX, centerY) < 15 / divider) {
			
			if (selectionList.contains(currentSelection) == false) {
				selectionList.add(currentSelection);
			}
			// now filter...
			
		}
		
		if (((mouseX > 175 / divider) && (mouseX < 340 / divider) && (mouseY > 1802 / divider) && (mouseY < 1900 / divider))
		|| ((mouseX > 891 / divider) && (mouseX < 1058 / divider) && (mouseY > 1808 / divider) && (mouseY < 1906 / divider))) {
			
			if (selectionList.size() > 0) {
				selectionList.remove(selectionList.size()-1);
			}
			// now filter...
			
		}
		
	}
	
  void tapEvent(float xtapIn, float ytapIn, int taptype) {

    if (tappingOn == false) {
      return;
    }

    float xtap = xtapIn;
    float ytap = ytapIn;

		if ((dist(xtap, ytap, centerX, centerY) < 85 / 2 / divider) && (dist(xtap, ytap, centerX, centerY) > 28 / 2 / divider)) {

			switch (taptype) {
				
				case 2:
				
			  PVector center = new PVector(centerX, centerY);
			  PVector check = new PVector(mouseX, mouseY);
			  float checkAngle = getAngleBetween(center, check);

			  PVector oldCheck = new PVector(pmouseX, pmouseY);
			  float oldAngle = getAngleBetween(center, oldCheck);

			  float diffAngle = oldAngle - checkAngle;

			  angleOffset -= diffAngle;
				
				break;
				
				case 3:

				angleOffset = getSnappedAngle(angleOffset);
				
				break;
				
			}

		}
		
		if (dist(xtap, ytap, centerX, centerY) < 15 / divider) {
			
			if (selectionList.contains(currentSelection) == false) {
				selectionList.add(currentSelection);
			}
			// now filter...
			
		}
		
		if (((xtap > 175 / divider) && (xtap < 340 / divider) && (ytap > 1802 / divider) && (ytap < 1900 / divider))
		|| ((xtap > 891 / divider) && (xtap < 1058 / divider) && (ytap > 1808 / divider) && (ytap < 1906 / divider))) {
			
			if (selectionList.size() > 0) {
				selectionList.remove(selectionList.size()-1);
			}
			// now filter...
			
		}

  }
		
}
