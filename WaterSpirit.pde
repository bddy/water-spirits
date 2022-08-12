import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

final int FRAGEMENT_SIZE = 2;         // default: 2
final int MIN_THRESHOLD = 600;        // default: 600
final int MAX_THRESHOLD = 1000;       // default: 800
final int Y_FLOW = 2;                 // default: 1
final int Z_FLOW = 4;                 // default: 6
final boolean FULLSCREEN = false;
final String COLOR_MODE = "INVERSE";  // options:  STATIC, LOOP, INVERSE, LOOP_INVERSE

KinectHandler kh;
ColorHandler ch;

void settings() {
  if (FULLSCREEN) {
    fullScreen();
  } else {
    size(640, 480);
  }
}

void setup() {
  colorMode(HSB, 255, 255, 255);
  kh = new KinectHandler(
    new Kinect(this), 
    FRAGEMENT_SIZE, 
    MIN_THRESHOLD, 
    MAX_THRESHOLD, 
    Y_FLOW, 
    Z_FLOW
    );
  ch = new ColorHandler(COLOR_MODE);
}

void draw() {
  background(0);
  // translate(320, 0);
  if (FULLSCREEN) scale(4);
  kh.flow();
  kh.fetchDepthCombine();
  int[] depthState = kh.getDepthState();
  for (int y = 0; y < kh.getYRes(); y++) {
    for (int x = 0; x < kh.getXRes(); x++) {
      // fill(depthState[x+y*kh.getXRes()], depthState[x+y*kh.getXRes()], 255);
      ch.setFill(depthState[x+y*kh.getXRes()]);
      noStroke();
      rect(
        x * FRAGEMENT_SIZE, 
        y * FRAGEMENT_SIZE, 
        FRAGEMENT_SIZE, 
        FRAGEMENT_SIZE
        );
    }
  }
}