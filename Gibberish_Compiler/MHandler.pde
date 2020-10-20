class clickableObject {
  CGPoint Position;
  CGSize Size;
  boolean isActive;
  boolean Clicked = false;
  boolean onHover = false;
  
  clickableObject(CGPoint Position, CGSize Size) {
    this.Position = Position;
    this.Size = Size;
    isActive = true;
  }

  boolean testHit(CGPoint Mpos) {
    if (Position.x < Mpos.x && Mpos.x < Position.x + Size.x && Position.y < Mpos.y && Mpos.y < Position.y + Size.y) {
      return true;
    }
    return false;
  }
  
}

screenObject FocusedObject;
boolean hasFocusedObject = false;

screenObject HoveringObject;
boolean hasHoveringObject = false;

boolean MousePressed = false;

void refreshMouse() {
  if (mousePressed && !MousePressed) {
    MousePressed = true;
    Pressed();
  }
  if (!mousePressed && MousePressed) {
    MousePressed = false;
    Released();
  }
  if (mousePressed && MousePressed) {
    Dragging();
    frameRateManager.wrampUp(60);
    return;
  }
  
  if (!focused) {
    hasHoveringObject = false;
  }
  
  CGPoint Mpos = new CGPoint(float(mouseX), float(mouseY));
  for (screenObject i : objects) {
    //refresh
    if (i.CO.isActive) {
      if (i.CO.testHit(Mpos)) {
        hasHoveringObject = true;
        HoveringObject = i;
        return;
      }
    }
  }
  hasHoveringObject = false;
}

void Pressed() {
  for (screenObject i : objects) {
    i.CO.Clicked = false;
  }
  if (hasHoveringObject) {
    HoveringObject.CO.Clicked = true;
    hasFocusedObject = true;
    FocusedObject = HoveringObject;
  } else {
    hasFocusedObject = false;
  }
  
  if (hasFocusedObject) HoveringObject.onClick(new CGPoint(float(mouseX), float(mouseY)));
}

void Dragging() {
  if (hasFocusedObject && mousePressed) HoveringObject.onDrag(new CGPoint(float(mouseX), float(mouseY)));
}

void Released() {
  if (hasFocusedObject) HoveringObject.onRelease(new CGPoint(float(mouseX), float(mouseY)));
}

void mousePressed() {};

void mouseWheel(MouseEvent event) {
  frameRateManager.wrampUp(60);
  
  float e = event.getCount();
  if (HoveringObject instanceof scrollableObject) {
    scrollableObject obj = (scrollableObject) HoveringObject;
    obj.scroll(e);
  }
}
