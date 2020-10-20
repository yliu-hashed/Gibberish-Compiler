class CGPoint {
  float x;
  float y;
  CGPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
  boolean hasSameValue(CGSize other) {
    return other.x == this.x && other.y == this.y;
  }
}

class CGSize {
  float x;
  float y;
  CGSize(float x, float y) {
    this.x = x;
    this.y = y;
  }
  boolean hasSameValue(CGSize other) {
    return other.x == this.x && other.y == this.y;
  }
}

String intTo8BitBinary(int num) {
  String bi = Integer.toBinaryString(num);
  while (bi.length() < 8) {
    bi = "0" + bi;
  }
  return bi;
}

class FrameRateManager {
  float frameRate = 30;
  float wrampUpCounter = 0;
  float wrampUpFramerate = 0;
  
  void computeFramerate() {
    if (!focused) {
      frameRate = 12;
    } else {
      if (wrampUpCounter > 0) {
        frameRate = wrampUpFramerate;
      } else {
        frameRate = 30;
      }
    }
    
    if (wrampUpCounter > 0) wrampUpCounter -= 1/frameRate;
  }
  
  void wrampUp(float requestedFrameRate) {
    wrampUpFramerate = Math.max(wrampUpFramerate,requestedFrameRate);
    wrampUpCounter = 1;
  }
}
