#include <SPI.h>
#include <LoRa.h>

#define SS 15   // GPIO15 (D8)
#define RST 16  // GPIO16 (D0)
#define DIO0 5  // GPIO5  (D1)

void setup() {
  Serial.begin(9600);
  while (!Serial);

  Serial.println("LoRa Receiver");
  LoRa.setPins(SS, RST, DIO0);
  if (!LoRa.begin(433E6)) { // Match the frequency with the sender (Arduino)
    Serial.println("Starting LoRa failed!");
    while (1);
  }
}

void loop() {
  int packetSize = LoRa.parsePacket();
  
  if (packetSize) {
    
    String receivedData = ""; // Store received LoRa packet
    
    while (LoRa.available()) {
      receivedData += (char)LoRa.read(); // Read data properly
    }

    Serial.println(receivedData); // Print full message after reading
  }
}
