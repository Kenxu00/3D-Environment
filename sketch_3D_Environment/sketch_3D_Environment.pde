import java.awt.Robot;

//colour pallette
color black = #000000;
color white = #FFFFFF;
color brown;
color blue;


//Map variable
int gridSize;
PImage map, diamond, stone;

Robot rbot;
boolean skipFrame;

boolean wkey, akey, skey, dkey;
int y = 0;
float clocX, clocY, clocZ, cdirX, cdirY, cdirZ, ctltX, ctltY, ctltZ;
float tiltLeftRight, tiltUpDown;


void setup() {

  diamond = loadImage("diamond_block_texture.png");
  stone = loadImage("Stone_Bricks.png");


  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  clocX = 50;
  clocY = height - 200;
  clocZ = 0;
  cdirX = 50;
  cdirY = height - 200;
  cdirZ = 10;
  ctltX = 0;
  ctltY = 1;
  ctltZ = 0;
  tiltLeftRight = radians(270);
  noCursor();
  try {
    rbot = new Robot();
  } 
  catch(Exception e) {
    e.printStackTrace();
  }
  skipFrame = false;

  //make map
  map = loadImage("map.png");
  gridSize = 100;
}

void draw() {
  background(0);
  camera (clocX, clocY, clocZ, cdirX, cdirY, cdirZ, ctltX, ctltY, ctltZ);
  pointLight(255, 255, 255, clocX, clocY, clocZ);
  drawFloor(-2000, 2000, height, gridSize);
  drawFloor(-2000, 2000, height - gridSize*5, gridSize);
  drawFocus();
  controlCamera();
  drawMap();
}

void drawFloor(int start, int end, int level, int gap) {
  stroke (0);
  strokeWeight(1);
  for (int x = start; x <= end; x += gap) {
    for (int z = start; z <= end; z+= gap) {
      texturedCube(x, level, z, stone, gap);
    }
  }
}


void drawFocus() {
  pushMatrix();
  translate(cdirX, cdirY, cdirZ);  
  popMatrix();
}

void controlCamera() {

  if (wkey) {
    clocZ += sin(tiltLeftRight) * 10;
    clocX += cos(tiltLeftRight) * 10;
  }
  if (skey) {
    clocZ -= sin(tiltLeftRight) * 10;
    clocX -= cos(tiltLeftRight) * 10;
  }
  if (akey) {
    clocX -= cos(tiltLeftRight + PI/2) * 10;
    clocZ -= sin(tiltLeftRight + PI/2) * 10;
  }
  if (dkey) {
    clocX -= cos(tiltLeftRight - PI/2) * 10;
    clocZ -= sin(tiltLeftRight - PI/2) * 10;
  }

  if (skipFrame == false) {
    tiltLeftRight = tiltLeftRight + (mouseX - pmouseX) * 0.005;
    tiltUpDown = tiltUpDown + (mouseY - pmouseY) * 0.005;
  }

  if (tiltUpDown > PI/2.5) tiltUpDown = PI/2.5;
  if (tiltUpDown < -PI/2.5) tiltUpDown = -PI/2.5;


  cdirX = clocX + cos(tiltLeftRight) * 100;
  cdirY = clocY + tan(tiltUpDown) * 300;
  cdirZ = clocZ + sin(tiltLeftRight) * 100;

  if (mouseX > width - 2) { 
    rbot.mouseMove(2, mouseY);
    skipFrame = true;
  } else if (mouseX < 2) { 
    rbot.mouseMove(width - 2, mouseY);
    skipFrame = true;
  } else skipFrame = false;
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c!= white) {
        texturedCube(x*gridSize - 2000, height - gridSize, y*gridSize -2000, diamond, gridSize);
        texturedCube(x*gridSize - 2000, height - gridSize*2, y*gridSize -2000, diamond, gridSize);
        texturedCube(x*gridSize - 2000, height - gridSize*3, y*gridSize -2000, diamond, gridSize);
        texturedCube(x*gridSize - 2000, height - gridSize*4, y*gridSize -2000, diamond, gridSize);
      }
    }
  }
}

void keyPressed() {

  if (key == 'w' || key == 'W') wkey = true;
  if (key == 's' || key == 'S') skey = true;
  if (key == 'a' || key == 'A') akey = true;
  if (key == 'd' || key == 'D') dkey = true;
}
void keyReleased () {

  if (key == 'w' || key == 'W') wkey = false;
  if (key == 's' || key == 'S') skey = false;
  if (key == 'a' || key == 'A') akey = false;
  if (key == 'd' || key == 'D') dkey = false;
}
