class Star extends PhysicalObject {

  private PVector velocity;
  private PVector acceleration;


  public Star() {
  }

  public void show() {
  }

  public void applyForce(PVector force) {
    PVector f = PVector.div(force, this.getMass());
    this.acceleration.add(f);
  }

  public void update() {
    velocity.add(acceleration);
    this.getLocation().add(velocity);

    acceleration.mult(0);
  }

  public PVector getVelocity()
  {
    return this.velocity;
  }

  public void setVelocity(PVector velocity)
  {
    this.velocity = velocity;
  }

  public PVector getAcceleration()
  {
    return this.acceleration;
  }

  public void setAcceleration(PVector acceleration)
  {
    this.acceleration = acceleration;
  }
}