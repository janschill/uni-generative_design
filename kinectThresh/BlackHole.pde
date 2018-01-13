class BlackHole extends Blob
{
  private float diameter = 0;
  private color col = color(0);
  private PVector location = new PVector(0, 0);
  private float mass = 0;
  private PVector velocity = new PVector(0, 0);
  private PVector acceleration = new PVector(0, 0);
  private boolean attractor = false;

  public BlackHole(float x, float y) {
    super(x, y);
  }

  public void applyForce(PVector force) {
    PVector f = PVector.div(force, this.mass);
    this.acceleration.add(f);
  }

  public PVector attract(BlackHole s) {    
    PVector force = PVector.sub(location, s.location);
    float distance = force.mag();
    //println(distance);
    distance = constrain(distance, 5.0, 25.0);
    //println("constrain: " + distance);
    force.normalize();
    float strength = (Newton.GRAVITY * mass * s.mass) / (distance * distance);
    force.mult(strength);
    return force;
  }

  public PVector repel(BlackHole s) {
    PVector force = PVector.sub(this.location, s.getLocation());
    float distance = force.mag();
    force.normalize();
    distance = constrain(distance, 5, 100);
    float strength = -1 * Newton.GRAVITY / (distance * distance);
    force.mult(strength);
    return force;
  }

  public void update() {
    velocity.add(acceleration);
    location.add(velocity);

    acceleration.mult(0);
  }

  public void show() {
    println("X:"+this.location.x + " Y:" + location.y + " D:" + diameter);
    pushMatrix();
    translate(location.x, location.y);
    fill(col);
    ellipse(0, 0, this.diameter, this.diameter);
    popMatrix();
  }

  public boolean checkCollision(BlackHole s) {
    return sq(s.getLocation().x - this.location.x) + sq(s.getLocation().y - this.location.y) < sq(s.getDiameter()/2 + this.diameter/2);
  }

  public float getDiameter()
  {
    return this.diameter;
  }

  public void setDiameter(float diameter)
  {
    this.diameter = diameter;
  }

  public color getColor()
  {
    return this.col;
  }

  public void setColor(color col)
  {
    this.col = col;
  }

  public PVector getLocation()
  {
    return this.location;
  }

  public void setLocation(PVector location)
  {
    this.location = location;
  }

  public float getMass()
  {
    return this.mass;
  }

  public void setMass(float mass)
  {
    this.mass = mass;
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

  public void setAttractor(boolean attract)
  {
    this.attractor = attract;
  }

  public boolean getAttractor()
  {
    return this.attractor;
  }
}