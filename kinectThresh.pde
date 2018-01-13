import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import blobDetection.*;

Kinect2 kinect;
BlackHole star, star2;
ArrayList<BlackHole> starList;
//Iterator<Star> iter = starList.iterator();
//Star[] stars = new Star[2];
color[] cols;
int[] depth;
PImage display;
float min = 600;
float max = 750;

int blackHolesCounter = 0;

int maxLife = 50;

color trackColor; 
float threshold = 40;
float distThreshold = 50;

ArrayList<BlackHole> blackHoles = new ArrayList<BlackHole>();


void setup() {
  size(512, 424, P2D);
  initKinect();
  display = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
  cols = new color[]{color(26, 68, 81), color(185, 65, 65), color(198, 65, 65), color(8, 65, 65)};
  //star = new Star(50, cols[(int) random(0, cols.length)]);
  //print((int) random(0, cols.length));
  //starList = new ArrayList<Star>();
  //star.setMass(20);
  //star.setLocation(new PVector(width/2, height/2));

  trackColor = color(35);


  //  for (int i = 0; i < stars.length; i++) {
  //    stars[i] = new Star(10, cols[(int) random(0, cols.length)]);
  //    stars[i].setMass(5);
  //    stars[i].setLocation(new PVector(50*(i+5), 50));
  //  }
}


void draw() {
  background(0);
  display.loadPixels();

  depth = kinect.getRawDepth();

  ArrayList<BlackHole> currentBlackHoles = new ArrayList<BlackHole>();

  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;

  //  int record = 4500;
  //  int rx = 0;
  //  int ry = 0;

  for (int x = 0; x < kinect.depthWidth; x++) {
    for (int y = 0; y < kinect.depthHeight; y++) {
      int offset = x + y * kinect.depthWidth;
      int de = depth[offset];

      if (de > min && de < max) {
        display.pixels[offset] = (color(35));
        //if ( d < record) {
        //  record = d;
        //  rx = i;
        //  ry = j;
        //}
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
  image(display, 0, 0);

  println(blackHoles.size());
  for (BlackHole s : blackHoles) {
    s.setLocation(s.getCenter());
    s.show();
  } 





  //if (totalPixels > 50) {
  //  float avgX = sumX / totalPixels;
  //  float avgY = sumY / totalPixels;
  //  star.setLocation(new PVector(avgX, avgY));
  //}
  //for (Star s : starList) {
  //  PVector force = star.attract(s);
  //  s.applyForce(force);
  //  s.update();
  //  s.show();
  //if (star.checkCollision(s)) {
  //  starList.remove(s);
  //  return;
  //}
}


//PVector force = star.attract(star2);
//star2.applyForce(force);
//star2.update();
//star2.show();

//PVector force2 = star2.attract(star);
//star.applyForce(force2);

//star.update();
//star.show();
//}


float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
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
  BlackHole s = new BlackHole(15, cols[(int) random(0, cols.length)]);
  s.setMass(15);
  s.setLocation(new PVector(mouseX, mouseY));
  starList.add(s);
}

void initKinect()
{
  kinect = new Kinect2(this);
  //kinect.initVideo();
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