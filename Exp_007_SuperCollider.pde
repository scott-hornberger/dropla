// OSC IMPORTS
import netP5.*;
import oscP5.*;

// SERIAL IMPORTS
import processing.serial.*;

// PHYSICS IMPORTS
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// SERIAL INSTANCE VARIABLES
final int NUM_SENSORS = 15;
Serial myPort;   // The serial port
int[] serialInArray = new int[NUM_SENSORS];   // Where we'll sensor info
int serialCount = 0;    // A count of how many bytes we receive
boolean firstContact = false;        // Whether we've heard from the microcontroller

// PHYSICS OBJECT
ArrayList<Ball> balls; // To track all ball objects on screen
TopDispenser dispenser;// Manipulatable object from which to drop balls
Bumper bumper1;        // Manipulatalbe object by which to direct balls
Bumper bumper2;        // "                                           "
ArrayList walls;       // Static walls
Box2DProcessing box2d; // Physics world object that does all calculations of gravity and collisions   
BucketKeyboard bKeyboard;
final int BUCKET_SEGMENTS = 7;

//OSC VARIABLES // KEY VALUES can be found at: http://cote.cc/w/wp-content/uploads/drupal/blog/logic-midi-note-numbers.png
OscP5 osc;
NetAddress superCollider;
int[] originalNotes = new int[BUCKET_SEGMENTS]; // 7 == number of notes in our special key
int[] currentNotes = new int[BUCKET_SEGMENTS];
final int OCTAVE = 12;
final int FIFTH = 5;

// GAME VARIABLES
int round; // Tracks the 'step' through time we've made. Used for controlling the bpm of the dropping balls.
float soundBoundary; 
float globalBlockRate;
PImage ball;
PImage backgroundImg;

// Color variable
// Primary color:

   color ca1 = color(30, 62,182); 
   color ca2 = color(54, 97,253); 
   color ca3 = color( 41, 86,250); 
   color ca4 = color( 33, 44, 83);
   color ca5 = color( 55, 63, 90);

// Secondary color (1):

   color cb1 = color(255,200, 13);
   color cb2 = color(255,203, 28);
   color cb3 = color(255,200, 14);
   color cb4 = color(123,104, 39);
   color cb5 = color(132,119, 75);
   color cb6 = color(255,234,110);

// Secondary color (2):

   color cc1 = color(255,161, 13);
   color cc2 = color(255,167, 28);
   color cc3 = color(255,161, 14);
   color cc4 = color(123, 90, 39);
   color cc5 = color(132,110, 75);

//color pinkLight = color(251,96,118);
//color pink1 = color(250,49,77);
//color pinkMain = color(250,0,34);
//color pink3 = color(246,0,34);
//color pinkDark = color(201,0,8);


void setup() { /////////////////////////////////////////////////////////////////////////////////
//fullScreen(P2D, SPAN);
  smooth(4);
  size(600,600, P2D);
  noStroke();    // No border on the next thing drawn

  openSerialConnections();

  initializePhysics(); // Box2d setup

  dispenser = new TopDispenser();
  
  
  
  
  
  
  
  
  bumper1 = new Bumper(width/3, height/2, width/80, width/5, ca1); // TODO: put these in ArrayList?
  bumper2 = new Bumper(2*width/3, height/2, width/80, width/5, ca5);
  
  
  
  
  
  
  
  
  walls = new ArrayList<Wall>();
  walls.add(new Wall(width+50, height/2, 100, height*2, 0));
  walls.add(new Wall(-50, height/2, 100, height*2, 0));
  bKeyboard = new BucketKeyboard();

  soundBoundary = height - (height/15);
  
  ball = loadImage("smallSphere2.png");
  backgroundImg = loadImage("gradientBG.png");

  osc = new OscP5(this, 12000);
   // Address can be found in supercollider, with method "NetAddr.localAddr;"
  superCollider = new NetAddress("127.0.0.1", 57120); // Specific to my computer now
  setNotes();
} ////////////////////////////////////////////////////////////////////////////////////////////////

void draw() {
  background(255,250,190);
  //rectMode(CORNER);
  //fill(cc5);
  //rect(0,0,width/4,height);
  //rect(width/2,0,width/4,height);
  imageMode(CORNER);
  image(backgroundImg, 0, 0, width, height);
  
  float arcDimensions = min(width,height)/3.0;
  fill(cb1);
  arc(width- arcDimensions/2, arcDimensions/2, arcDimensions, arcDimensions, -PI/2, -PI/2 + max(0.0001,(-0.01 * globalBlockRate + 1.05) * TWO_PI));

  bKeyboard.display2();

  stroke(255, 55, 0);
  //line(0, soundBoundary, width, soundBoundary);

  box2d.step(); // Step through physics world time

  // Diplay Walls
  for (int i = 0; i < walls.size(); i++) {
    Wall wall = (Wall) walls.get(i);
    wall.display();
  }

  // Dispenser updates and draw
  dispenser.update(); // moves dispenser
  dispenser.displayBackRect();
  dispenser.displayBackPolygon();
  dispenser.updateBalls(dispenser.littleBalls);
  dispenser.updateBalls(dispenser.bigBalls);
  dispenser.displayFrontPolygon();

  bumper1.move();
  bumper1.turn();
  bumper1.display();

  bumper2.move();
  bumper2.turn();
  bumper2.display();

  dispenser.displayFrontRect();

  round++; // Step through game time

  playNotes(dispenser.littleBalls, false);
  playNotes(dispenser.bigBalls, true);

  bKeyboard.display3();
  //dispenser.displayDots();
}

void noteShift(int signal1, int signal2) {
  for (int i = 0; i < currentNotes.length; i++) {
    currentNotes[i] = originalNotes[i] + (5 * (signal1)) + (7 * (signal2));
  }
}

void playNotes(ArrayList<Ball> balls, boolean isBig) {

  for (Ball b :balls) {
    if (shouldPlay(b)) {
      
      int pitch = getPitch(b);
      
      if (isBig)
        pitch -= 3 * OCTAVE;
        
      OscMessage msg = new OscMessage("/ball");
      msg.add(pitch);
      osc.send(msg, superCollider);
      
      b.setHasPlayed(true);
    }
  }
}

boolean shouldPlay(Ball b) {
  return b.getY() > soundBoundary && b.getY() < soundBoundary + 50 && !b.hasPlayed();
}

int getPitch(Ball b) {
  return (int) b.getX()/ (width/BUCKET_SEGMENTS) ;
}

void setNotes() {
  originalNotes[0] = 64;
  originalNotes[1] = 66;
  originalNotes[2] = 68;
  originalNotes[3] = 71;
  originalNotes[4] = 73;
  originalNotes[5] = 75;
  originalNotes[6] = 78;
  
  dropOctave(originalNotes);
  
  for (int i = 0; i < currentNotes.length; i++) {
    currentNotes[i] = originalNotes[i];
    currentNotes[i] = originalNotes[i];
  }
}
  
  void dropOctave(int[] notes) {
    for(int i = 0; i < notes.length; i++) {
      notes[i] -= OCTAVE;
    }
  }