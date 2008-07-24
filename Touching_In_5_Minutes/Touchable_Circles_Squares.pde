void setup()
{
 ; 
}

POINT p;
COLOR green = {0,255,0};
COLOR yellow = {255,255,0};
char flip = 0;
void loop()
{
if (touch_get_cursor(&p))
  {
    if (flip)
      {
        flip = 0;
        lcd_circle(p.x,p.y,10,green,green);
      }
    else
      {
        flip = 1;
        lcd_rectangle(p.x-10,p.y-10,p.x+10,p.y+10,yellow,yellow);
      }
  }
  
}
