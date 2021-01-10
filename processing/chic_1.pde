// Variables for the UPD setting
import hypermedia.net.*;
int PORT_RX=5005; 
String HOST_IP="172.20.10.4"; 
String receivedFromUDP = "";
UDP udp;

// Variables for the graphic generation

// variables rings generation
int nRings = 20; // number of rings
ArrayList<Ring> RINGS = new ArrayList<Ring>();

// variables noisy rings
float RAW_DATA = 100;
float SMOOTH_DATA = RAW_DATA;
float t = 0; // time passed
float tChange = .001; // how quick time flies


void setup() {
  // set up udp 
  udp = new UDP(this,PORT_RX,HOST_IP);
  udp.log(false);
  udp.listen(true);
  super.start();
  
  // Graphic generation set-up
  fullScreen();
  
  // generate first ring
  colorMode(HSB, 360, 100, 100);

  float radius= 80; // first ring size
  float noiseAmt = 0.05; // noise quantity, increase to reduce noise 
  float resolution = 10; // shape complexity
  float offset = 0;
  float hue = 171;
  float saturation = 100;
  float brightness = 47.45;

  // generate following rings
  for (int i = 0; i < nRings; i++) {
    RINGS.add(new Ring(radius, noiseAmt, resolution, offset, color(hue, saturation, brightness)));
    radius +=10 + random(40, 90);
    noiseAmt += 0.01;
    resolution += 10;
    offset = random(0.01, 0.06);
    hue = random(160, 200);
    saturation = random(50, 80);
    brightness = random(10, 50);
  }

  noiseDetail(20);
}

void draw() {
  background(#007968);
  translate(width/2, height/2);
  noStroke();

  for (int i = RINGS.size()-1; i >= 0; i--) {
    Ring ring = RINGS.get(i);
    ring.display();
  }

  t += tChange;
}

// This function is called when new data is received from UDP.
// Every time it is called, it will update the image
void receive(byte[] data, String HOST_IP, int PORT_RX) {
  receivedFromUDP = "";
  println(data) ; 
  for (int i = 0; i < data.length; i++) {
      String value = new String(data);
      receivedFromUDP = value;
  }  
  if (receivedFromUDP.equals("end")) {
    finishedReading();        
  } else { 
    float timeTouched = Float.valueOf(receivedFromUDP);
    onData(timeTouched);
  }
}

// This function is called when the sensor is touched ! 
// The function is not called when sensor is not read. 
void onData(float dataValue) {
  println(dataValue);
  // float random = random(1)/50 ;
  // float resize = 600 ;
  RAW_DATA += 30 ;
}

// This function is called when a sensor is not read anymore 
void finishedReading() {
  RAW_DATA = 100 ;
}
