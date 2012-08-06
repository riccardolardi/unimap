// library imports
import de.bezier.data.*;
import de.looksgood.ani.*;
import processing.opengl.*;
import TUIO.*;

// the background image
PImage backgroundImage;

// the xls reader
XlsReader reader;

// the cursor
Cursor touchCursor;

// the static location dot
LocationDotStatic locDotStatic;

// the location dot
LocationDot locDot;

// the infocard
InfoCard infoCard;

// the cardboard
CardBoard cardBoard;

// the tuio client
TuioProcessing tuioClient;

// the sliders
Slider sliderClimate;
Slider sliderFees;
Slider sliderWater;
Slider sliderPopulation;

// the radial menus
RadialMenu radialMenuLeft;
RadialMenu radialMenuRight;

// global variables
int customSize[] = {1080, 1920};
int divider = 1;
boolean tappingOn = true;
boolean rotationOn = true;

ArrayList locationDotsStatic;
ArrayList locationDots;
ArrayList zoomedDots;
ArrayList infoCards;
ArrayList dockedCards;
ArrayList universities;
ArrayList faculties;

void setup() {

  // stuff
  smooth();
  noStroke();

  // set the size
  size(customSize[0] / divider, customSize[1] / divider, OPENGL);

  // setup background image
  backgroundImage = loadImage("background.png");
  backgroundImage.resize(customSize[0] / divider, customSize[1] / divider);

  // init tuio client
  tuioClient  = new TuioProcessing(this);

  // create cursor
  touchCursor = new Cursor();

  // create card board
  cardBoard = new CardBoard();

  // init animation lib
  Ani.init(this);

  // setup faculties
  setupFaculties();

  // load data.xls & create location dots
  reader = new XlsReader(this, "data.xls");
  createLocDots("all", 0);

  // init array list for zoomed dots
  zoomedDots = new ArrayList();

  // init array list for infocards
  infoCards = new ArrayList();

  // init array list for docked infocards
  dockedCards = new ArrayList();

  // setup universities
  setupUniversities();

  // make sliders
  makeSliders();

  // make radial menus
  makeRadialMenus();
}

void draw() {

  // background image
  image(backgroundImage, 0, 0);

  // movement
  move();

  // displaying things
  display();
  
  fill(255, 0, 0, 200);
  // ellipse(myx, myy, 50, 50);

}

void move() {

  // move the cursor
  touchCursor.move();

  // move the location dots
  for (int i = 0; i < locationDots.size(); i++) {

    LocationDot tmpLocDot = (LocationDot) locationDots.get(i);

    // check if cursor is over some location dot
    if ((tmpLocDot.origxpos >= touchCursor.xpos - touchCursor.cursorSize / 2) && (tmpLocDot.origxpos <= touchCursor.xpos + touchCursor.cursorSize / 2) && 
      (tmpLocDot.origypos >= touchCursor.ypos - touchCursor.cursorSize / 2) && (tmpLocDot.origypos <= touchCursor.ypos + touchCursor.cursorSize / 2)) {

      // display zoomed view of location dot
      if (tmpLocDot.zoomed == false) {
        zoomedDots.add(tmpLocDot);
        tmpLocDot.zoomIn();
      }
    } 
    else {

      // go back to normal
      if (tmpLocDot.zoomed == true) {
        zoomedDots.remove(tmpLocDot);
        tmpLocDot.zoomOut();
      }
    }

    // move
    tmpLocDot.move();
  }

  // move the infocards
  for (int i = 0; i < infoCards.size(); i++) {

    InfoCard tmpInfoCard = (InfoCard) infoCards.get(i);
    tmpInfoCard.move();
  }

  // move the sliders
  sliderClimate.move();
  sliderFees.move();
  sliderWater.move();
  sliderPopulation.move();
}

void display() {

  // display the cursor
  touchCursor.display();

  // display the static location dots
  for (int i = 0; i < locationDotsStatic.size(); i++) {

    LocationDotStatic tmpLocDotStatic = (LocationDotStatic) locationDotsStatic.get(i);
    tmpLocDotStatic.display();
  }

  // display the location dots
  for (int i = 0; i < locationDots.size(); i++) {

    LocationDot tmpLocDot = (LocationDot) locationDots.get(i);
    tmpLocDot.display();
  }

  // display the infocards
  for (int i = 0; i < infoCards.size(); i++) {

    InfoCard tmpInfoCard = (InfoCard) infoCards.get(i);
    tmpInfoCard.display();
  }

  // display the sliders
  sliderClimate.display();
  sliderFees.display();
  sliderWater.display();
  sliderPopulation.display();

  // display the radial menus
  radialMenuLeft.display();
  radialMenuRight.display();
}

void setupFaculties() {

  faculties = new ArrayList();

  faculties.add("kommunikationsdesign");
  faculties.add("visuelle kommunikation");
  faculties.add("fotografie");
  faculties.add("produktdesign");
  faculties.add("interiordesign");
  faculties.add("industrial design");
  faculties.add("modedesign");
  faculties.add("motion design");
  faculties.add("interfacedesign");
  faculties.add("digitale medien");
}

void setupUniversities() {

  universities = new ArrayList();

  // loop through loc dots and extract uni name
  for (int i = 0; i < locationDots.size(); i++) {

    LocationDot tmpLocDot = (LocationDot) locationDots.get(i);
    universities.add(tmpLocDot.locName);

  }

}

void createLocDots(String filter, int filterValue) {

  // create arraylist for all static location dot objects
  locationDotsStatic = new ArrayList();

  // create arraylist for all location dot objects
  locationDots = new ArrayList();

  // get the number of rows
  int numRows = reader.getLastRowNum();

  // jump to the right spot
  reader.firstCell();
  reader.firstRow();
  reader.nextRow();

  // loop through rows and create location dots
  while (reader.hasMoreRows()) {

    // goto first cell and next row
    reader.firstCell();
    reader.nextRow();

    // continue if row is empty
    if (reader.getString() == "") {
      continue;
    }

    // variables
    String locCountry, locCity, locName, 
    locFaculties, locPartners;

    int locPopulation, xpos, ypos, 
    locClimate, locFees, locWater;

    // get data into variables
    locCountry = reader.getString();
    reader.nextCell();
    locCity = reader.getString();
    reader.nextCell();
    locName = reader.getString();
    reader.nextCell();
    locFaculties = reader.getString();
    reader.nextCell();
    locPartners = reader.getString();
    reader.nextCell();
    locPopulation = reader.getInt();
		if ((filter == "Population") && (locPopulation != filterValue)) {
			continue;
		}
    reader.nextCell();
    locClimate = reader.getInt();
		if ((filter == "Climate") && (locClimate != filterValue)) {
			continue;
		}
    reader.nextCell();
    locFees = reader.getInt();
		if ((filter == "Fees") && (locFees != filterValue)) {
			continue;
		}
    reader.nextCell();
    locWater = reader.getInt();
		if ((filter == "Water") && (locWater != filterValue)) {
			continue;
		}
    reader.nextCell();
    xpos = reader.getInt() / divider;
    reader.nextCell();
    ypos = reader.getInt() / divider;

    // create static location dot
    locDotStatic = new LocationDotStatic(xpos, ypos);

    // create location dot
    locDot = new LocationDot(locCountry, locCity, locName, 
    locFaculties, locPartners, 
    locPopulation, locClimate, locFees,
    locWater, xpos, ypos, locDotStatic);

    locationDotsStatic.add(locDotStatic);
    locationDots.add(locDot);

    // debug
    //println("Added location: " + locDot.locName);
  }
}

void mouseDragged() {
	radialMenuLeft.drag();
	radialMenuRight.drag();
}

void mouseReleased() {
	
	if ((mouseX > 70 / divider) && (mouseX < 330 / divider) && (mouseY > 1735 / divider) && (mouseY < 1865 / divider)) {
		radialMenuLeft.release();
	}
	
	if ((mouseX > 780 / divider) && (mouseX < 1050 / divider) && (mouseY > 1740 / divider) && (mouseY < 1867 / divider)) {
		radialMenuRight.release();
	}
	
}

void makeSliders() {

  sliderClimate = new Slider(990, 614, "Climate");
  sliderFees = new Slider(990, 865, "Fees");
  sliderWater = new Slider(990, 1128, "Water");
  sliderPopulation = new Slider(990, 1378, "Population");

}

void makeRadialMenus() {

  radialMenuLeft = new RadialMenu(130, 1792, universities, 0);
  radialMenuRight = new RadialMenu(848, 1792, faculties, 1);

}

// show fps when ENTER is pressed
void keyPressed() {

  if (key == BACKSPACE) {
    println("FPS: " + frameRate);
  } 
  else if ((key == ENTER) || (key == RETURN)) {
    if (tappingOn == true) {
      println("Tapping: off");
      tappingOn = false;
    } 
    else {
      println("Tapping: on");
      tappingOn = true;
    }
  } 
  else if (key == TAB) {
    if (rotationOn == true) {
      println("Rotation: off");
      rotationOn = false;
    } 
    else {
      println("Rotation: on");
      rotationOn = true;
    }
  }
}

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
}

// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  println("add cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());

  if (rotationOn == true) {
    PVector v = mapCoords(tcur);
    tapEvent(v.x, v.y, 1);
  } else {
	PVector v = normalCoords(tcur);
	tapEvent(v.x, v.y, 1);
  }
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {

  println("update cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
    +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());

  if (rotationOn == true) {
    PVector v = mapCoords(tcur);
    tapEvent(v.x, v.y, 2);
  } else {
	PVector v = normalCoords(tcur);
	tapEvent(v.x, v.y, 2);
  }
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {

  println("remove cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");

  if (rotationOn == true) {
    PVector v = mapCoords(tcur);
    tapEvent(v.x, v.y, 3);
  } else {
	PVector v = normalCoords(tcur);
	tapEvent(v.x, v.y, 3);
  }
}

// called after each message bundle
// representing the end of an image frame
void refresh(TuioTime bundleTime) { 
  redraw();
}

float myx, myy;

void tapEvent(float xtap, float ytap, int taptype) {
  myx = xtap;
  myy = ytap;

  // send tap to cursor
  touchCursor.tapEvent(xtap, ytap, taptype);
  
  // send tap to all location dots
  for (int i = 0; i < locationDots.size(); i++) {

    LocationDot tmpLocDot = (LocationDot) locationDots.get(i);
    tmpLocDot.tapEvent(xtap, ytap, taptype);
  }

  // send tap to all infocards
  for (int i = 0; i < infoCards.size(); i++) {

    InfoCard tmpInfoCard = (InfoCard) infoCards.get(i);
    tmpInfoCard.tapEvent(xtap, ytap, taptype);
  }

  // send tap to sliders
  sliderClimate.tapEvent(xtap, ytap, taptype);
  sliderFees.tapEvent(xtap, ytap, taptype);
  sliderWater.tapEvent(xtap, ytap, taptype);
  sliderPopulation.tapEvent(xtap, ytap, taptype);

  // send tap to radial menus
  radialMenuLeft.tapEvent(xtap, ytap, taptype);
  radialMenuRight.tapEvent(xtap, ytap, taptype);
  
}

PVector normalCoords(TuioCursor tcur) {
  float x = tcur.getScreenX(width);
  float y = tcur.getScreenY(height);
  return new PVector(x, y);
}

PVector mapCoords(TuioCursor tcur) {
  // Note: width and height are interchanged!
  float x = tcur.getScreenX(height);
  float y = tcur.getScreenY(width);

  //println("x: " + x);
  //println("y: " + y);

  PVector p = new PVector();
  // Clock-wise rotation
  p.x = y;
  p.y = height - x;

  //println("p.x: " + p.x);
  //println("p.y: " + p.y);

  return p;
}
