COLOR yellow = {255,255,0};
COLOR green  = {0, 255, 0};
COLOR black  = {0,0,0};

POINT p;
LCD_RECT textRect;

void setup()
{
  /* Touch! */
  lcd_puts("Touch ME!",40,40,green, black);
}


void loop()
{
  /* Wait for a touch press */
  while(!touch_get_cursor(&p));

  /* Setup the rectangle */
  textRect.left = p.x;
  textRect.top = p.y;
  textRect.right = textRect.left+35;
  textRect.bottom = textRect.top + 19;

  /* Make sure the text is within the screen bounds */
  if ( (textRect.right < 128) && (textRect.bottom < 128))
   {
     
    /* Draw the rectangle */
    lcd_rect(textRect,yellow, black);
  
    /* Draw the text ontop of the rectangle */
    lcd_puts("Hello", textRect.left+2, textRect.top+2, green, black); 
   lcd_puts("World", textRect.left+2, textRect.top+11, green, black); 
   }
}
