


////////////////////////////////////////////////////////////////////////// INCLUDE ALL OF THIS ////////////////////////////////////////////////////////////////
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;  // Fermata setup
ArdWidgetCollection myWidgets = new ArdWidgetCollection();

// Some basic declarations, don't change these
static int INPUT = 0;
static int OUTPUT = 1;
static boolean CONNECTED = true; // to test without a connected arduino. To connect to an arduino make sure CONNECTED = true;
static int X = 0;
static int Y = 1;

// Some default behaviors, these MUST be defined, but can be overwritten on individual ArdWidgets. You can change these here:
color ArdDefaultLowColor = color(128,128,128);
color ArdDefaultHighColor = color(0,255,0);
color ArdDefaultINPUTBackgroundColor = color(210,210,210);
color ArdDefaultOUTPUTBackgroundColor = color(255,255,255);
boolean ArdDefaultDisplayname = true;
boolean ArdDefaultDisplayvalue = true;
boolean ArdDefaultDisplayscale = false;
////////////////////////////////////////////////////////////////////////// END INCLUDE  ////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////// SETUP / DRAW / EVENTS  ////////////////////////////////////////////////////////////////
// You need all of these functions but can add into / moidify them 

void setup() 
{
  println(Arduino.list());
  size(500, 500);
  //println("Arduino list: ", Arduino.list());
    
 // if (CONNECTED) {

  //if(Arduino.list()[0].getClass().equals(String.class)) println("True!"); else println("False :(");
  if(Arduino.list().length > 0) {
    println("Arduino Connected!"); 
      println(Arduino.list());
        arduino = new Arduino(this, Arduino.list()[2], 57600);
  }

    else {
    println("Arduino NOT Connected: OUTPUT Widgets will function, INPUT widgets won't do anything"); 
    CONNECTED = false;
    }
  /////////////////////////////// Add Some Widgets //////////////////////////////
  // Now add widgets to the ArdWidgetCollection. Basic signature is ( int x, int y, int w, int h, int anio, int apin):
  
  // Make an INPUT Button on Pin 2
  // Single line of code creates a new button Widget and adds to the collection.
 


  // Define an appropriate Widget variable in order to keep the reference and then change things, like its colors and display text:
  // Make an OUTPUT Button on Pin 8  
  ArdWidgetButton button1 = new ArdWidgetButton  (25, 25, 100, 100, OUTPUT, 2);
  button1.lowcolor = color(255,0,0);   // set lowcolor to red
  button1.highcolor = color(0,255,0);  // set highcolor to green
  myWidgets.add(button1); 
  
  
  ArdWidgetButton button2 = new ArdWidgetButton (150, 25, 100, 100, OUTPUT, 3);
  button2.lowcolor = color(255,0,0);   // set lowcolor to red
  button2.highcolor = color(0,255,0);  // set highcolor to green
  myWidgets.add(button2); 
  
  ArdWidgetButton button3 = new ArdWidgetButton (25, 150, 100, 100, OUTPUT, 4);
  button3.lowcolor = color(255,0,0);   // set lowcolor to red
  button3.highcolor = color(0,255,0);  // set highcolor to green
  myWidgets.add(button3); 
  
  ArdWidgetButton button4 = new ArdWidgetButton (150, 150, 100, 100, OUTPUT, 5);
  button4.lowcolor = color(255,0,0);   // set lowcolor to red
  button4.highcolor = color(0,255,0);  // set highcolor to green
  myWidgets.add(button4); 

  //Make an INPUT Horizontal Slider on Pin 0
  ArdWidgetHSlider slider3 = new ArdWidgetHSlider (50, 150, 90, 40, INPUT, 0);
  slider3.highcolor = color(0,0,255); 
  slider3.displayscale = true; // add the scale text (show lowval and highval)
  //myWidgets.add(slider3);

  //Make an OUTPUT Vertical Slider on Pin ~9
  // an INPUT widget's backround is grey by default; mouse interactions don't do anything
  ArdWidgetVSlider slider1 = new ArdWidgetVSlider(150, 50, 40, 140, OUTPUT, 9);
  slider1.lowcolor = color(255,0,0); // if lowcolor and highcolor are different, sliders will blend between them.
  slider1.highcolor = color(0,0,255); 
  slider1.displayname = false;  // Don't show the pin name
  //myWidgets.add(slider1);
  

  // Note the ArdWidgetXY takes an array of 2 pins!
  ArdWidgetXY xy1 = new ArdWidgetXY (220, 50, 140, 140, OUTPUT, new int [] {10,11}); // Note how we pass the array of (2) pins
  xy1.highcolor = color(0,0,255); 
  xy1.displayscale = true;
  xy1.lowval[Y] = 0; xy1.highval[Y] = 64; // We can set the range to something other than the default 255 OUTPUT / 2013 INPUT
 // myWidgets.add(xy1);

  // The ArdWidgetGraph - includes a dynamically created set of sliders and a time graph
  // Note we provide an array of ios and pins. The count of ios doesn't need to be the same as the pins
   ArdDefaultDisplayscale = true;
  // myWidgets.add(new ArdWidgetGraph(50, 250, 310, 150, new int[] {OUTPUT, INPUT}, new int [] {3,2,5}));  
   ArdDefaultDisplayscale = false;
    
  /////////////////////////////////// Done Adding Widgets ////////////////////////////
  
}

void draw() { 
  background(204);
  
 /* (myWidgets.widgets[0]).widgets[1].state = (myWidgets.widgets[0]).widgets[0].state;
    myWidgets.widgets[1].widgets[1].state = myWidgets.widgets[1].widgets[0].state;
  */
  myWidgets.update(); // This is the only line you need in draw. You can add your other code here.
  delay(100);        // We need a short delay to allow Analog reads to be processed.
} 

void mouseClicked() {
  myWidgets.mouseClicked();
}

void mouseDragged() {
  myWidgets.mouseDragged();
}

////////////////////////////////////////////////////////////////////////// ArdWidget CLASSES ////////////////////////////////////////////////////////////////
// STOP! If you're a basic user you shouldn't need to change anything below here, unless you want to customize widgets or create your own.
// If you're interested in learning, take a look at how ArdWidgetCollection, the abstract ArdWidget class, and the ArdWidgetButton class interact
// The ArdWidgetXY and ArdWidgetGraph are more complicated



////////////////////////////////////////////////////////////////////////// ArdWidgetCollection ////////////////////////////////////////////////////////////////
// The ArdWidgetCollection class collects ArdWidgets and routes events to them

class ArdWidgetCollection {

    ArdWidget widgets[];
    int count;
    
    ArdWidgetCollection() {
      widgets  = new ArdWidget[20]; // WARNNING code will fail with more than 20 widgets; bump up if desired
      count = 0;
    };
    
    void add(ArdWidget aWidget) {
      //println(count);
      widgets[count] = aWidget;
      count = count + 1;
    };
    
    void update() {
      for (int i = 0; i < count ; i++) { widgets[i].update(); }
    };
    
   void mouseClicked() {
      for (int i = 0; i < count ; i++) { widgets[i].mouseClicked(); }
    };

   void mouseDragged() {
      for (int i = 0; i < count ; i++) { widgets[i].mouseDragged(); }
    };

}


////////////////////////////////////////////////////////////////////////// ArdWidget ////////////////////////////////////////////////////////////////
// This is the ArdWidget abstract base class - it doesn't do much, most of the behavior is overwritten in subclasses

class ArdWidget { 
  // All widgets have these parameters:
  int awx, awy, aww, awh;
  int io;
  int state;
  int pin;
  color lowcolor, highcolor, bgcolor;
  boolean displayname, displayvalue, displayscale;
  
  ArdWidget () {};
 
  
  ArdWidget ( int x, int y, int w, int h, int anio, int apin) {   
    ardSetup( x, y, w, h, anio,  apin);
  }
  
  // basic setup - used by all ArdWidgets during initialization
  void ardSetup  ( int x, int y, int w, int h, int anio, int apin)  { // just the basics: set internal variables
    awx = x; awy = y; aww = w; awh = h; 
    displayname = ArdDefaultDisplayname;
    displayvalue = ArdDefaultDisplayvalue;
    displayscale = ArdDefaultDisplayscale;
    io = anio;
    pin = apin;
   // if (io == INPUT) arduino.pinMode(pin, Arduino.INPUT); else arduino.pinMode(pin, Arduino.OUTPUT);
    state = 0;
    lowcolor = ArdDefaultLowColor; highcolor = ArdDefaultHighColor;
    if (io == OUTPUT) {bgcolor = ArdDefaultOUTPUTBackgroundColor; lowcolor = ArdDefaultOUTPUTBackgroundColor;} else bgcolor = ArdDefaultINPUTBackgroundColor;
  }

  void update() {
      } // default: do nothing
  
  void drawText() {
    // Display text if flags are set
    
    int ty = -10;
    fill(0);
     

  if (displayvalue) {
     ty += 10;
     textAlign(CENTER,TOP);
     text(str(state), awx + aww / 2, awy + awh + ty);
     
  };

    if (displayname) {
      ty += 10;
      fill(0);
      String iostring;
      if (io == INPUT) iostring = "I-"; else iostring = "O-";
     String namestring =  iostring + str(pin);
     textAlign(CENTER,TOP);
     text(namestring, awx + aww / 2, awy + awh + ty);
  }

    
  }
  
  void mouseClicked() {  }

  void mouseDragged() {  }

} 

////////////////////////////////////////////////////////////////////////// ArdWidgetButton ////////////////////////////////////////////////////////////////

class ArdWidgetButton extends ArdWidget { 
  
  ArdWidgetButton () {};
 
  
  ArdWidgetButton ( int x, int y, int w, int h, int anio, int apin) {  
    ardSetup( x, y, w, h, anio,  apin);
    
    // check the input pins to make sure they are in range
    if (apin < 0 || apin > 13) {
      println("SETUP ERROR: OUTPUT ArdWidgetButton: pin number out of range: ", apin);
      return;
    }
    
    if (CONNECTED) {
      if (io == INPUT) arduino.pinMode(pin, Arduino.INPUT); else arduino.pinMode(pin, Arduino.OUTPUT);
    }
   } 
   
  void update() { 
    if (CONNECTED && io == INPUT) {
    state = arduino.digitalRead(pin);
    //println("Widget pin INPUT:", pin, state);
    }
    
    if (CONNECTED && io == OUTPUT) {
    //println("writing: ", pin, state);
    arduino.digitalWrite(pin, state);
    //println("Widget pin OUTPUT:", pin, state);
    }
    
    if (state== 0) fill(lowcolor); else fill(highcolor);
    rect(awx, awy, aww, awh); 
    drawText();
  } 
  
  void mouseClicked() { 
    if (io == INPUT) return; // only checking click for OUTPUT buttons ?????
    if (mouseX < awx || mouseX > awx+aww || mouseY <awy || mouseY > awy + awh) return;
    if (state == 0) state = 1; else state = 0;
    // println("Widget clicked INPUT:", pin, state);
  } 
} 

////////////////////////////////////////////////////////////////////////// ArdWidgetSlider ////////////////////////////////////////////////////////////////

class ArdWidgetSlider extends ArdWidget {

  int lowval, highval;
  float proportion;
  int sliderCenter;
  
  ArdWidgetSlider (){};
  
  ArdWidgetSlider ( int x, int y, int w, int h, int anio, int apin) { 
    setupSlider( x, y, w, h, anio, apin);
  }
  
   void setupSlider ( int x, int y, int w, int h, int anio, int apin) { 
    ardSetup ( x, y, w, h, anio, apin);
    checkAnalogPins();
    
    if (CONNECTED) {
      if (io == OUTPUT) arduino.pinMode(pin, Arduino.OUTPUT); //else arduino.pinMode(pin, Arduino.OUTPUT);
    }
    lowval = 0;
    if (io == INPUT) highval = 1023; else highval = 255;
    
    state = lowval; 
    proportion = 0;
    
  }
     
  
  void update() { 
    if (io == INPUT) {
      if (CONNECTED) state = arduino.analogRead(pin);
       //println("Widget ANALOG INPUT:", pin, state);
    }
    
    if (CONNECTED && io == OUTPUT) {
    arduino.analogWrite(pin, state);
    }
    
   
    // now draw the background, center line, and button
    fill(bgcolor);
    rect(awx, awy, aww, awh); 
    drawText();
    drawSlider();
      
  }
   
  
  
  void mouseClicked() { processMouseEvent();}
  
  void mouseDragged() { processMouseEvent();}
  
  // Some helper functions
  
  void processMouseEvent() {  } // Defered to Vertical and Horizontal subclasses
  
  void drawSlider() { }         // Defered to Vertical and Horizontal subclasses

  
  color proportionColor() {  // This blends the lowcolor and highcolor proportionally 
    return color(red(highcolor) * proportion + red(lowcolor) * (1.0 - proportion),
                 green(highcolor) * proportion + green(lowcolor) * (1.0 - proportion),
                 blue(highcolor) * proportion + blue(lowcolor) * (1.0 - proportion));
  }
  
  boolean checkAnalogPins() {
     if (io == INPUT && (pin < 0 || pin > 6)) {
       println("ERROR on INPUT ArdWidgetSlider: pin is out of Analog INPUT pin range (A0-A5): ",pin);
       return false;
     }
     
     if (io == OUTPUT && !(pin == 3 || pin == 5 || pin == 6 || pin == 9 || pin == 10 || pin == 11 )) {
       // This would need to be changed for the Arduino Mega
       println("WARNING on OUTPUT ArdWidgetSlider: pin is not an analog OUTPUT (~3,~5,~6,~9,~10,~11): ",pin);
       return false;
     }
     return true;
  }
      
   
}

//////////////  ArdWidgetVSlider - Vertical Slider //////////////////////

class ArdWidgetVSlider extends ArdWidgetSlider {
  
    ArdWidgetVSlider( int x, int y, int w, int h, int anio, int apin) { 
      setupSlider( x, y, w, h, anio, apin);
    }
  
    void drawSlider() {
      if (io == INPUT) proportion = (float)state / (float)highval;
      line(awx + aww/2, awy, awx + aww/2, awy + awh);
    
      int buttonheight = awh / 10;
      if (buttonheight < 5) buttonheight = 5;
    
      sliderCenter = (int) (awh * (1 - proportion)); 
      fill(proportionColor());
      rect(awx, awy + sliderCenter - buttonheight / 2, aww, buttonheight); 
    } 
  
   void processMouseEvent() {   // Same behavior for click and drag
      if (io == INPUT ) {
        //proportion = 1 - (float)(state / highval);
        return; // only checking click for OUTPUT
      }
      if (mouseX < awx || mouseX > awx+aww || mouseY <awy || mouseY > awy + awh) return;

      proportion = 1 - ((float)(mouseY - awy) / (float)awh);
    
      state = lowval + (int) (proportion * (highval - lowval));
      //println("state: ", state);
    }
  
  void drawText() {
    // Display text if flags are set
    
    int ty = -10;
    fill(0);

    String displaystring;
    
    if (displayscale) {
     textAlign(CENTER,BOTTOM);
     text(str(highval), awx + aww / 2, awy);
     ty += 10;
     textAlign(CENTER,TOP);
     text(str(lowval), awx + aww / 2, awy + awh + ty);
     
    };

  if (displayvalue) {
     ty += 10;
     textAlign(CENTER,TOP);
     text(str(state), awx + aww / 2, awy + awh + ty);
     
    };

    if (displayname) {
      ty += 10;
      fill(0);
      String iostring;
      if (io == INPUT) iostring = "I-"; else iostring = "O-";
     String namestring =  iostring + str(pin);
     textAlign(CENTER,TOP);
     text(namestring, awx + aww / 2, awy + awh + ty);
    }
    
  }

}

//////////////  ArdWidgetHSlider - Horizontal Slider //////////////////////

class ArdWidgetHSlider extends ArdWidgetSlider {
  
    ArdWidgetHSlider( int x, int y, int w, int h, int anio, int apin) { 
      setupSlider( x, y, w, h, anio, apin);
    }
  
   void drawSlider() {
    if (io == INPUT) proportion = (float)state / (float)highval;
     
    line(awx, awy + awh / 2, awx + aww, awy + awh / 2);
    
    int buttonwidth = aww / 10;
    if (buttonwidth < 5) buttonwidth = 5;
    
    sliderCenter = (int) (aww * (proportion));   
    
    fill(proportionColor());
    rect(awx + sliderCenter - buttonwidth / 2, awy, buttonwidth, awh); 
 
  } 
  
  void drawText() {
    // Display text if flags are set
    
    int ty = 0;
    fill(0);
    
    if (displayscale) {
     textAlign(LEFT,TOP);
     text(str(lowval), awx, awy + awh + ty);
     textAlign(RIGHT,TOP);
     text(str(highval), awx + aww, awy + awh + ty);
     
    };

  if (displayvalue) {
     //ty += 10;
     textAlign(CENTER,TOP);
     text(str(state), awx + aww / 2, awy + awh + ty);
     
    };

    if (displayname) {
      ty += 10;
      fill(0);
      String iostring;
      if (io == INPUT) iostring = "I-"; else iostring = "O-";
     String namestring =  iostring + str(pin);
     textAlign(CENTER,TOP);
     text(namestring, awx + aww / 2, awy + awh + ty);
    }
    
  }
  
   void processMouseEvent() {   // Same behavior for click and drag
      if (io == INPUT ) {
        return; // only checking click for OUTPUT
      }
      //println("processMouseEvent", mouseX, mouseY, awx, awy, aww, awh);
      if (mouseX < awx || mouseX > awx+aww || mouseY <awy || mouseY > awy + awh) return;

      proportion = ((float)(mouseX - awx) / (float)aww);
      state = lowval + (int) (proportion * (highval - lowval));
      //println("state: ", state);
  
}
}


////////////////////////////////////////////////////////////////////////// ArdWidgetXY ////////////////////////////////////////////////////////////////

class ArdWidgetXY extends ArdWidget {

  int [] lowval = new int[2];
  int [] highval = new int[2];
  float [] proportion = new float[2];
  int [] sliderCenter = new int[2];
  int [] pins = new int[2];
  int state[] = new int[2];

  ArdWidgetXY ( int x, int y, int w, int h, int anio, int [] inpins) { 
    ardSetup ( x, y, w, h, anio, pin);
    pins[X] = inpins[0];
    pins[Y] = inpins[1];
    checkAnalogPins();
    

    if (CONNECTED) {
      if (io == OUTPUT) {
        arduino.pinMode(pins[X], Arduino.OUTPUT); arduino.pinMode(pins[Y], Arduino.OUTPUT);
      }
    }
    lowval[X] = lowval[Y] = 0;
    if (io == INPUT) highval[X] = highval[Y] = 1023; else highval[X] = highval[Y] = 255;
    
    state[X] = (lowval[X] + highval[X]) / 2;
    state[Y] = (lowval[Y] + highval[Y]) / 2;

    sliderCenter[X] = aww / 2;
    sliderCenter[Y] = awh / 2;
    
  }
     
  
  void update() { 
    //println("XY update");
    if (io == INPUT) {
      if (CONNECTED) {
        state[X] = arduino.analogRead(pins[X]);
        state[Y] = arduino.analogRead(pins[Y]);
      }
      
      // println("Widget ANALOG INPUT:", pin, state);
      proportion[X] = (float)(state[X] - lowval[X]) / (float)(highval[X] - lowval[X]); if (proportion[X] < 0) proportion[X] = 0; if (proportion[X] > 1) proportion[X] = 1;
      proportion[Y] = (float)(state[Y] - lowval[Y]) / (float)(highval[Y] - lowval[Y]); if (proportion[Y] < 0) proportion[Y] = 0; if (proportion[Y] > 1) proportion[Y] = 1;
      sliderCenter[X] = (int) (aww * (proportion[X]));
      sliderCenter[Y] = (int) (awh * (1 - proportion[Y]));
    }
    
    if (CONNECTED && io == OUTPUT) { // INPUT?!?
    arduino.analogWrite(pins[X], state[X]);
    arduino.analogWrite(pins[Y], state[Y]);
    
    }

    // now draw the background, center line, and button
    fill(bgcolor);
    rect(awx, awy, aww, awh); 
    
    int buttonheight = awh / 10;    
    int buttonwidth = aww / 10;
    
    int buttonsize;
    if (buttonwidth < buttonheight) buttonsize = buttonwidth; else buttonsize = buttonheight; 
    if (buttonsize < 5) buttonsize = 5;
    
    // draw a cross
    stroke(highcolor);
    //rect(awx + sliderCenter[X] - buttonsize / 2, awy + sliderCenter[Y] - buttonsize / 2, buttonsize, buttonsize); 
    line(  awx + sliderCenter[X] - buttonsize / 2, awy + sliderCenter[Y], 
           awx + sliderCenter[X] + buttonsize / 2, awy + sliderCenter[Y]); 

    line(  awx + sliderCenter[X], awy + sliderCenter[Y] - buttonsize / 2, 
           awx + sliderCenter[X], awy + sliderCenter[Y] + buttonsize / 2); 

    // Display text if flags are set
    stroke(0);
    int ty = 0;
    fill(0);

    String displaystring;
    
    if (displayscale) {
     textAlign(LEFT,TOP);
     text(str(lowval[X]), awx, awy + awh + ty);
     textAlign(RIGHT,TOP);
     text(str(highval[X]), awx + aww, awy + awh + ty);
     
    };

  if (displayvalue) {
     //ty += 10;
     textAlign(CENTER,TOP);
     text(str(state[X]), awx + aww / 2, awy + awh + ty);
     //text(str(state[X]), awx + sliderCenter[X], awy + awh + ty);
     
    };

    if (displayname) {
      ty += 10;
      fill(0);
      String iostring;
      if (io == INPUT) iostring = "I-"; else iostring = "O-";
     String namestring =  iostring + str(pins[X]);
     textAlign(CENTER,TOP);
     text(namestring, awx + aww / 2, awy + awh + ty);
    }
    

    
    int tx = 0;   
    if (displayscale) {
     textAlign(RIGHT,BOTTOM);
     text(str(lowval[Y]), awx, awy + awh);
     textAlign(RIGHT,TOP);
     text(str(highval[Y]), awx, awy);
     //tx += 10;
     
    };

  if (displayvalue) {
     //ty += 10;
     textAlign(RIGHT,CENTER);
     text(str(state[Y]), awx, awy + awh / 2);
     tx +=10;
     //text(str(state[X]), awx + sliderCenter[X], awy + awh + ty);
     
    };

    if (displayname) {
      //ty += 10;
      //fill(0);
      String iostring;
      if (io == INPUT) iostring = "I-"; else iostring = "O-";
     String namestring =  iostring + str(pins[Y]);
     textAlign(RIGHT,CENTER);
     //text(str(state[X]), awx, awy + awh / 2);
     text(namestring, awx, awy + awh / 2 + tx);
    }
    
 
 
 
  } 
  
  void mouseClicked() { processMouseEvent();}
  
  void mouseDragged() { processMouseEvent();}
      
  void processMouseEvent() {   // Same behavior for click and drag
     

    if (io == INPUT ) return; // only checking click for OUTPUT
    if (mouseX < awx || mouseX > awx+aww || mouseY <awy || mouseY > awy + awh) {
      return;
    }
    
    //println("Mouse Event: ", mouseX, mouseY);
    
    proportion[X] = ((float)(mouseX - awx) / (float)awx);
    state[X] = lowval[X] + (int)((highval[X] - lowval[X]) * proportion[X]);
    sliderCenter[X] = mouseX - awx;
    state[X] = lowval[X] + (int) (proportion[X] * (highval[X] - lowval[X]));

    proportion[Y] = 1 - ((float)(mouseY - awy) / (float)awh);
    state[Y] = lowval[Y] + (int)((highval[Y] - lowval[Y]) * proportion[Y]);
    sliderCenter[Y] = mouseY - awy;
    state[Y] = lowval[Y] + (int) (proportion[Y] * (highval[Y] - lowval[Y]));

}

 boolean checkAnalogPins() {
   int apin;
   for (int i = 0; i < 2; i++) {
     apin = pins[i];
     if (io == INPUT && (apin < 0 || apin > 5)) {
       println("ERROR on INPUT ArdWidgetSlider: pin is out of Analog INPUT pin range (A0-A5): ",apin);
       return false;
     }
     
     if (io == OUTPUT && !(apin == 3 || apin == 5 || apin == 6 || apin == 9 || apin == 10 || apin == 11 )) {
       // This would need to be changed for the Arduino Mega
       println("WARNING on OUTPUT ArdWidgetSlider: pin is not an analog OUTPUT (~3,~5,~6,~9,~10,~11): ",pin);
       return false;
     }
   }
     return true;
  }
   
}
 
 ////////////////////////////////////////////////////////////////////////// ArdWidgetGraph ////////////////////////////////////////////////////////////////
 
 int[] graphColors = {color(255,0,0), color(0,255,0), color(0,0,255), color(255,255,0), color(0,255,255)};

class ArdWidgetGraph extends ArdWidget {
    ArdWidgetCollection sliders;
    int varcount;
    int graphvals[][];
    int graphw;
    int graphx;

    int pixstep = 5; 
    int timestep = 1;
    int timecheck = 0; 
    int pixsteps;

  ArdWidgetGraph ( int x, int y, int w, int h, int [] io, int [] pins) { 
    awx = x; awy = y; aww = w; awh = h; 
    
    sliders = new ArdWidgetCollection();
    varcount = pins.length;
        
    // do some math to lay out the sliders
    int sliderHWRatio = 8;
    int gapw = 2;
    int sliderw = awh / sliderHWRatio;
    int sliderareaw = (varcount * (sliderw + gapw));
    graphw = aww - sliderareaw;
    graphx = awx + sliderareaw;
    int currentsliderx = awx;
    
    // setup and add the sliders
    for (int i = 0 ; i < pins.length; i++) {
      int io1 = io[i % io.length];
      //println("Adding slider: ", i, io1, pins[i]);
    
      ArdWidgetVSlider slider = new ArdWidgetVSlider(currentsliderx, awy, sliderw, awh, io1, pins[i]); // Use this if you want to keep the reference to change anything, like colors 
      slider.lowcolor = slider.highcolor = graphColors[i % graphColors.length]; 
      //slider.displayname = slider.displayvalue = true;
      //slider.displayscale = false;
      sliders.add(slider); 
      currentsliderx = currentsliderx + sliderw + gapw;
    }
    
    // setup the graph and values
    // pixstep = 20; 
    //int millisstep = 3;
    pixsteps = graphw / pixstep;
    graphvals = new int[varcount][pixsteps];
    
    for (int i = 0; i < varcount; i++ ) {
        for (int j = 0 ; j < pixsteps; j++ ) {
          graphvals[i][j] = awh;
        }
    }
    
}
     
  
  void update() { 
    stroke(0);
    sliders.update();
    
    // now draw the background, center line, and button
    fill(color(255,255,255));
    rect(graphx, awy, graphw, awh); 
    
    timecheck = timecheck + 1;
    if (timecheck == timestep) {
      timecheck = 0;
    for (int i = 0; i < varcount; i++ ) {
        for (int j = pixsteps - 1 ; j > 0; j-- ) {
          graphvals[i][j] = graphvals[i][j-1];
        }
        graphvals[i][0] = ((ArdWidgetSlider)sliders.widgets[i]).sliderCenter;
        //println("sliderCenter: ",graphvals[i][0]);
    }
    }
    
    for (int i = 0; i < varcount; i++ ) {
      color color1 = sliders.widgets[i].highcolor;
      stroke(color1);
      for (int j = 0; j < pixsteps - 1; j++ ) {
          //println("vals: ", graphvals[i][j], graphvals[i][j+1]);
          line(    graphx + (j * pixstep),       graphvals[i][j] + awy, 
                   graphx + (j + 1) * pixstep, graphvals[i][j+1] + awy);
        }
    }
    stroke(0);

 
  } 
  
  void mouseClicked() { sliders.mouseClicked();}
  
  void mouseDragged() { sliders.mouseDragged();}
      

   
}
 
 
 ////////////////////////////////////////////////////////////////////////// ArdWidgetVSliderArray ////////////////////////////////////////////////////////////////
 
class ArdWidgetArray extends ArdWidget {
    ArdWidgetCollection widgets;
    int varcount;
    int graphw;
    int graphx;

    int pixstep = 5; 
    
    ArdWidgetArray() {};

  ArdWidgetArray ( int x, int y, int w, int h, int [] io, int [] pins, int [] layout) { 
   setup(x, y, w, h, io, pins, layout); 
  }
  void setup(int x, int y, int w, int h, int [] io, int [] pins, int [] layout) {
    awx = x; awy = y; aww = w; awh = h; 
    
    widgets = new ArdWidgetCollection();
    varcount = pins.length;

        
    // do some math to lay out the sliders
    float gapXRatio = 0.25;
    float gapYRatio = 0.6;
    float xCount;
    if (layout[X] == 1) xCount = 1; else xCount = (float)layout[X] + ((float)layout[X] - 1) * gapXRatio;
    //println("X: aww, xCount: ", aww, xCount);
    int widWidth = (int) ((float)aww / xCount);
    int gapWidth = (int) ((float)widWidth * gapXRatio);
    //println("X: widWidth, gapWidth: ", widWidth, gapWidth);
    
    float yCount;
    if (layout[Y] == 1) yCount = 1; else yCount = (float)layout[Y] + ((float)layout[Y] - 1) * gapYRatio;
    //println("Y: awh, yCount: ", awh, yCount);
    int widHeight = (int) ((float)awh / yCount);
    int gapHeight = (int) ((float)widHeight * gapYRatio);
    //println("Y: widHieght, gapHeight: ", widHeight, gapHeight);    
      
    int ix = awx, jy = awy, wcount = 0;
    // setup and add the sliders
    for (int i = 0 ; i < layout[Y]; i++) {
      ix = awx;
      for (int j = 0; j < layout[X]; j++) {
        if (wcount < pins.length) {
          int io1 = io[wcount % io.length];
          //println("Adding slider: ", i, io1, pins[i]);
          addWidget(ix, jy, widWidth, widHeight, io1, pins[wcount]);
          //ArdWidgetVSlider slider = new ArdWidgetVSlider(ix, jy, widWidth, widHeight, io1, pins[wcount]); // Use this if you want to keep the reference to change anything, like colors 
          //sliders.add(slider); 
        }
        wcount = wcount +1;
        ix += (widWidth + gapWidth);

        }
        jy += (widHeight + gapHeight);
      
      }        
  }
     
  void addWidget(int x, int y, int w, int h, int io, int pin) {       
       }
  
  void update() { 
    //rect(awx, awy, aww, awh);
    widgets.update();

  } 
  
  void mouseClicked() { widgets.mouseClicked();}
  
  void mouseDragged() { widgets.mouseDragged();}
}

class ArdWidgetButtonArray extends ArdWidgetArray {
  
   ArdWidgetButtonArray ( int x, int y, int w, int h, int [] io, int [] pins, int [] layout) { 
   setup(x, y, w, h, io, pins, layout); 
  }
  
  void addWidget(int x, int y, int w, int h, int io, int pin) {   
      ArdWidgetButton widget = new ArdWidgetButton(x, y, w, h, io, pin);
       widgets.add(widget); 
       }
  
}

class ArdWidgetVSliderArray extends ArdWidgetArray {
  
   ArdWidgetVSliderArray ( int x, int y, int w, int h, int [] io, int [] pins, int [] layout) { 
   setup(x, y, w, h, io, pins, layout); 
  }
  
  void addWidget(int x, int y, int w, int h, int io, int pin) {   
      ArdWidgetVSlider widget = new ArdWidgetVSlider(x, y, w, h, io, pin);
      widgets.add(widget); 
       }
  
}

class ArdWidgetHSliderArray extends ArdWidgetArray {
  
   ArdWidgetHSliderArray ( int x, int y, int w, int h, int [] io, int [] pins, int [] layout) { 
   setup(x, y, w, h, io, pins, layout); 
  }
  
  void addWidget(int x, int y, int w, int h, int io, int pin) {   
      ArdWidgetHSlider widget = new ArdWidgetHSlider(x, y, w, h, io, pin);
      widgets.add(widget); 
       }
  
}
 
