// Machine Code Window

Boolean updateMachineCodeWindow = false; 

public class SecondApplet extends PApplet {

  ArrayList<String> MachineCodeReference = new ArrayList<String>();
  ArrayList<String[]> MachineCode = new ArrayList<String[]>();
  float alignmentOffset = 0;
  
  public void settings() {
    size(300, 800, P2D);
    pixelDensity(2);
    smooth(2);
  }

  public void setup() {
    surface.setResizable(true);
    surface.setTitle("Machine Code");
    frameRate(60);
    
    updateDisplayContent();
  }

  public void draw() {
    surface.setResizable(true);
    background(focused ? color(255,255,255) : titleBarColor);
    textFont(monoFont14, fontSize);
    
    //forward update
    if (updateMachineCodeWindow) {
      updateDisplayContent();
      updateMachineCodeWindow = false;
    }

    //compute spacial y position
    //second window position
    float y = getPosGL(getSurface());
    float windowOffset = positionY - y;
    float textStartOffset = windowOffset + 11 + fontHeight;
    float selectedLinePosition = editor.curserY * fontHeight + fontHeight/2;
    float selectedMachineCodePosition = -1;
    
    //front stuff
    float textOffset = textWidth("000 00") + 20;
    fill(grayBackground);
    noStroke();
    rect(0, -1, textOffset - 9, this.height);
    
    //display
    pushMatrix();
    translate(0, textStartOffset - editor.scrollBar.scrollPosition + alignmentOffset);
    
    fill(seperator);
    noStroke();
    rect(0, -1, this.width, 1);
    
    int mahcineCodeLineCounter = 0;
    for (int i = 0; i < MachineCode.size(); i++) {
      String[] binaries = MachineCode.get(i);
      
      //display selection shape
      if (editor.CO.Clicked && editor.curserY == i) {
        float displayheight = binaries.length == 0 ? 3 : fontHeight * binaries.length;
        noStroke();
        fill(color(230,230,235));
        rect(0, fontHeight * mahcineCodeLineCounter + 3, this.width, displayheight);
        //register position for left-right alignment
        selectedMachineCodePosition = fontHeight * mahcineCodeLineCounter + displayheight/2;
      }
      
      //display lable
      fill(focused ? color(0,0,0) : label);
      for (int d = 0; d < binaries.length; d++) {
        text(binaries[d], textOffset, fontHeight * mahcineCodeLineCounter + fontHeight);
        mahcineCodeLineCounter ++;
      }
    }
    fill(seperator);
    noStroke();
    rect(0, mahcineCodeLineCounter * fontHeight + 6, this.width, 1);
    
    //line indicator
    for (int i = 0; i < mahcineCodeLineCounter; i++) {
      //line number
      fill(secondaryLabel);
      
      String lineHex = Integer.toHexString(i);
      if (lineHex.length() == 1) lineHex = "0"+lineHex;
      
      String lineNumber = Integer.toString(i);
      if (lineNumber.length() == 1) lineNumber = "0"+lineNumber;
      if (lineNumber.length() == 2) lineNumber = "0"+lineNumber;
      
      text(lineHex + " " + lineNumber, 5, fontHeight + i * fontHeight);
    }
    
    popMatrix();
    //alighment
    if (selectedMachineCodePosition != -1) {
      float difference = selectedMachineCodePosition + alignmentOffset - selectedLinePosition;
      if (abs(difference) > 0.1) {
        alignmentOffset += difference * -0.1;
      }
    }
  }

  void updateDisplayContent() {
    MachineCodeReference = compiler.MachineCode;
    MachineCode.clear();
    for (int i = 0; i < MachineCodeReference.size(); i++) {
      String MCodeLine = MachineCodeReference.get(i);
      if (MCodeLine.length() != 0) {
        String[] MCodeSplit = MCodeLine.split(" ");
        MachineCode.add(MCodeSplit);
      } else {
        String[] empty = {};
        MachineCode.add(empty);
      }
    }
  }

  public void exit() {
    surface.stopThread();
    surface.setVisible(false);
    sa = null;
  }
}
