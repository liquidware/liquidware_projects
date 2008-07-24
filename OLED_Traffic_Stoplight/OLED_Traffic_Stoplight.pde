COLOR red    = {255, 0, 0};
COLOR yellow = {255, 255, 0};
COLOR green  = {0, 255, 0};
COLOR black  = {0, 0, 0};

void setup()
{
  Serial.begin(9600);
  delay(2000);

  /* The sync character */
  Serial.print('U'); 
}


void loop()
{
  
  lcd_circle(110,110,10,green,green);
  arduino_digitalWrite(6,HIGH);
  delay(2000);
  lcd_circle(110,110,10,black,black);
  arduino_digitalWrite(6,LOW);
  
  lcd_circle(110,80,10,yellow, yellow);
  arduino_digitalWrite(5,HIGH);
  delay(3000);
  lcd_circle(110,80,10,black,black);
  arduino_digitalWrite(5,LOW);
    
  lcd_circle(110,50,10,red,red);
  arduino_digitalWrite(4,HIGH);
  delay(2000);
  lcd_circle(110,50,10,black,black);
  arduino_digitalWrite(4,LOW);

}

void arduino_digitalWrite(unsigned char pinNum, unsigned char state)
{
 
 Serial.print(pinNum); 
 delay(1);
 Serial.print(state);
 delay(1);
}



