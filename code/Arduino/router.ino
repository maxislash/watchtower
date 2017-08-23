const int id = 1; //Put the id of the sensor board

const int lightPin = 0;
const int tempPin = 1;
float temp = 0;
const int xPin = 2;
const int yPin = 3;
const int zPin = 4;
int alert;
int y;
String data;

//int yMin = 1000;
/:int yMax = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  
  y = analogRead(yPin);
//  if(y < yMin) {
//    yMin=y;
//    Serial.print("ymin: "); Serial.println(yMin);
//  }
//  if(y > yMax) {
//    yMax=y;
//    Serial.print("ymax: "); Serial.println(yMax);
//  }
  //Serial.println(y);
  
  if (y > 450 || y < 310) {
    alert = 1;
    temp = (((((analogRead(tempPin)) * 5.0) / 1024) - 0.5) * 100);
    while(temp < -30) {
      temp = (((((analogRead(tempPin)) * 5.0) / 1024) - 0.5) * 100);
    }
    data = "id=" + String(id) + ",luminosity=" + String(analogRead(lightPin)) + ",temperature=" + String(temp) + ",x=" + String(analogRead(xPin)) + ",y=" + String(y) + ",z=" + String(analogRead(zPin)) + ",alert=" + String(alert) + ";"; 
    Serial.print(data);
    delay(10000);
    alert = 0;
  }
  
}
