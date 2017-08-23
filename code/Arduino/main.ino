#include <SPI.h>
#include <WiFi101.h>

char ssid[] = "NETGEAR50";      // your network SSID (name)
char pass[] = "joyousflower337";   // your network password
int keyIndex = 0;            // your network key Index number (needed only for WEP)

int status = WL_IDLE_STATUS;
char server[] = "androidlb-1749114721.us-west-2.elb.amazonaws.com";    

WiFiClient client;
String data;
String received;
bool toSend = false;

void setup() {
 
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  // check for the presence of the shield:
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present");
    // don't continue:
    while (true);
  }

  // attempt to connect to Wifi network:
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
    status = WiFi.begin(ssid, pass);

    // wait 10 seconds for connection:
    delay(10000);
  }
  Serial.println("Connected to wifi");
  printWifiStatus();

//  data = "";
}

void loop() {

  if (Serial.available())
  { 
    char c = Serial.read();
    if(c == ',') {
      data += "&";
    }
    else if(c ==';') {
      toSend = true;
    }
    else
      data += c;
  }

  if(toSend) {
    Serial.println(data);
    // Connect to the server (your computer or web page)  
    if (client.connect(server, 80)) {
      client.print("GET /push.php?"); // This      
      client.print(data);
      client.println(" HTTP/1.1"); // Part of the GET request
      client.println("Host: androidlb-1749114721.us-west-2.elb.amazonaws.com"); // IMPORTANT: If you are using XAMPP you will have to find out the IP address of your computer and put it here (it is explained in previous article). If you have a web page, enter its address (ie.Host: "www.yourwebpage.com")
      client.println("Connection: close"); // Part of the GET request telling the server that we are over transmitting the message
      client.println(); // Empty line
      client.println(); // Empty line
      client.stop();    // Closing connection to server
//
      Serial.println("Done");
//
    }
//
    else {
//    // If Arduino can't connect to the server (your computer or web page)
      Serial.println("--> connection failed\n");
    }
    toSend = false;
    data = "";
  }
 
//  // Give the server some time to recieve the data and store it. I used 10 seconds here. Be advised when delaying. If u use a short delay, the server might not capture data because of Arduino transmitting new data too soon.
//  delay(10000);
}


void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}





