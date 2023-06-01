#include "led.h"

Led::Led(int pin)
{
  _pin = pin;
  _state = LOW;
}

void Led::init(){
  pinMode(_pin, OUTPUT);
  digitalWrite(_pin, LOW);
}

void Led::toogle(){
  if (_state == LOW){
    _state = HIGH;
  }else{
    _state = LOW;
  }
  digitalWrite(_pin, _state);
}

int Led::getPin(){
  return _pin;
}

int Led::getState(){
  return _state;
}

void initLeds(Led *leds){
  for(int i=0; i <= N_ROOMS; i++){
    leds[i].init();
  }
}