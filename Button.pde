class Button {
  boolean isMouseOver;
  boolean isMousePressed;
  color selected;
  color unselected;
  
  Button(color _selected, color _unselected) {
    selected = _selected;
    unselected = _unselected;
    isMouseOver = false;
    isMousePressed = false;
  }
  
  void display() {
    if (isMouseOver) {
      fill(selected);
    } else {
      fill(unselected);
    }
    drawButton();
  }
  
  void drawButton() {
    
  }
  
  boolean isPressed() {
    if (isMouseOver) {
      isMousePressed = true;
      return true;
    }
    return false;
  }
  
  boolean isReleased() {
    isMousePressed = false;
    return false;
  }
}