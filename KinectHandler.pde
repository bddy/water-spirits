class KinectHandler {
  private final int X_RES = 640;
  private final int Y_RES = 360;

  private Kinect kinect;
  private int minThreshold, maxThreshold;
  private int skip;
  private int yFlow, zFlow;

  private int[] depthState;

  KinectHandler(
    Kinect kinect, 
    int skip, 
    int minThreshold, 
    int maxThreshold,
    int yFlow,
    int zFlow
    ) {
    this.kinect = kinect;
    this.kinect.initDepth();
    this.kinect.enableMirror(true);
    this.skip = skip;
    this.minThreshold = minThreshold;
    this.maxThreshold = maxThreshold;
    this.yFlow = yFlow;
    this.zFlow = zFlow;
    this.depthState = new int[getYRes() * getXRes()];
  }

  // getters
  public int getXRes() {
    return (X_RES / skip);
  }

  public int getYRes() {
    return (Y_RES / skip);
  }

  public int[] getDepthState() {
    return depthState;
  };

  // calculation
  public void fetchDepth() {
    this.depthState = reduce(kinect.getRawDepth());
  }
  
  public void fetchDepthCombine() {
    int[] newDepthState = reduce(kinect.getRawDepth());
    this.depthState = combine(this.depthState, newDepthState);
  }
  
  public void flow() {
    for (int i = depthState.length - 1; i >= 0; i--) {
      if (i < X_RES * yFlow) {
        depthState[i] = 0;
      } else {
        depthState[i] = depthState[i - X_RES * yFlow] - zFlow;
        if (depthState[i] < 0) depthState[i] = 0;
      }
    }
  }

  // util
  private int[] reduce(int[] depth) {
    int[] filteredDepth = new int[getYRes() * getXRes()];

    for (int y = 0; y < getYRes(); y++) {
      for (int x = 0; x < getXRes(); x++) {
        // get depth value
        int depthValue = depth[(x*skip)+(y*skip)*X_RES];

        // fetch only values for given threshold
        if (depthValue < minThreshold) depthValue = minThreshold;
        if (depthValue > maxThreshold) depthValue = maxThreshold;

        // shift left
        depthValue -= minThreshold;

        // map to consistent 0 - 255 and save
        filteredDepth[x+y*getXRes()] = int(map(depthValue, 0, maxThreshold - minThreshold, 255, 0));
      }
    }

    return filteredDepth;
  }
  
  private int[] combine(int[] oldState, int[] newState) {
    int[] combinedState = new int[getYRes() * getXRes()];
    

    for (int i = 0; i < combinedState.length; i++) {
      combinedState[i] = newState[i] >= oldState[i] ? newState[i] : oldState[i];
    }
    
    return combinedState;
  }
}


/***********************************/
/* https://shiffman.net/p5/kinect/ */
/***********************************/

/*
 initDevice()                start everything (video, depth, IR)
 activateDevice(int)         activate a specific device when multiple devices are connect
 initVideo()                 start video only
 enableIR(boolean)           turn on or off the IR camera image (v1 only)
 initDepth()                 start depth only
 enableColorDepth(boolean)   turn on or off the depth values as color image
 enableMirror(boolean)       mirror the image and depth data (v1 only)
 PImage getVideoImage()      grab the RGB (or IR for v1) video image
 PImage getIrImage()         grab the IR image (v2 only)
 PImage getDepthImage()      grab the depth map image
 PImage getRegisteredImage() grab the registered depth image (v2 only)
 int[] getRawDepth()         grab the raw depth data
 float getTilt()             get the current sensor angle (between 0 and 30 degrees) (v1 only)
 setTilt(float)              adjust the sensor angle (between 0 and 30 degrees) (v1 only)
 */
