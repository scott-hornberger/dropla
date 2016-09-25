public void initializePhysics() {
  // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);  
  box2d.createWorld();
  box2d.setGravity(0, -20);
}