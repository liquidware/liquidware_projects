COLOR green = { 0, 255, 0 };
COLOR blue = {0,0,255};
COLOR yellow = {255,255,0};
COLOR BLACK = {0,0,0};
COLOR grey = {0x77,0x77,0x77};
COLOR red = {255,0,0};


unsigned int analogValues[6];
unsigned char digitalValues[10];

LCD_RECT digitalRect = { 118, 15, 127, 115 };
LCD_RECT analogRect = {0, 60, 32, 121 };

unsigned char x;

void setup()
{
  drawBackground();

  Serial.begin(9600);
  delay(3000);

  /* The sync character */
  Serial.print('U');
}


void drawBackground()
{
  lcd_puts("Pin Visualizer", 20, 0, green, BLACK);
  lcd_puts("ADC",0,analogRect.top-13,green, BLACK);
  lcd_puts("Digital",87,120,green, BLACK); 
  lcd_rect(analogRect,grey,BLACK);
  lcd_rect(digitalRect,grey,BLACK);  
  lcd_line(digitalRect.left,digitalRect.bottom-9-(3*10),digitalRect.right, digitalRect.bottom-9-(3*10),grey);
}

void loop()
{

  
  /* Read the analog values */
  for (x=0; x< 6; x++)
    analogValues[x] = (Serial.read() << 8) + Serial.read();
  
  for (x=0; x< 10; x++)
    digitalValues[x] = Serial.read();
  
  /* Redraw the analog values */
  updateAnalog();
  updateDigital();
}



void updateDigital()
{
  unsigned char x;
  char out[6];
  
  green.red = 0;
  green.green = 255;
  
    for(x=0; x<10; x++)
    {
      if (digitalValues[x])
        lcd_puts("H", digitalRect.left+2, digitalRect.bottom-8-(x*10), red, BLACK);
      else   
        lcd_puts("L", digitalRect.left+2, digitalRect.bottom-8-(x*10), green, BLACK);
    }  
}


void updateAnalog()
{
  unsigned char x;
  char out[9];
  float f;
  
  for(x=0; x<6; x++)
    {
     f = ((float)analogValues[x]/1024.0) * 5.0;
    dtostrf(f,4,3,out);
    out[5]=0;
    green.red = analogValues[x]/4;
    green.green = 255-(analogValues[x]/4);
    lcd_puts(out, analogRect.left+2, analogRect.top+3+(x*10), green, BLACK);
 //   green.red=0;
//    green.green=
    }
}
