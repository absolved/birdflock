class ButtonRect extends Button {
  int x, y;
  int w, h;
  
  ButtonRect(int _x, int _y, int _w, int _h, color _s, color _us) {
    super(_s, _us);
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  
  void update(int mx, int my) {
    if (mx > x && mx < x+w && my > y && my < y+h) {
      isMouseOver = true;
    } else {
      isMouseOver = false;
    }
  }
  
  void drawButton() {
    rect(x, y, w, h);
  }
}