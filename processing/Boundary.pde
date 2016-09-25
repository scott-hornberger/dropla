/*
 *  Create and set the sides of the dispenser object
 */


public class Boundary {
  
  Body body;
  float w;
  float h;
  
  public Boundary(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;
    // Add the box to the box2d world
    makeBody(new Vec2(x,y),w,h);
  }
  
  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 startPos, float w_, float h_) {
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.fixedRotation = true;
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(startPos));
    
    body = box2d.createBody(bd);

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.1;
    fd.restitution = 0.5;

    body.createFixture(fd);
    //body.setMassFromShapes();

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    //body.setAngularVelocity(random(-5, 5));
  }
  
    // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(cb5);
    noStroke();
    rect(0,0,w,h);
    popMatrix();
  }
  
  void moveSide(float x_,float y_) {
    Vec2 bodyPos = body.getWorldCenter();
    Vec2 mousePos = new Vec2(box2d.coordPixelsToWorld(x_,y_));
    Vec2 vel = mousePos.sub(bodyPos);
    float time = 1;
    vel.mulLocal(1 / time);
    body.setLinearVelocity( vel );
  }
  
  float getX() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    return pos.x;
  }
  
  float getY() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    return pos.y;
  }
  
  float getWidth() {
    return w;
  }
  
  float getHeight() {
    return h;
  }
  
  
  
}
