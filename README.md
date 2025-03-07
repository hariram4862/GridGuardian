## Team Name: TechTitans
# Automated Fault Detection and Safety System for Overhead Power Grids

## Objective
This project addresses fault detection and automated safety in overhead power grids, particularly during severe weather events and environmental hazards. It provides real-time monitoring and automated fault isolation to reduce power outage risks and enhance public safety.

## Concept and Approach
The system integrates voltage sensors, a bus serial servo-controlled AB switch, and cloud-based monitoring for fault detection in the overhead power grid.

### Key Innovations:
- **Automated AB Switch in Transformers**: Uses a bus serial servo to instantly isolate faulty sections, preventing further damage and reducing downtime.
- **AI-Driven Fault Detection**: Analyzes voltage anomalies and triggers alerts via a mobile app.
- **Real-Time Updates & Control**: Uses ESP8266 to transmit live data to Firebase, allowing linemen to diagnose and restore power remotely.
- **Visual & Digital Indications**: Defective poles are indicated with LEDs, while real-time updates are displayed on an app.

## Impact
- **Faster Fault Identification & Response**: Reduces downtime and operational inefficiencies.
- **Enhanced Safety**: Minimizes electrocution risks during adverse weather conditions.
- **Cost Savings**: Reduces manual inspections and unnecessary maintenance.
- **Scalability**: Can be implemented in urban and rural power grids with minimal modifications.

## Feasibility
### Resources Needed:
- **Hardware**: Arduino, ESP8266, voltage sensors (ZMPT101B), bus serial servo for AB switch automation, power supply, LoRa modules.
- **Infrastructure**: Reliable internet connectivity for cloud-based monitoring and deployment setup for field testing.

### Implementation Plan:
1. **Prototype Development**: Integrate sensors and microcontrollers to collect voltage data.
2. **Automation & Communication**: Implement bus serial servo-controlled AB switch and wireless data transmission via LoRa and Firebase.
3. **Mobile App & AI Integration**: Display real-time data and enable remote fault resolution.
4. **Testing & Validation**: Simulate various fault conditions and ensure system reliability.

## Tech Stack
- **Software**: Arduino IDE, Firebase, FastAPI, Flask, Google Cloud, Flutter, TensorFlow Lite.
- **Communication**: 
  - Serial (Arduino ↔ ESP, Bus Serial Servo ↔ Arduino)
  - Analog (Voltage Sensors ↔ Arduino)
  - LoRa (Arduino ↔ LoRa Transmitter, LoRa Receiver ↔ ESP)
  - Wi-Fi (ESP ↔ Firebase)

## Sustainability
- **Modular & Expandable**: Can be adapted for single- and three-phase overhead power grids with enhanced hardware, including customized PCBs and LoRa communication.
- **Smart Grid Integration**: Future scope includes AI-driven predictive maintenance.
- **Self-Sustaining Model**: Potential for large-scale deployment with government and utility partnerships.

## Differentiation
- **Automated AB Switch with Bus Serial Servo**: Unlike existing solutions that rely on manual intervention, our system isolates faults autonomously.
- **AI-Powered Fault Detection**: Enhances accuracy compared to traditional threshold-based methods.
- **Mobile-Based Monitoring**: Provides real-time fault alerts and allows linemen to update defect resolution.

## Project Structure
```
|-- frontend
|-- hardware
    |-- transmitter
    |-- receiver
        |-- arduino
        |-- esp8266
```
## Contributors

- Hariram V (22MIS1176)
- Anbarasan K (22MIS1173)
- Naresh S (22MIS1175)
- Balaji K (22MIS1198)

