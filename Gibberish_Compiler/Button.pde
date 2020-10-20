class Button extends screenObject {
  String text;
  
  void updateSize() {
    if (CO != null) {
      CO.Position = Position;
      CO.Size = Size;
    }
  }
  
  Button(String text) {
    updateSize();
    if (Position == null) Position = new CGPoint(0.0,0.0);
    if (Position == null) Size = new CGSize(0.0,0.0);
    this.text = text;
    
    CO = new clickableObject(Position, Size);
    zPosition = 1;
  }
  
  void render() {
    super.render();
    
    fill(CO.onHover ? tertiaryBackground : color(255,255,255,0));
    
    noStroke();
    rect(Position.x, Position.y + 2.5, Size.x, Size.y-5, 7);
    
    fill(label);
    text(text, Position.x + (Size.x - textWidth(text))/2, Position.y + (Size.y - fontHeight)/2 + fontHeight - 3);
  }
  
  void onClick(CGPoint position){
    action();
  }
  
  void action() {
  }
}

class Toggle extends screenObject {
  String text;
  
  void updateSize() {
    if (CO != null) {
      CO.Position = Position;
      CO.Size = Size;
    }
  }
  
  Toggle(String text, boolean state) {
    updateSize();
    if (Position == null) Position = new CGPoint(0.0,0.0);
    if (Position == null) Size = new CGSize(0.0,0.0);
    this.state = state;
    this.text = text;
    
    CO = new clickableObject(Position, Size);
    zPosition = 1;
  }
  
  boolean state;
  
  void render() {
    super.render();
    
    if (state == true) {
      fill(CO.onHover ? color(150) : DarkButtonBackground);
    } else {
      fill(CO.onHover ? ButtonBackground : color(255,255,255,0));
    }
    
    noStroke();
    rect(Position.x, Position.y + 2.5, Size.x, Size.y-5, 7);
    
    fill(state ? color(255,255,255) : label);
    text(text, Position.x + (Size.x - textWidth(text))/2, Position.y + (Size.y - fontHeight)/2 + fontHeight - 3);
  }
  
  void onClick(CGPoint position){
    changeTo(!state);
  }
  
  void changeTo(boolean newState) {
    state = newState;
  }
}
