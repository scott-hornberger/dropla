/*
 *  Dispenser object (VENT) at top of environment. Contains the drop points, but looks like it dispenses balls from the heavens.
 */

class TopDispenser {
  //Body body;      
  float leftBoundDest, rightBoundDest, yBounds;
  DropPoint[] dropPoints;
  float boundY, h, w; // Dimensions of Boundaries
  float dispenserWidth;
  int blockRate;
  Vec2 leftBoundPos; 
  Vec2 rightBoundPos;

  ArrayList<Ball> littleBalls;
  ArrayList<Ball> bigBalls;
  Boundary boundL;
  Boundary boundR;

  public TopDispenser() {
    boundY = 0;
    h = height / 4;
    w = 30;
    yBounds = boundY;
    blockRate = 1000000;

    boundL = new Boundary(width/3, yBounds, w, h);
    boundR = new Boundary(2*width/3, yBounds, w, h);
    dropPoints = new DropPoint[4];
    initializeDropPoints();
    setVertices(width/2, width/4);

    littleBalls = new ArrayList<Ball>();
    bigBalls = new ArrayList<Ball>();
  }

  public void setVertices(float xX, float wW) {
    leftBoundDest = xX - wW/2;
    rightBoundDest = xX + wW/2;
    leftBoundPos = box2d.getBodyPixelCoord(boundL.body);
    rightBoundPos = box2d.getBodyPixelCoord(boundR.body);

    dispenserWidth = rightBoundPos.x - leftBoundPos.x;
    setDropPoints();
  }

  private void initializeDropPoints() {
    for (int i = 0; i < 4; i++) {
      dropPoints[i] = new DropPoint();
    }
  }

  public void setBlockRate(int blockRate) {
    this.blockRate = blockRate;
  }
  
  public void setDropPoints() {

    float fifth = (rightBoundPos.x - leftBoundPos.x) / 5;
    for (int i = 1; i < 5; i++) {
      dropPoints[i - 1].setPosition(leftBoundPos.x + (i*fifth));
    }
  }

 public void displayBounds() {  // Will later be removed. For debugging.
    boundL.display();
    boundR.display();
  }

  public void displayDots() {  // Will later be removed. For debugging.
    for (int i = 0; i < 4; i++) {
      fill(cb1);
      int setting = dropPoints[i].mod;
      float xPosition = dropPoints[i].xPos;
      //text(setting,xPosition, 50, 10);
      float numCircles = max(1,6 - (log(setting) / log(2)));
      for (int j = (int)numCircles; j >= 1; j--) {
        noStroke();
        if (j % 2 == 0)
          fill(cb5);
        else
          fill(ca5);
        float diameter = j * 10;
        rect(xPosition,50, diameter, diameter);
      }
    }
  }

  public void updateBalls(ArrayList<Ball> balls) {
    round %= blockRate;

    // Display all the balls
    for (Ball b : balls) {
      b.displayImage();
    }
    //Delete balls as they go off screen
    for (int i = balls.size()-1; i >= 0; i--) {
      Ball b = balls.get(i);
      if (b.offScreen()) {
        b.destroyBody();
        balls.remove(i);
      }
    }

    if (round == 0) {
      for (int i = 0; i < 4; i++) {
        if (dropPoints[i].isReady()) {
          if (mousePressed) {
            Ball p = new Ball(dropPoints[i].xPos, yBounds, width/10, width/10);
            bigBalls.add(p);
          } else {
            Ball p = new Ball(dropPoints[i].xPos, yBounds, width/70, width/70);
            littleBalls.add(p);
          }
        }
      }
    }
  }

    public void update() {
      boundL.moveSide(leftBoundDest, yBounds);
      boundR.moveSide(rightBoundDest, yBounds);
    }

    public float getLeftX() {
      return boundL.getX();
    }

    public float getRightX() {
      return boundR.getX();
    }

    public float getLeftY() {
      return boundL.getY();
    }

    public float getRightY() {
      return boundR.getY();
    }

    public float getOuterLeftX() {
      return boundL.getX() - (boundL.getWidth() / 2);
    }

    public float getOuterRightX() {
      return boundR.getX() + (boundR.getWidth() / 2);
    }

    public float getInnerLeftX() {
      return boundL.getX() + (boundL.getWidth() / 2);
    }

    public float getInnerRightX() {
      return boundR.getX() - (boundR.getWidth() / 2);
    }

    public float getUpperLeftY() {
      return boundL.getY() - (boundL.getHeight() / 2);
    }

    public float getUpperRightY() {
      return boundR.getY() - (boundR.getHeight() / 2);
    }

    public float getLowerLeftY() {
      return boundL.getY() + (boundL.getHeight() / 2);
    }

    public float getLowerRightY() {
      return boundR.getY() + (boundR.getHeight() / 2);
    }

    public float xOffset() {
      return 2 * ((boundR.getWidth() + boundL.getWidth()) / 2);
    }

    public float yOffset() {
      return 30; // Arbitrary - go with what looks good.
    }

    public void displayFrontRect() {
      fill(ca1);
      beginShape();
      vertex(getOuterLeftX(), getUpperLeftY());
      vertex(getInnerRightX(), getUpperRightY());
      //vertex(getInnerRightX() + xOffset(), getUpperRightY());
      //vertex(getInnerRightX() + xOffset(), getLowerRightY() + yOffset());
      vertex(getInnerRightX(), getLowerRightY());
      vertex(getOuterLeftX(), getLowerLeftY());
      endShape();
    }

    public void displayFrontPolygon() {
      fill(ca3);
      beginShape();
      vertex(getInnerRightX() -5, getUpperRightY());
      vertex(getInnerRightX() + xOffset(), getUpperRightY());
      vertex(getInnerRightX() + xOffset(), getLowerRightY() + yOffset());
      vertex(getInnerRightX() - 2, getLowerRightY());
      endShape();
    }

    public void displayBackRect() {
      fill(ca4);
      beginShape();
      vertex(getOuterLeftX() + xOffset(), getUpperLeftY() + yOffset());
      vertex(getInnerRightX() + xOffset(), getUpperRightY() + yOffset());
      vertex(getInnerRightX() + xOffset(), getLowerRightY() + yOffset());
      vertex(getOuterLeftX() + xOffset(), getLowerRightY() + yOffset());
      endShape();
    }

    public void displayBackPolygon() {
      fill(ca5);
      beginShape();
      vertex(getOuterLeftX(), getUpperLeftY());
      vertex(getOuterLeftX() + xOffset() + 5, getUpperLeftY());
      vertex(getOuterLeftX() + xOffset(), getLowerRightY() + yOffset());
      vertex(getOuterLeftX(), getLowerLeftY());
      endShape();
    }
  }
