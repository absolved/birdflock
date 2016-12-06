class Radio {
  int x, y;
  int outerRadius, innerRadius;
  color outerColor, innerColor;
  int id;
  Radio[] radioGroup;
  boolean isChecked = false;
  
  Radio(int _x, int _y, int _or, color oc, color ic, int _id, Radio[] rg) {
    x = _x;
    y = _y;
    outerRadius = _or;
    innerRadius = outerRadius/2;
    outerColor = oc;
    innerColor = ic;
    id = _id;
    radioGroup = rg;
  }
  
  boolean isPressed(int mx, int my) {
    if (dist(mx, my, x, y) < outerRadius) {
      for (int i = 0; i < radioGroup.length; i++) {
        if (i != id) {
          radioGroup[i].isChecked = false;
        } else {
          radioGroup[i].isChecked = true;
        }
      }
      return true;
    }
    return false;
  }
  
  void display() {
    noStroke();
    fill(outerColor);
    ellipse(x, y, outerRadius*2, outerRadius*2);
    if (isChecked) {
      fill(innerColor);
      ellipse(x, y, innerRadius*2, innerRadius*2);
    }
  }
}