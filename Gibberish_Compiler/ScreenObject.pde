class screenObject implements Comparable<screenObject> {
  CGPoint Position;
  CGSize Size;
  clickableObject CO;
  
  int zPosition = -1;
  
  void render() {
    textFont(monoFont14, fontSize);
    
    if (CO.isActive == true) {
      if (hasHoveringObject) {
        CO.onHover = this == HoveringObject;
      } else {
        CO.onHover = false;
      }
      if (hasFocusedObject) {
        CO.Clicked = this == FocusedObject;
      } else {
        CO.Clicked = false;
      }
    } else {
      CO.Clicked = false;
      CO.onHover = false;
    }
  }
  
  void updateSize() {
  }
  
  void onClick(CGPoint position) {
    
  }
  
  void onDrag(CGPoint position) {
    
  }
  
  void onRelease(CGPoint position) {
    
  }
  
  @Override int compareTo(screenObject other) {          
    return this.zPosition - other.zPosition;
  }
  
}
