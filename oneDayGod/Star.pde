class Star extends PhysicalObject {

  private PVector velocity;
  private PVector acceleration;

  public Star() {
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
  }

  public void show() {
    pushMatrix();
    translate(getLocation().x, getLocation().y);
    fill(this.getColor());
    ellipse(0, 0, this.getDiameter(), this.getDiameter());
    popMatrix();
  }

  public void applyForce(PVector force) {
    PVector f = PVector.div(force, this.getMass());
    this.acceleration.add(f);
  }

  public void update() {
    this.velocity.add(this.acceleration);
    this.setLocation(this.getLocation().add(velocity));

    this.acceleration.mult(0);
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