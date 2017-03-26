ArrayList <Tap> taps;
ArrayList <HitPoint> hitPoints;

//PShape psTap;
//PShape tapOutter;
//PShape tapInner;

float centreX, centreY;
float tapDefSpeed = 10;

float mainRingOutterR;
float mainRingInnerR;
int ringThick = 50;

float tapOutterR;
float tapInnerR;
float tapPointR = 3;
int tapThick = 20;

float hitPointOutterR = 40;
float hitPointInnerR = 5;

color bgColor = #5C5D5D;
color ringColor = #FBFF39;
color tapColor = #FA5BB3;
color tapPointColor = #FA5BB3;
color hitPointOutterColor = #86FFF8;
color hitPointInnerColor = #F5FF76;

//for debug vvvvvv
byte count = 1;


void setup() {
  fullScreen();
  //size(1200,800);
  orientation(LANDSCAPE);
  noStroke();
  ellipseMode(RADIUS);
  shapeMode(CORNER);

  taps = new ArrayList();
  hitPoints = new ArrayList();

  initSizeValue();

  //psTap = createShape();
  //initAllShape();
  initHitPoints();
}

void draw() {
  background(bgColor);
  drawMainRing();
  moveAll();
  displayAll();
}

void initSizeValue() {
  println("initializing sizes");
  centreX = displayWidth/2;
  centreY = displayHeight/2;

  mainRingOutterR = min(displayWidth /20 *10, displayWidth /20 *10) /2;
  mainRingInnerR = mainRingOutterR - ringThick;

  tapOutterR = min(displayWidth /20 *1.5, displayWidth /20 *1.5) /2;
  tapInnerR = tapOutterR - tapThick;
}

//void initAllShape() {
  //println("initializing shapes");
  //tapOutter = createShape(ELLIPSE, 0, 0, tapOutterR*2, tapOutterR*2);
  //tapOutter.setFill(tapColor);
  //tapInner = createShape(ELLIPSE, 0, 0, tapInnerR*2, tapInnerR*2);
  //tapInner.setFill(bgColor);
  //psTap.addChild(tapOutter);
  //psTap.addChild(tapInner);
  //psTap.setFill(tapColor);
//}

void drawMainRing() {
  //ellipseMode(CENTER);
  fill(ringColor);
  ellipse(displayWidth/2, displayHeight/2, mainRingOutterR, mainRingOutterR);
  fill(bgColor);
  ellipse(displayWidth/2, displayHeight/2, mainRingInnerR, mainRingInnerR);
  
  for(byte i = 0; i<= hitPoints.size()-1; i++){
    fill(hitPointOutterColor);
    ellipse(hitPoints.get(i).x, hitPoints.get(i).y, hitPointOutterR, hitPointOutterR);
    fill(hitPointInnerColor);
    ellipse(hitPoints.get(i).x, hitPoints.get(i).y, hitPointInnerR, hitPointInnerR);
  }
}

void initHitPoints() {
  println("initializing hitPoints");
  for (byte i = 1; i<= 8; i++) {
    float x, y;
    float alpha = 0;
    int xDirection = 1;
    int yDirection = 1;
    switch(i) {   
    case 1:
    case 4:
    case 5:
    case 8:
      alpha = 22.5;
      break;
    case 2:
    case 3:
    case 6:
    case 7:
      alpha = 67.5;
      break;
    }
    switch(i) {    
    case 5:
    case 6:
      xDirection = -1;
      break;
    case 1:
    case 2:
      yDirection = -1;
      break;
    case 7:
    case 8:
      xDirection = -1;
      yDirection = -1;
    }
    x = centreX + xDirection * (mainRingOutterR - ringThick /2) * sin(radians(alpha));
    y = centreY + yDirection * (mainRingOutterR - ringThick /2) * cos(radians(alpha));
    //println(i + ": " + x + ", " + y);
    HitPoint temp = new HitPoint(x, y);
    hitPoints.add(temp);
  }
}

class HitPoint {
  float x, y;
  HitPoint(float tx, float ty) {
    x = tx;
    y = ty;
  }
}

class Tap {
  float x, y;
  float speed;
  byte pos;
  boolean visible;
  boolean yLong = false;
  boolean xLong = false;
  byte xDirection = 1;
  byte yDirection = 1;

  Tap(float tx, float ty, float ts, byte tp, boolean tv) {
    x = tx;
    y = ty;
    speed = ts;
    pos = tp;
    visible = tv;

    switch(pos) {    
    case 1:
    case 4:
    case 5:
    case 8:
      yLong = true;
      break;
    case 2:
    case 3:
    case 6:
    case 7:
      xLong = true;
      break;
    }

    switch(pos) {    
    case 5:
    case 6:
      xDirection = -1;
      break;
    case 1:
    case 2:
      yDirection = -1;
      break;
    case 7:
    case 8:
      xDirection = -1;
      yDirection = -1;
    }
  }

  void move() {
    float xs = 0;
    float ys = 0;
    if (xLong) {
      xs = xDirection * speed * sin(radians(67.5));
      ys = yDirection * speed * cos(radians(67.5));
    } else if (yLong) {
      xs = xDirection * speed * sin(radians(22.5));
      ys = yDirection * speed * cos(radians(22.5));
    }
    x += xs;
    y += ys;
  }

  void display() {
    //shape(psTap, x, y);
    //shape(tapOutter, x, y);
    //shape(tapInner, x,y);
    fill(tapColor);
    ellipse(x, y, tapOutterR, tapOutterR);
    fill(bgColor);
    ellipse(x, y, tapInnerR, tapInnerR);
    fill(tapPointColor);
    ellipse(x, y, tapPointR, tapPointR);
  }
}

void moveAll() {
  for (Tap temp : taps) {
    temp.move();
  }
}

void displayAll() {
  for (Tap temp : taps) {
    temp.display();
  }
}


void mousePressed() {
  Tap temp = new Tap(centreX, centreY, tapDefSpeed, count, true);
  taps.add(temp);
  count++;
  if (count > 8) {
    count = 1;
  }
}