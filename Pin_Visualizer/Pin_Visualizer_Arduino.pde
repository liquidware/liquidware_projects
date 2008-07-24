#include <AFSoftSerial.h>

#define RXPIN 3
#define TXPIN 2

AFSoftSerial mySerial = AFSoftSerial(RXPIN, TXPIN);

unsigned char x=0;

void setup()
{
  mySerial.begin(9600);
  
  /* Sync up by waiting for character */
  while(mySerial.read() != 'U');
}


void loop()
{
  /* The first analog pin sent */
  x=0;
  
  /* send 6 Analog Pin values */
  while (x < 6)
    {
    serial_sendAnalog(x);
    x++;
    }

delay(10);

  x=0;
  while(x< 14)
    {
      serial_sendDigital(x);
      x++;
    }

  delay(100);

}

void serial_sendDigital(unsigned char digitalPin)
{
 
  if ( (digitalPin < 4) || (digitalPin > 13) )
    return;
  
  mySerial.print((unsigned char)digitalRead(digitalPin));
  delay(2);
  
}


void serial_sendAnalog(unsigned char analogPin)
{
  unsigned char lowByte, highByte;
  unsigned int val;
  
  /* Pin number range check */
  if (analogPin > 6)
    return;
  
  /* Get the value */
  val = analogRead(analogPin);
  
  /* Separate the value into 2 bytes */
  lowByte = (unsigned char)val;
  highByte = (unsigned char)(val >> 8);
  
  /* Send the high byte */
  mySerial.print(highByte);
  
  /* Write delay */
  delay(1);
  
  /* Send the low byte */
  mySerial.print(lowByte);
  
  /* Write delay */
  delay(1);
}
