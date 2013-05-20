import java.awt.Frame;
import controlP5.*;
import codeanticode.syphon.*;

PApplet mainApplet; // needed to toggle loop of the main applet from a ControlFrame
SyphonServer server;
PGraphics canvas;
ControlFrame cf;

Textlabel gostop;
Slider sliderOne;
Slider fpsSlider;
Slider shapeSelection;
Slider opacity;
Button blank;
Button enableServer;
Button eraseRandom;
Button saveAFrame;
Slider strokeOpacity;

int cfW = 480;// dimensions of the 
int cfH = 280;// controlFrame

boolean clean = false;// to clean the background
boolean enableSyphon = false;
boolean changeFps = false;
boolean canErase;
boolean saveThis = false;
color theBackColor;
float maxR, maxG, maxB;
float dim = 10;
float op; // opacity
float strokeOp; // stroke opacity
float fps = 120; //frameRate control value

int shapeSelector=0;
int sldx = 110; //x value for the H sliders
int rgbSliderH = 160; // height of the Vertical sliders

public class ControlFrame extends PApplet {

  int w, h;

  int abc = 100;
  ControlP5 cp5;

  Object parent;


  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }

  private ControlFrame() {
  }

  public ControlP5 control() {
    return cp5;
  }

  public void setup() {
    size(w, h);
    op =  40;
    dim = 100;
    shapeSelector = 0;
    strokeOp = 5;
    maxR = random(255);
    maxG = random(255);
    maxB = random(255);
    theBackColor = color(maxR, maxG, maxB);
    frameRate(18);
    cp5 = new ControlP5(this);

    sliderOne = cp5.addSlider("diameter", 0, 300, sldx, 20, 300, 20);
    sliderOne.setValue(dim);
    //sliderOne.setNumberOfTickMarks(300);

    opacity = cp5.addSlider("Opacity", 0, 255, sldx, 55, 300, 20);
    opacity.setValue(op);

    strokeOpacity = cp5.addSlider("strokeOp", 0, 255, sldx, 90, 300, 20);
    strokeOpacity.setValue(strokeOp);
    //strokOpacity.setWindow(cw);

    shapeSelection = cp5.addSlider("chooseShape", 0, 6, sldx, 150, 300, 20);
    shapeSelection.setValue(shapeSelector);
    shapeSelection.setNumberOfTickMarks(7);

    fpsSlider = cp5.addSlider("frameRateControl", 1, 200, sldx, 120, 300, 20);
    fpsSlider.setValue(fps);
    fpsSlider.setCaptionLabel("FPS");
    // You can change the frameRate only if Syphon is not enabled

    blank = cp5.addButton("toggleBackground", 1, sldx, 190, 90, 25);
    blank.setColorForeground(color(180));
    blank.setColorActive(color(0));
    blank.setCaptionLabel("toggle Background");

    eraseRandom = cp5.addButton("eraseRandom", 1, sldx+100, 190, 80, 25);
    eraseRandom.setColorForeground(color(180));
    eraseRandom.setColorActive(color(0));
    eraseRandom.setCaptionLabel("Click to Erase");

    enableServer = cp5.addButton("enableSyphonServer", 1, sldx+190, 190, 110, 25);
    eraseRandom.setColorForeground(color(180));
    eraseRandom.setColorActive(color(0));
    enableServer.setCaptionLabel("Click enable Syphon");

    saveAFrame = cp5.addButton("saveThisFrame", 1, sldx+190, 220, 110, 25);
    saveAFrame.setCaptionLabel("Click to save");

    Toggle playstop = cp5.addToggle("play", true, 20, 190, 70, 25);
    playstop.setColorActive(color(30, 170, 0));
    playstop.setColorBackground(color(170, 30, 0));
    playstop.setLabelVisible(false);
    gostop = cp5.addTextlabel("stato1", "Playing", 20, 220);
    //gostop.setFont(ControlP5.standard56); // use whatever PFont you like

    Slider sliderR = cp5.addSlider("R", 0, 255, 20, 20, 20, rgbSliderH);
    sliderR.setValue(maxR);
    sliderR.setLabelVisible(false);
    sliderR.setColorForeground(color(255, 0, 0));
    sliderR.setColorActive(color(180, 0, 0));
    sliderR.setColorBackground(color(255));

    Slider sliderG = cp5.addSlider("G", 0, 255, 45, 20, 20, rgbSliderH);
    sliderG.setValue(maxG);
    sliderG.setLabelVisible(false);
    sliderG.setColorForeground(color(0, 255, 0));
    sliderG.setColorBackground(color(255));
    sliderG.setColorActive(color(0, 180, 0));

    Slider sliderB = cp5.addSlider("B", 0, 255, 70, 20, 20, rgbSliderH);
    sliderB.setValue(maxB);
    sliderB.setLabelVisible(false);
    sliderB.setColorForeground(color(0, 0, 255));
    sliderB.setColorBackground(color(255));
    sliderB.setColorActive(color(0, 0, 180));
  }

  void diameter(float theValue) {  
    dim = theValue;
  }

  void frameRateControl(float theValue) {
    // You can change the frameRate only if Syphon is not enabled (see Syphon function below)
    fps = theValue;
    changeFps = true;
  }

  void chooseShape(int theValue) { 
    shapeSelector = floor(theValue);
  }

  void toggleBackground() {
    clean = !clean;
    if (clean) {
      blank.setCaptionLabel("Cleaning BKG");
    }
    else {
      blank.setCaptionLabel("Toggle Background");
    }
  }

  void eraseRandom(int theState) {
    canErase = !canErase;
    if (canErase) {
      eraseRandom.setCaptionLabel("Erasing...");
    }
    else {
      eraseRandom.setCaptionLabel("Click to erase");
    }
  }

  void enableSyphonServer(int s) {
    enableSyphon = !enableSyphon;
    if (enableSyphon) {
      fpsSlider.lock();
      // server.stop();
      server = new SyphonServer(mainApplet, "New Syphon server");
      enableServer.setCaptionLabel("Syphon is enabled");
    }
    else {
      fpsSlider.unlock();
      enableServer.setCaptionLabel("Click enable Syphon");
      // server.stop();
    }
  }

  void saveThisFrame(int s) {
    canvas.save("saved/"+dateTime()+".png");
  }

  void Opacity(float theValue) {
    op = theValue;
  }

  void strokeOp(float theValue) {
    strokeOp = theValue;
  }

  void R(float theValue) {
    maxR = theValue;
    theBackColor = resetColor();
  }

  void G(float theValue) {
    maxG = theValue;
    theBackColor = resetColor();
  }

  void B (float theValue) {
    maxB = theValue;
    theBackColor = resetColor();
  }

  void play(boolean theFlag) {
    if (theFlag) {
      mainApplet.loop();
      gostop.setValueLabel("Playing");
    }
    else {
      mainApplet.noLoop();
      gostop.setValueLabel("Paused");
    }
  }

  public void draw() {
    background(abc);
    strokeWeight(3);
    stroke(0, strokeOp);
    fill(255, op);
    ellipse((float)sldx -10.0, 45, dim, dim);
  }// end draw
}// end class


ControlFrame addControlFrame(String theName) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(mainApplet, cfW, cfH);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

color resetColor() { // used inside the controlFrame to change theBackColor variable
  color toReset = color(maxR, maxG, maxB);
  return toReset;
}

String dateTime() {
  String resultString;
  return resultString = nf(year(), 0)+nf(month(), 2)+nf(day(), 2)+"_"+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2);
}

