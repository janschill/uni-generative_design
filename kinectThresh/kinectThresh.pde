import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;

Kinect2 kinect;
BlackHole star, star2;
ArrayList<Star> stars;
color[] cols;
int[] depth;
PImage display;
float min = 600;
float max = 750;
int blackHolesCounter = 0;
int maxLife = 50;
final color trackColor = color(35); 
float threshold = 40;
float distThreshold = 50;
ArrayList<BlackHole> blackHoles = new ArrayList<BlackHole>();

int numOfStars = 150;
int blackHoleMassMax = 50;
int blackHoleMassMin = 25;
int starMassMax = 15;
int starMassMin = 5;

void setup() {
  // 512, 424
  size(2048, 1696, P2D);
  initKinect();
  display = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
  cols = new color[]{color(26, 68, 81), 
    color(185, 65, 65), 
    color(198, 65, 65), 
    color(8, 65, 65), 
    color(220, 20, 60), 
    color(250, 128, 114), 
    color(95, 158, 160), 
    color(106, 90, 205), 
    color(221, 160, 221), 
    color(245, 245, 220), 
    color(255, 228, 225), 
    color(34, 139, 34)};

  stars = new ArrayList<Star>();


  for (int i = 0; i < numOfStars; i++) {
    Star s = new Star();
    s.setDiameter(random(5, 25));
    s.setColor(cols[(int) random(0, cols.length)]);
    s.setMass(random(starMassMin, starMassMax));
    s.setLocation(new PVector(random(0, width), random(0, height)));
    stars.add(s);
  }
}


void draw() {
  background(0);
  display.loadPixels();
  depth = kinect.getRawDepth();

  ArrayList<BlackHole> currentBlackHoles = new ArrayList<BlackHole>();

  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;

  for (int x = 0; x < kinect.depthWidth; x++) {
    for (int y = 0; y < kinect.depthHeight; y++) {
      int offset = x + y * kinect.depthWidth;
      int de = depth[offset];

      if (de > min && de < max) {
        display.pixels[offset] = (color(35));

        sumX += x;
        sumY += y;
        totalPixels++;
      } else {
        display.pixels[offset] = (color(0, 0, 0));
      }

      color currentColor = display.pixels[offset];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold && totalPixels > 250) {

        boolean found = false;
        for (BlackHole s : currentBlackHoles) {
          if (s.isNear(x, y)) {
            s.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          BlackHole s = new BlackHole(x, y);
          s.setColor(cols[(int) random(0, cols.length)]);
          //s.setLocation(s.getCenter());
          s.setDiameter(85);
          s.setMass(random(blackHoleMassMin, blackHoleMassMax));
          currentBlackHoles.add(s);
        }
      }
    }
  }

  for (int i = currentBlackHoles.size()-1; i >= 0; i--) {
    if (currentBlackHoles.get(i).size() < 500) {
      currentBlackHoles.remove(i);
    }
  }

  // There are no stars!
  if (blackHoles.isEmpty() && currentBlackHoles.size() > 0) {
    println("Adding blackHoles!");
    for (BlackHole s : currentBlackHoles) {
      s.id = blackHolesCounter;
      blackHoles.add(s);
      blackHolesCounter++;
    }
  } else if (blackHoles.size() <= currentBlackHoles.size()) {
    // Match whatever blobs you can match
    for (BlackHole s : blackHoles) {
      float recordD = 1000;
      BlackHole matched = null;
      for (BlackHole cb : currentBlackHoles) {
        PVector centerB = s.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !cb.taken) {
          recordD = d; 
          matched = cb;
        }
      }
      matched.taken = true;
      s.become(matched);
    }

    // Whatever is leftover make new blobs
    for (BlackHole s : currentBlackHoles) {
      if (!s.taken) {
        s.id = blackHolesCounter;
        blackHoles.add(s);
        blackHolesCounter++;
      }
    }
  } else if (blackHoles.size() > currentBlackHoles.size()) {
    for (BlackHole s : blackHoles) {
      s.taken = false;
    }

    // Match whatever blobs you can match
    for (BlackHole cb : currentBlackHoles) {
      float recordD = 1000;
      BlackHole matched = null;
      for (BlackHole s : blackHoles) {
        PVector centerB = s.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !s.taken) {
          recordD = d; 
          matched = s;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.lifespan = maxLife;
        matched.become(cb);
      }
    }

    for (int i = blackHoles.size() - 1; i >= 0; i--) {
      BlackHole s = blackHoles.get(i);
      if (!s.taken) {
        if (s.checkLife()) {
          blackHoles.remove(i);
        }
      }
    }
  }

  display.updatePixels();
  pushMatrix();
  translate(width*0.4, height*0.4);
  image(display, 0, 0);


  println(blackHoles.size());
  for (BlackHole s : blackHoles) {
    s.setLocation(s.getCenter());
    s.show();
  } 


  for (Star s : stars) {
    if (blackHoles.size() > 0)
    {
      for (BlackHole b : blackHoles) {
        PVector force;
        if (b.getAttractor()) {
          force = b.attract(s);
        } else {
          force = b.repel(s);
        }
        s.applyForce(force);
        s.update();
        s.show();
        //if (b.checkCollision(s)) {
        //  stars.remove(s);
        //  return;
        //}
      }
    }
    //PVector random = new PVector(random(-0.25, 0.25), random(-0.25, 0.25));
    //s.applyForce(random);
    s.update();
    s.show();
  }
  popMatrix();
}


void keyPressed() {
  if (key == 'a') {
    distThreshold+=5;
  } else if (key == 'z') {
    distThreshold-=5;
  }
  if (key == 's') {
    threshold+=5;
  } else if (key == 'x') {
    threshold-=5;
  }
}

void mouseClicked()
{
  translate(width*0.4, height*0.4);
  Star s = new Star();
  s.setDiameter(15);
  s.setColor(cols[(int) random(0, cols.length)]);
  s.setMass(15);
  s.setLocation(new PVector(mouseX, mouseY));
  stars.add(s);
}

float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void initKinect()
{
  kinect = new Kinect2(this);
  kinect.initDepth();
  kinect.initDevice();
}

// put in update and move mouse around to find optimal threshhold
void threshholdHelper()
{
  min = map(mouseX, 0, width, 0, 2000);
  max = map(mouseY, 0, height, 0, 2000);
  fill(255);
  textSize(32);
  text(min + " " + max, 10, 64);
}