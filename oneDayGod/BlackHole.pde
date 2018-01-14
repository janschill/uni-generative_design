class BlackHole extends Blob
{
  public BlackHole(float x, float y) {
    super(x, y);
  }

  public PVector attract(Star s) {    
    PVector force = PVector.sub(this.getLocation(), s.getLocation());
    float distance = force.mag();
    //println(distance);
    distance = constrain(distance, 5.0, 25.0);
    //println("constrain: " + distance);
    force.normalize();
    float strength = (Newton.GRAVITY * this.getMass() * s.getMass()) / (distance * distance);
    force.mult(strength);
    return force;
  }

  public PVector repel(Star s) {
    PVector force = PVector.sub(this.getLocation(), s.getLocation());
    float distance = force.mag();
    force.normalize();
    distance = constrain(distance, 5, 100);
    float strength = -1 * 250 / (distance * distance);
    force.mult(strength);
    return force;
  }

  public void show() {
    println("X:"+this.getLocation().x + " Y:" + getLocation().y + " D:" + getDiameter());
    pushMatrix();
    translate(getLocation().x, getLocation().y);
    fill(this.getColor());
    ellipse(0, 0, this.getDiameter(), this.getDiameter());
    popMatrix();
  }

  public boolean checkCollision(Star s) {
    return sq(s.getLocation().x - this.getLocation().x) + sq(s.getLocation().y - this.getLocation().y) < sq(s.getDiameter()/2 + this.getDiameter()/2);
  }

}