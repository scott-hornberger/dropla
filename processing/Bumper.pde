/*
 *  Pong like bumper
 */  


class Bumper {
  float x, y, h, w;
  float curAngle;
  color c;
  Body body;

  public Bumper(float x, float y, float h, float w, color c) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    createBody(x, y, w, h);
  }

  public void createBody(float x, float y, float w, float h) {
    Vec2 startPos = new Vec2(x, y);
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.fixedRotation = false;
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(startPos));

    body = box2d.createBody(bd);

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.1;
    fd.restitution = 0.5;

    body.createFixture(fd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }

  // Drawing the bumper
  void display() {
    // get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = -1 * body.getAngle();

    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(c);
    noStroke();
    rect(0, 0, w, h);
    popMatrix();
  }

  void move() {
    Vec2 bodyPos = body.getWorldCenter();
    Vec2 destPos = new Vec2(box2d.coordPixelsToWorld(x, y));
    Vec2 vel = destPos.sub(bodyPos);
    float time = 1;
    vel.mulLocal(1 / time);
    body.setLinearVelocity( vel );
  }

  void turn() {
    float angleDiff = curAngle - body.getAngle();
    float time = .6;
    float angleVel = angleDiff / time;
    body.setAngularVelocity(angleVel);
  }
  
  void update(float x, float y, float angle) {
    this.x = x;
    this.y = y;
    this.curAngle = angle;
  }
}
