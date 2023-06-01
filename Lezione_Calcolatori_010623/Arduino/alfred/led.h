#ifndef LED_H
#define LED_H

#include "Arduino.h"
#include "constants.h"

class Led {
  public:
    Led(int pin);
    void init();
    void toogle();
    int getState();
    int getPin();
  private:
    int _pin;
    int _state;
};

void initLeds(Led *);
#endif
