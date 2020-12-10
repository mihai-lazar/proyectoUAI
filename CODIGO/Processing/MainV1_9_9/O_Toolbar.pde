class Toolbar {
  int barX, barY, barW, barH; // X, Y, Width, and Height of Toolbar on Screen
  int contentW, contentH;     // pixel width and height of toolbar content accounting for margin
  int margin;                 // standard internal pixel buffer distance from edge of canvas
  int CONTROL_H = 35;         // standard vertical pixel distance between control elements
  int controlY;               // vertical position where controls begin
  
  String title, credit, explanation;
  ArrayList<ControlSlider> sliders;
  ArrayList<RadioButton> radios;
  ArrayList<Button> buttons;
  
  Toolbar(int barX, int barY, int barW, int barH, int margin) {
    this.barX = barX;
    this.barY = barY;
    this.barW = barW;
    this.barH = barH;
    this.margin = margin;
    contentW = barW - 2*margin;
    contentH = barH - 2*margin;
    sliders  = new ArrayList<ControlSlider>();
    buttons  = new ArrayList<Button>();
    radios  = new ArrayList<RadioButton>();
    controlY = 8*CONTROL_H;
  }
  
  void addSlider(String name, String unit, int valMin, int valMax, float DEFAULT_VALUE, float inc, char keyMinus, char keyPlus, boolean keyCommand) {
    float num = sliders.size() + radios.size() + 2*buttons.size();
    ControlSlider s;
    s = new ControlSlider();
    s.name = name;
    s.unit = unit;
    s.keyPlus = keyPlus;
    s.keyMinus = keyMinus;
    s.keyCommand = keyCommand;
    s.xpos = barX + margin;
    s.ypos = controlY + int(num*CONTROL_H);
    s.len = contentW - margin;
    s.valMin = valMin;
    s.valMax = valMax;
    s.DEFAULT_VALUE = DEFAULT_VALUE;
    s.value = s.DEFAULT_VALUE;
    s.s_increment = inc;
    sliders.add(s);
  }
  
  void addRadio(String name, int col, boolean DEFAULT_VALUE, char keyToggle, boolean keyCommand, int fill) {
    float num = sliders.size() + radios.size() + 2*buttons.size();
    RadioButton b;
    b = new RadioButton();
    b.name = name;
    b.keyToggle = keyToggle;
    b.keyCommand = keyCommand;
    b.xpos = barX + margin;
    b.ypos = controlY + int(num*CONTROL_H);
    b.DEFAULT_VALUE = DEFAULT_VALUE;
    b.value = b.DEFAULT_VALUE;
    b.col = col;
    b.fill = fill;
    radios.add(b);
  }
  
  void addButton(String name, int col, char keyToggle, boolean keyCommand) {
    float num = sliders.size() + radios.size() + 2*buttons.size() - 0.25;
    Button b = new Button();
    b.name = name;
    b.col = col;
    b.keyToggle = keyToggle;
    b.keyCommand = keyCommand;
    b.xpos = barX + margin;
    b.ypos = controlY + int(num*CONTROL_H);
    b.bW = barW - 2*margin;
    b.bH = CONTROL_H;
    buttons.add(b);
  }
  
  void pressed() {
    if (sliders.size()  > 0) for (ControlSlider s: sliders ) s.listen();
    if (radios.size()   > 0) for (RadioButton   b: radios  ) b.listen();
    if (buttons.size()  > 0) for (Button        b: buttons ) b.listen();
  }
  
  void released() {
    if (sliders.size()  > 0) for (ControlSlider s: sliders ) s.isDragged = false;
    if (buttons.size()  > 0) for (Button        b: buttons ) b.released();
  }
  
  void restoreDefault() {
    if (sliders.size()  > 0) for (ControlSlider s: sliders ) s.value = s.DEFAULT_VALUE;
    if (radios.size()   > 0) for (RadioButton   b: radios  ) b.value = b.DEFAULT_VALUE;
  }
  
  // Draw Margin Elements
  //
  void draw() {
    pushMatrix();
    translate(barX, barY);
    
    // Shadow
    pushMatrix(); translate(3, 3);
    noStroke();
    fill(0, 100);
    rect(0, 0, barW, barH, margin);
    popMatrix();
    
    // Canvas
    fill(255, 20);
    noStroke();
    rect(0, 0, barW, barH, margin);
    
    // Canvas Content
    translate(margin, margin);
    textAlign(LEFT, TOP);
    fill(255);
    text(title + credit + explanation, 0, 0, contentW, contentH);
    popMatrix();
    
    // Sliders
    for (ControlSlider s: sliders) {
      s.update();
      s.drawMe();
    }
    
    // Buttons
    for (RadioButton b: radios) b.drawMe();
    for (Button b: buttons)     b.drawMe();
    
    // TriSliders
  }
  
  boolean hover() {
    if (mouseX > barX && mouseX < barX + barW && 
        mouseY > barY && mouseY < barY + barH) {
      return true;
    } else {
      return false;
    }
  }
}

class ControlSlider {
  String name;
  String unit;
  int xpos;
  int ypos;
  int len;
  int diameter;
  char keyMinus;
  char keyPlus;
  boolean keyCommand;
  boolean isDragged;
  int valMin;
  int valMax;
  float value;
  float DEFAULT_VALUE = 0;
  float s_increment;
  int col;
  
  ControlSlider() {
    xpos = 0;
    ypos = 0;
    len = 200;
    diameter = 15;
    keyMinus = '-';
    keyPlus = '+';
    keyCommand = true;
    isDragged = false;
    valMin = 0;
    valMax = 0;
    value = 0;
    s_increment = 1;
    col = 255;
  }
  
  void update() {
    if (isDragged) value = (mouseX-xpos)*(valMax-valMin)/len+valMin;
    checkLimit();
    if (value % s_increment < s_increment/2) {
      value = s_increment*int(value/s_increment);
    } else {
      value = s_increment*(1+int(value/s_increment));
    }
  }
  
  void listen() {
    if(mousePressed && hover() ) {
      isDragged = true;
    }
    
    //Keyboard Controls
    if (keyCommand) {
      if ((keyPressed == true) && (key == keyMinus)) {value--;}
      if ((keyPressed == true) && (key == keyPlus))  {value++;}
      checkLimit();
    }
  }
  
  void checkLimit() {
    if(value < valMin) value = valMin;
    if(value > valMax) value = valMax;
  }
  
  boolean hover() {
    if( mouseY > (ypos-diameter/2) && mouseY < (ypos+diameter/2) && 
        mouseX > (xpos-diameter/2) && mouseX < (xpos+len+diameter/2) ) {
      return true;
    } else {
      return false;
    }
  }
  
  void drawMe() {

    // Slider Info
    strokeWeight(1);
    fill(255);
    textAlign(LEFT, BOTTOM);
    String txt = "";
    if (keyCommand) txt += "[" + keyMinus + "," + keyPlus + "] ";
    txt += name;
    text(txt, int(xpos), int(ypos-0.75*diameter) );
    textAlign(LEFT, CENTER);
    text(int(value) + " " + unit,int(xpos+6+len), int(ypos-1) );
    
    // Slider Bar
    fill(100); noStroke();
    rect(xpos,ypos-0.15*diameter,len,0.3*diameter,0.3*diameter);
    // Bar Indentation
    fill(50);
    rect(xpos+3,ypos-1,len-6,0.15*diameter,0.15*diameter);
    // Bar Positive Fill
    fill(150);
    rect(xpos+3,ypos-1,0.5*diameter+(len-1.0*diameter)*(value-valMin)/(valMax-valMin),0.15*diameter,0.15*diameter);
    
    // Slider Circle
    noStroke();
    fill(col, 225);
    if ( hover() ) fill(col, 255);
    ellipse(xpos+0.5*diameter+(len-1.0*diameter)*(value-valMin)/(valMax-valMin),ypos,diameter,diameter);
  }
}

class Button {
  String name;
  int col;
  int xpos;
  int ypos;
  int bW, bH, bevel;
  char keyToggle;
  boolean keyCommand;
  int valMin;
  int valMax;
  boolean trigger;
  boolean pressed;
  boolean enabled;
  
  Button() {
    xpos = 0;
    ypos = 0;
    bW = 100;
    bH = 25;
    keyToggle = ' ';
    keyCommand = true;
    trigger = false;
    pressed = false;
    enabled = true;
    col = 200;
    bevel = 25;
  }
  
  void listen() {
    
    // Mouse Controls
    if( mousePressed && hover() && enabled) {
      pressed = true;
    }
    
    // Keyboard Controls
    if(keyCommand) if ((keyPressed == true) && (key == keyToggle)) {pressed = true;}
  }
  
  void released() {
    if (pressed && enabled) {
      trigger = true;
      pressed = false;
    }
  }
  
  boolean hover() {
    if( mouseY > ypos && mouseY < ypos + bH && 
        mouseX > xpos && mouseX < xpos + bW ) {
      return true;
    } else {
      return false;
    }
  }
  
  void drawMe() {
    
    int shift = 0;
    if (pressed) shift = 3;
    
    // Button Shadow
    //
    fill(50); noStroke();
    rect(xpos+3,ypos+3, bW, bH, bevel);
    
    // Button
    //
    stroke(255, 100); strokeWeight(3);
    if (enabled) {
      int alpha = 200;
      if ( hover() || pressed) alpha = 255;
      fill(col, alpha);
      rect(xpos+shift,ypos+shift, bW, bH, bevel);
    }
    strokeWeight(1);
    
    // Button Info
    //
    textAlign(CENTER, CENTER); fill(255);
    String label = "";
    if (keyCommand) label += "[" + keyToggle + "] ";
    label += name;
    text(label,int(xpos + 0.5*bW)+shift,int(ypos + 0.5*bH)+shift );
  }
}

class RadioButton {
  String name;
  int col;
  int xpos;
  int ypos;
  int diameter;
  char keyToggle;
  boolean keyCommand;
  int valMin;
  int valMax;
  int fill;
  boolean value;
  boolean DEFAULT_VALUE;
  
  RadioButton() {
    xpos = 0;
    ypos = 0;
    diameter = 20;
    keyToggle = ' ';
    keyCommand = true;
    value = false;
    col = 200;
  }
  
  void listen() {
    
    // Mouse Controls
    if( mousePressed && hover() ) {
      if (bar_left.radios.size()   > 0) for (RadioButton   b: bar_left.radios  ) b.value = b.DEFAULT_VALUE;
      value = !value;
      global_fill = this.fill;
    }
    
    // Keyboard Controls
    if (keyCommand) if ((keyPressed == true) && (key == keyToggle)) {value = !value;}
  }
  
  boolean hover() {
    if( mouseY > ypos-diameter && mouseY < ypos && 
        mouseX > xpos          && mouseX < xpos+diameter ) {
      return true;
    } else {
      return false;
    }
  }
  
  void drawMe() {
    
    pushMatrix(); translate(0, -0.5*diameter, 0);
    
    // Button Info
    strokeWeight(1);
    if (value) { fill(255); }
    else       { fill(150); } 
    textAlign(LEFT, CENTER);
    String label = "";
    if (keyCommand) label += "[" + keyToggle + "] ";
    label += name;
    text(label,int(xpos + 1.5*diameter),int(ypos) );
    
    // Button Holder
    noStroke(); fill(50);
    ellipse(xpos+0.5*diameter+1,ypos+1,diameter,diameter);
    fill(100);
    ellipse(xpos+0.5*diameter,ypos,diameter,diameter);
    
    // Button Circle
    noStroke();
    int alpha = 200;
    if ( hover() ) alpha = 255;
    if (value) { fill(col, alpha); } 
    else       { fill( 0 , alpha); } 
    ellipse(xpos+0.5*diameter,ypos,0.7*diameter,0.7*diameter);
    
    popMatrix();
  }
}
