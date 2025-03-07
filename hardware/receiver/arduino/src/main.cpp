#include <Arduino.h>
#include <Servo.h>

Servo myServo;
const int servoPin = 9;
const int defaultAngle = 180;  // Start at 180°
const int defectAngle = 0;     // Move to 0° when defect detected

void setup() {
  Serial.begin(9600);  // Communication with ESP8266
  myServo.attach(servoPin);
  myServo.write(defaultAngle);  // Set servo to initial position (180°)
}

void loop() {
  if (Serial.available()) {
    String receivedData = Serial.readStringUntil('\n'); // Read full line
    receivedData.trim(); // Remove unwanted spaces

    Serial.print("Received: ");
    Serial.println(receivedData);

    if (receivedData.indexOf("TRUE") != -1) { 
      Serial.println("Defect detected! Moving servo to 0°");
      myServo.write(defectAngle);  // Move to 0°
      delay(1000);  // Stay at 0° for a second
      Serial.println("Returning to 180°");
      myServo.write(defaultAngle); // Return to 180°
    } else {
      Serial.println("No defect detected. Keeping at 180°");
      myServo.write(defaultAngle);
    }
  }
}
