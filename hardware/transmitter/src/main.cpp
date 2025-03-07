#include <ZMPT101B.h>
#include <SPI.h>
#include <LoRa.h>

#define SENSITIVITY 500.0f
#define DEFECT_THRESHOLD_VOLTAGE 12.0 // Voltage threshold for defect
#define DEFECT_PERCENTAGE 0.65        // 65% threshold for previous voltage comparison

ZMPT101B voltageSensorA(A0, 50.0);
ZMPT101B voltageSensorB(A1, 50.0);
ZMPT101B voltageSensorC(A2, 50.0);

float previousVoltageA = 220.0; // Initialize with a realistic starting voltage
float previousVoltageB = 220.0; // Initialize with a realistic starting voltage
float previousVoltageC = 220.0; // Initialize with a realistic starting voltage

bool defectA = false; // To store the defect status for Pole A
bool defectB = false; // To store the defect status for Pole B
bool defectC = false; // To store the defect status for Pole C

bool defectFound = false;

const int ledPinA = 4; // LED for Pole A connected to D4
const int ledPinB = 5; // LED for Pole B connected to D5
const int ledPinC = 6; // LED for Pole C connected to D6

void setup()
{
  Serial.begin(9600);

  pinMode(ledPinA, OUTPUT); // Set LED pin for Pole A
  pinMode(ledPinB, OUTPUT); // Set LED pin for Pole B
  pinMode(ledPinC, OUTPUT); // Set LED pin for Pole C

  voltageSensorA.setSensitivity(SENSITIVITY);
  voltageSensorB.setSensitivity(SENSITIVITY);
  voltageSensorC.setSensitivity(SENSITIVITY);

  while (!Serial)
    ;
  Serial.println("LoRa Sender");

  if (!LoRa.begin(433E6))
  { // Set frequency (433 MHz or 915 MHz based on your module)
    Serial.println("Starting LoRa failed!");
    while (1)
      ;
  }
}

void loop()
{

  if (!defectFound)
  {
    delay(100);
    float voltageA = voltageSensorA.getRmsVoltage();
    delay(335);
    float voltageB = voltageSensorB.getRmsVoltage();
    delay(335);
    float voltageC = voltageSensorC.getRmsVoltage();

    if ((voltageA <= DEFECT_THRESHOLD_VOLTAGE || voltageA <= DEFECT_PERCENTAGE * previousVoltageA) && !defectFound)
    {
      digitalWrite(ledPinA, HIGH); // Turn on LED for Pole A (defect found)
      defectA = true;
      defectFound = true;
    }
    else
    {
      digitalWrite(ledPinA, LOW); // Turn off LED for Pole A (no defect)
    }

    if ((voltageB <= DEFECT_THRESHOLD_VOLTAGE || voltageB <= DEFECT_PERCENTAGE * previousVoltageB) && !defectFound)
    {
      digitalWrite(ledPinB, HIGH); // Turn on LED for Pole B (defect found)
      defectB = true;
      defectFound = true;
    }
    else
    {
      digitalWrite(ledPinB, LOW); // Turn off LED for Pole B (no defect)
    }

    if ((voltageC <= DEFECT_THRESHOLD_VOLTAGE || voltageC <= DEFECT_PERCENTAGE * previousVoltageC) && !defectFound)
    {
      digitalWrite(ledPinC, HIGH); // Turn on LED for Pole C (defect found)
      defectC = true;
      defectFound = true;
    }
    else
    {
      digitalWrite(ledPinC, LOW); // Turn off LED for Pole C (no defect)
    }

    LoRa.beginPacket();
    LoRa.print(voltageA);
    LoRa.print(",");
    LoRa.print(defectA ? "TRUE" : "FALSE");
    LoRa.print(",");
    LoRa.print(voltageB);
    LoRa.print(",");
    LoRa.print(defectB ? "TRUE" : "FALSE");
    LoRa.print(",");
    LoRa.print(voltageC);
    LoRa.print(",");
    LoRa.println(defectC ? "TRUE" : "FALSE");
    LoRa.endPacket();

    // Combine all data in one message, separated by commas
    Serial.print(voltageA);
    Serial.print(",");
    Serial.print(defectA ? "TRUE" : "FALSE");
    Serial.print(",");
    Serial.print(voltageB);
    Serial.print(",");
    Serial.print(defectB ? "TRUE" : "FALSE");
    Serial.print(",");
    Serial.print(voltageC);
    Serial.print(",");
    Serial.println(defectC ? "TRUE" : "FALSE");

    // Update previous voltages
    previousVoltageA = voltageA;
    previousVoltageB = voltageB;
    previousVoltageC = voltageC;
  }

  delay(900); // Wait for 1 second before next reading
}
