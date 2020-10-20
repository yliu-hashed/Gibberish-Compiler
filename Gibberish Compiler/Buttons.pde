class MenuBar extends screenObject {
  String text = "Compile";
  
  void updateSize() {
    this.Size = new CGSize(screenSize.x, 30.0);
    Position = new CGPoint(0.0,0.0);
    
    if (CO != null) {
      CO.Position = Position;
      CO.Size = Size;
    }
  }
  
  MenuBar() {
    updateSize();
    
    CO = new clickableObject(Position, Size);
    CO.isActive = false;
    zPosition = 0;
  }
  
  void render() {
    super.render();
    
    fill(titleBarColor);
    noStroke();
    rect(0, 0, Size.x, Size.y - 1);
    fill(seperator);
    rect(0, Size.y - 1, Size.x, 1);
  }
}

class NewButton extends Button {
  
  void updateSize() {
    Position = new CGPoint(10.0, 0.0);
    Size = new CGSize(50.0, 30.0);
    super.updateSize();
  }
  
  NewButton() {
    super("New");
  }

  void action() {
    New();
  }
}

class OpenButton extends Button {
  
  void updateSize() {
    Position = new CGPoint(60.0, 0.0);
    Size = new CGSize(50.0, 30.0);
    super.updateSize();
  }
  
  OpenButton() {
    super("Open");
  }

  void action() {
    Open();
  }
}

class SaveButton extends Button {
  
  void updateSize() {
    Position = new CGPoint(110.0, 0.0);
    Size = new CGSize(50.0, 30.0);
    super.updateSize();
  }
  
  SaveButton() {
    super("Save");
  }

  void action() {
    Save();
  }
}

class SecondWindowButton extends Toggle {
  
  void updateSize() {
    Position = new CGPoint(200.0, 0.0);
    Size = new CGSize(150.0, 30.0);
    super.updateSize();
  }
  
  SecondWindowButton() {
    super("Reference Window", false);
  }
  
  void render() {
    state = sa != null;
    super.render();
  }
  
  void changeTo(boolean newState) {
    super.changeTo(newState);
    if (newState == true) {
      startSecondWindow();
    } else {
      endSecondWindow();
    }
  }
}

class AutoCompileButton extends Toggle {
  
  void updateSize() {
    Position = new CGPoint(screenSize.x - 90 - 51, 0.0);
    Size = new CGSize(45.0, 30.0);
    super.updateSize();
  }
  
  AutoCompileButton() {
    super("Auto", true);
  }
  
  void changeTo(boolean newState) {
    super.changeTo(newState);
    editor.autoCompile = newState;
  }
}

class CompileButton extends Button {
  
  void updateSize() {
    Position = new CGPoint(screenSize.x - 90, 0.0);
    Size = new CGSize(80.0, 30.0);
    super.updateSize();
  }
  
  CompileButton() {
    super("Compile");
  }

  void action() {
    editor.compilerCompile();
  }
}
