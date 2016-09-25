/*
 * Create, track, and destroy balls
 */

class Ball {
  //  Instead of any of the usual variables, we will store a reference to a Box2D Body
  Body body;      
  
  boolean hasPlayed; // whether ball has played a note once
  float w, h;

  Ball(float x, float y, float w, float h) {
    //w = 16;
    //h = 16;  // makes circles
   
      this.w = w; 
      this.h = h;
    
    // Build Body
    BodyDef bd = new BodyDef();      
    bd.type = BodyType.DYNAMIC;
    
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bd);


    // Define a polygon
    CircleShape ps = new CircleShape();
    float box2dR = box2d.scalarPixelsToWorld(w/2);
    ps.setRadius(box2dR); 
    
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 1;

    // Attach Fixture to Body               
    body.createFixture(fd);
    body.setLinearVelocity(new Vec2(0, -2));
  }

  void display() {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x, pos.y);    // Using the Vec2 position and float angle to
    rotate(-a);              // translate and rotate the rectangle
    fill(cb5);
    noStroke();
    ellipseMode(CENTER);
    ellipse(0, 0, w, h);
    popMatrix();
  }
  
  void displayImage() {
      Vec2 pos = box2d.getBodyPixelCoord(body);    
      imageMode(CENTER);
      image(ball, pos.x, pos.y, w, h);
  }

  void destroyBody() { 
    box2d.destroyBody(body);
  }

  boolean offScreen() {
    Vec2 pos = box2d.getBodyPixelCoord(body);  
    return (pos.x > width + width / 2) || (pos.x < -width / 2) ||
      (pos.y > height + 10) || (pos.y < -20);
  }
  
  float getX() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    return pos.x;
  }
  
  float getY() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    return pos.y;
  }
  
  boolean hasPlayed() {
    return hasPlayed;
  }
  
  void setHasPlayed(boolean b) {
    hasPlayed = b;
  }
}
