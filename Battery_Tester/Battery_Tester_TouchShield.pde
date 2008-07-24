#include <graph.h>
#include "math.h"
#include "string.h"

unsigned char x,l,h,i;
unsigned int adc;
char out[4];
COLOR blue = {0,0,255}; 
COLOR black = {0,0,0};
float scale = 0.01467;
float result,sum;

barGraph myBar = barGraph("V_plus",10,60,100,30);

void setup()
{
  Serial.begin(9600);
  myBar.setColor(blue);
  myBar.setPrecision(2);
  myBar.setMinMax(0,5);
  myBar.refresh();
}



void loop()
{
  sum = 0;
  adc = 0;
  h = Serial.read();
  delay(1);
  l = Serial.read();
  adc = (h << 8) + l;
  
  result = adc*scale;
  myBar.update(result);
 
}
