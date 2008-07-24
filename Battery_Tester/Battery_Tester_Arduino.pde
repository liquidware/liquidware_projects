#include <SoftwareSerial.h>

#define rxPin 3
#define txPin 2

SoftwareSerial mySerial =  SoftwareSerial(rxPin, txPin);

void setup()
{
  // define pin modes for tx, rx:
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
  mySerial.begin(9600);
  Serial.begin(9600);
}

unsigned char l,h;
unsigned int adc;

void loop()
{
  adc = analogRead(0);
  l = (unsigned char)adc;
  h = (unsigned char)(adc >> 8);
  
  mySerial.print(h);
  delay(10);
  mySerial.print(l);
  delay(100);
}
