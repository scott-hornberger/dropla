/*
 *  MUSICAL BUCKET OBJECTS
 */
 

public class BucketKeyboard {
  ArrayList<Wall> edges;


  public BucketKeyboard() {
    edges = new ArrayList<Wall>();
    for (int i = 1; i < 7; i++) {
      edges.add(new Wall((width * i)/7.0, height, width/600, height/6, 0));
    }
  }

  public void display() {
    // Diplay Walls

    for (int i = 0; i < edges.size(); i++) {
      Wall edge = (Wall) edges.get(i);
      edge.display();
    }
  }

  public void display2() {
    // Diplay Walls
    float x1 = width;
    float yOffset = height / 100;
    float xOffset = width / 100;
    float y = 0;
    float x2 = 0;

    for (int i = edges.size() - 1; i >= 0; i--) {
      Wall edge = (Wall) edges.get(i);
      x2 = edge.getX();
      y = edge.getY() - edge.getHeight() / 2;
      drawBackBucket(x1, x2, y, yOffset, xOffset);
      x1 = x2;
    }
    x2 = 0;
    drawBackBucket(x1, x2, y, yOffset, xOffset);
  }

  public void drawBackBucket(float x1, float x2, float y, float yOffset, float xOffset) {
    fill(ca4);
    beginShape();
    vertex(x1, y);
    vertex((x2+x1)/2 + xOffset, y - yOffset);
    vertex(x2, y);
    vertex(x2, height);
    vertex(x1, height);
    endShape();
    fill(ca1);
    beginShape();
    vertex((x2+x1)/2 + xOffset, height);
    vertex((x2+x1)/2 + xOffset, y - yOffset);
    vertex(x2, y);
    vertex(x2,height);
    endShape();
  }

  public void display3() {
    // Diplay Walls
    float x1 = width;
    float yOffset = height / 50;
    float xOffset = width / 100;
    float y = 0;
    float x2 = 0;

    for (int i = edges.size() - 1; i >= 0; i--) {
      Wall edge = (Wall) edges.get(i);
      x2 = edge.getX();
      y = edge.getY() - edge.getHeight() / 2;
      drawFrontBucket(x1, x2, y, yOffset, xOffset);
      x1 = x2;
    }
    x2 = 0;
    drawFrontBucket(x1, x2, y, yOffset, xOffset);
  }

  public void drawFrontBucket(float x1, float x2, float y, float yOffset, float xOffset) {
    fill(ca4);
    beginShape();
    vertex(x1, y);
    vertex((x2+x1)/2 - xOffset*2, y + yOffset*1.5);
    vertex(x2, y);
    vertex(x2, height);
    vertex(x1, height);
    endShape();
    fill(ca2);
    beginShape();
    vertex(x1, y);
    vertex((x2+x1)/2 - xOffset*2, y + yOffset*1.5);
    vertex((x2+x1)/2 - xOffset*2, height);
    vertex(x1, height);
    endShape();
  }
}
