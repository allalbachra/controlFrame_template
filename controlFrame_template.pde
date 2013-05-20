/* 
downloaded via https://github.com/davideoliveri/controlFrame-syphon

A ready-to-use sketch to demonstrate how to build a user interface with the controlP5 library 
to control graphic stuff and send it via Syphon 
davide oliveri 2013 
datamoshp5@gmail.com

download the controlP5library here 
http://www.sojamo.de/libraries/controlP5/

download the Syphon library here 
https://code.google.com/p/syphon-implementations/downloads/list

tested with processing 2.0b8
*/

int cWidth, cHeight; // canvas width and height
float sx, sy, ex, ey, noiseValX = .11, noiseValY = .18;

void setup() {
  canvas = createGraphics(800, 600, JAVA2D);
  cWidth = canvas.width;
  cHeight = canvas.height;
  size(cWidth/2, cHeight/2, P2D); // preview in a small window
  cf = addControlFrame("sample controller"); // start a new PApplet containing GUI
  server = new SyphonServer(this, "New Syphon server");
  mainApplet = this;

  canvas.beginDraw();
  canvas.background(theBackColor); 
  canvas.endDraw();

  sx = random(cWidth);
  sy = random(cHeight);
  ex = random(cWidth);
  ey = random(cHeight);
  loop();
}


void draw() {
  if (changeFps) {
    frameRate(fps);    
    changeFps = false;
  }
  
  canvas.beginDraw();// strat drawing
  
  if (clean) {
    canvas.background(theBackColor);
  }

  canvas.fill(255, op);
  canvas.stroke(0, strokeOp);
  switch(shapeSelector) {
  case 0:
    canvas.ellipse(random(cWidth-10), random(cHeight-10), dim, dim);
    break;
  case 1:
    canvas.rect(random(cWidth-10), random(cHeight-10), dim, dim);
    break;
  case 2:
    canvas.quad(random(cWidth-10), random(cHeight-10), random(cWidth-10), random(cHeight-10), 
    random(cWidth-10), random(cHeight-10), random(cWidth-10), random(cHeight-10)); 
    break;
  case 3:
    canvas.triangle(random(cWidth-10), random(cHeight-10), random(cWidth-10), random(cHeight-10), random(cWidth-10), random(cHeight-10));
    break;
  case 4:
    canvas.stroke(maxR, maxG, maxB, 255*abs(sin(radians(frameCount%360))));
    canvas.line(frameCount%cWidth, 0, frameCount%cWidth, cHeight);
    clean = false; // stop erasing background, linesa are semi transparent most of the time.
    canErase = false;
    break;
  case 5:
    canvas.stroke(maxR, maxG, maxB, strokeOp);
    canvas.line(sx, sy, ex, ey);
    canvas.fill(255, 0, 0);
    // ellipse(sx, sy, 4, 4);
    sx += noise(noiseValX*1.23)*cWidth;
    sy += noise(noiseValY*1.54)*cHeight;
    noiseValX += random(.1, .7);
    noiseValY += random(.2, .83);
    ex += noise(noiseValX*.39)*10;
    ey += noise(noiseValY*.88)*10;
    noiseValX += random(-.7, .7);
    noiseValY += random(.2, .83);
    sx = sx%cWidth;
    sy = sy%cHeight;
    ex = ex%cWidth;
    ey = ey%cHeight;
    break;
  }
  if (canErase) {
    canvas.noStroke();
    canvas.fill(theBackColor);
    switch(shapeSelector) {
    case 0:
      canvas.ellipse(random(cWidth-10), random(cHeight-10), dim, dim);
      break;
    case 1:
      canvas.rect(random(cWidth-10), random(cHeight-10), dim, dim);
      break;
    case 2:
      canvas.quad(random(cWidth-10), random(cHeight-10), random(cWidth-10), random(cHeight-10), 
      random(cWidth-10), random(cHeight-10), random(cWidth-10), random(cHeight-10)); 
      break;
    case 3:
      canvas.triangle(random(cWidth-10), random(cHeight-10), random(cWidth-10), random(cHeight-10), random(cWidth-10), random(cHeight-10));
      break;
    }
  }
  
  removeCache(canvas);
  // here we end drawing in the canvas and send it to the Syphon server
  canvas.endDraw();
  if (enableSyphon) {
    server.sendImage(canvas);
  }
  image(canvas, 0, 0, width, height);
}



