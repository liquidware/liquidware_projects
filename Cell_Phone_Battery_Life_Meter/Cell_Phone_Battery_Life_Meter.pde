/* Some colors used */
COLOR RED =   {200,0,0};
COLOR WHITE = {255,255,255};
COLOR BLACK = {0,0,0};

/* Modify this variable to change size of battery life indicator {left,top,right,bottom} */
LCD_RECT battOutline = {110,0,125,9}; 

void setup()
{
  //draw some dummy items
  lcd_line(1, 8, 1, 10, RED); lcd_line(3, 6, 3, 10, RED); lcd_line(5, 4, 5, 10, RED); lcd_line(7, 1, 7, 10, RED);
  lcd_puts("Menu",50,1,WHITE,BLACK);
}

unsigned char val=0;

void loop()
{
  
  /* Pass a value to the battery life indicator 0,1,2,3 */
  /* 0 = Empty, 3 = Full */
  updateBattery(val);
  
  /*Loop through some test values */
  delay(1000); val++; if (val >3) val=0;
}




void updateBattery(unsigned char val)
{
COLOR BLACK = {0,0,0};
COLOR GREEN = {0,200,0};
COLOR WHITE = {255,255,255};
COLOR GREY =  {0x77,0x77,0x77};
COLOR RED =   {200,0,0};

  unsigned char x;

  if (val > 3)
   val = 3;
  
  
  lcd_rect(battOutline,GREY,BLACK);
  lcd_rectangle(battOutline.left-2, battOutline.top+2, battOutline.left, battOutline.bottom-2, GREY, BLACK);
  
  unsigned char barWidth, barHeight, barX, barY;
  barWidth = (((battOutline.right-2) - (battOutline.left+2)) - 4)/3;
  barHeight = battOutline.bottom - (battOutline.top + 4);
  barX = battOutline.right-2-barWidth;
  barY = battOutline.top+2;
 
  if (val==0)
    {
     lcd_line(battOutline.left,battOutline.top+1, battOutline.right, battOutline.bottom-1, RED); 
    }
  
  for(x=0; x<val; x++)
    {
    lcd_rectangle(barX, barY, barX+barWidth, barY+barHeight,GREEN, GREEN);
     barX = barX - barWidth-2;
    }
  
}
