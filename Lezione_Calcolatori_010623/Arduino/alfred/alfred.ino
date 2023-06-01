#include <Servo.h>
#include "constants.h"
#include "led.h"

Servo doorServo;  // create servo object to control a servo

Led leds[N_ROOMS] = {Led(LED_ROOM_1_PIN), Led(LED_ROOM_2_PIN), Led(LED_ROOM_3_PIN)};

int ledIndex;

// This code run once
void setup() {
  // Init serial object 
  Serial.begin(BAUD_RATE); 
  delay(1000);  
  
  // attaches the servo on pin 9 to the servo object
  doorServo.attach(DOOR_PIN);  
  doorServo.write(DOOR_OPEN_ANGLE);
  doorServo.write(DOOR_CLOSE_ANGLE);

  //Init leds
  initLeds(leds);


  Serial.println("Ready!");
  helpMessage();
}

void loop() {
  if (Serial.available()) {
    char cmd = Serial.read();
    Serial.print("Received command: ");
    Serial.println(cmd);

    if (isDigit(cmd)){
      Serial.print("Ready to toogle led: ");
      Serial.println(cmd);

      // convert char to int
      ledIndex = cmd - '0';
      if (ledIndex < N_ROOMS){
        leds[ledIndex].toogle();
        //Serial.println(leds[ledIndex].getState());
      }else{
        Serial.println("Invalid room number");
      }

    }else{
      switch (cmd) {
        //open
        case 'o':
          Serial.println("Open");
          doorServo.write(DOOR_OPEN_ANGLE);
        break;
        //close
        case 'c':
          Serial.println("Close");
          doorServo.write(DOOR_CLOSE_ANGLE);
        break;
        default: 
          Serial.println("Invalid Command");
      }
    }
  }
}

void helpMessage(){
  Serial.println("Available commands:");
  Serial.println(" - 'o': open door");
  Serial.println(" - 'c': close door");
  for(int i = 0; i < N_ROOMS; i++ ){
    Serial.print(" - '");
    Serial.print(i);
    Serial.print("': toogle led in room ");
    Serial.println(i);
  }
}