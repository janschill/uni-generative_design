abstract class PhysicalObject {

  private float diameter;
  private color col;
  private PVector location;
  private float mass;


  public PhysicalObject() {
    this.diameter = 0;
    this.col = color(0);
    this.location = new PVector(0, 0);
    this.mass = 0;
  }

  public abstract void show();


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
}
