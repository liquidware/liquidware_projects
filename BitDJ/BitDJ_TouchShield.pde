COLOR blue =  {40, 153, 224};

COLOR red = {255, 0, 0};

COLOR black = {0, 0, 0};

COLOR white = {255, 255, 255};

COLOR gray = {200, 200, 200};

COLOR orange = {255, 153, 0};

COLOR green = {102, 153, 0};

COLOR dimred = {201, 84, 84};

POINT my_point;

#define POINT_UP 1

#define POINT_DOWN 2

#define POINT_LEFT 3

#define POINT_RIGHT 4

unsigned char brightness;

short fader;

//Define the master buttons data queue

#define MAX_BUTTONS 35

typedef struct button {

  int active, pressed, enabled;

  int x, y, w, h;

  COLOR fill, outline, pressfill, pressoutline, textc, presstextc;

  int alias;

  char* text;

  void (*func) ();

} button;

button myButtons[MAX_BUTTONS];

//int buttons[MAX_BUTTONS];

//Define calibration data

#define CALIBRATE_POINTS 3

#define CALIBRATE_DIV 43

#define CALIBRATE_OFF 20

typedef struct calibrate {

  int zonex[CALIBRATE_POINTS][CALIBRATE_POINTS];

  int zoney[CALIBRATE_POINTS][CALIBRATE_POINTS];

} calibrate;

calibrate myCal;

char myDefault[] = "Default";

void doNothing( void) {

  Serial.print("Do nothing");

}

void buttonStatus( int num, int stat) {

  myButtons[num].enabled = stat;

  myButtons[num].active = stat;

  myButtons[num].pressed = 0;

}

void buttonFullStatus( int num, int enable, int active, int pressed) {

  myButtons[num].enabled = enable;

  myButtons[num].active = active;

  myButtons[num].pressed = pressed;

}

void clearButtons ( void) {

  for (int i = 0; i < MAX_BUTTONS; i++) {

    buttonStatus( i, 0);

  }

}

void setupButtons( void) {

  for (int i = 0; i < MAX_BUTTONS; i++) {

  myButtons[i].x = 10;

  myButtons[i].y = 10;

  myButtons[i].w = 10;

  myButtons[i].h = 10;

  myButtons[i].fill = white;

  myButtons[i].outline = white;

  myButtons[i].pressfill = white;

  myButtons[i].pressoutline = white;

  myButtons[i].textc = white;

  myButtons[i].presstextc = white;

  myButtons[i].func = doNothing;

  myButtons[i].text = myDefault;

  myButtons[i].enabled = 0;

  myButtons[i].active = 0;

  myButtons[i].pressed = 0;

  }

}

void MakeButton ( int i, int x, int y, int w, int h, COLOR fill, COLOR outline, COLOR pressfill, COLOR pressoutline, COLOR textc, COLOR presstextc, char *text, void (*func) ()) {

 

  myButtons[i].x = x;

  myButtons[i].y = y;

  myButtons[i].w = w;

  myButtons[i].h = h;

  myButtons[i].fill = fill;

  myButtons[i].outline = outline;

  myButtons[i].pressfill = pressfill;

  myButtons[i].pressoutline = pressoutline;

  myButtons[i].textc = textc;

  myButtons[i].presstextc = presstextc;

  myButtons[i].func = func;

  myButtons[i].text = text;

  myButtons[i].enabled = 0;

  myButtons[i].active = 1;

  myButtons[i].pressed = 0;

 

}

void ActButtons ( int x, int y) {

  int i;

  //Serial.print("x: ");Serial.print(x);

  //Serial.print("y: ");Serial.print(y);Serial.println();

 

  for (int j = 0; j < MAX_BUTTONS; j++) {

    if ( (myButtons[j].enabled) && (myButtons[j].active) && (myButtons[j].x < x) && (x < (myButtons[j].x+myButtons[j].w) ) && (myButtons[j].y < y) &&

    (y < (myButtons[j].y+myButtons[j].h) )) {

      i = j;

      myButtons[i].pressed = !myButtons[i].pressed;

      if (myButtons[i].pressed) {

        drawButton( myButtons[i].x, myButtons[i].y, myButtons[i].w, myButtons[i].h, myButtons[i].text, myButtons[i].pressoutline, myButtons[i].pressfill, myButtons[i].presstextc, 1);

      } else {

        drawButton( myButtons[i].x, myButtons[i].y, myButtons[i].w, myButtons[i].h, myButtons[i].text, myButtons[i].outline, myButtons[i].fill, myButtons[i].textc, 1);

      }

      (*(myButtons[i].func))();

     

      break;

    }

  }

 

   

}

void DrawButtons ( void) {

  int i;

 

  for (int j = 0; j < MAX_BUTTONS; j++) {

    //Serial.print(":");Serial.print(myButtons[j].active);

    if ( myButtons[j].active && myButtons[j].enabled ) {

        //drawButton( myButtons[j].x, myButtons[j].y, myButtons[j].w, myButtons[j].h, myButtons[j].text, myButtons[j].outline, myButtons[j].fill, 1);

        i = j;

        if (myButtons[i].pressed) {

          drawButton( myButtons[i].x, myButtons[i].y, myButtons[i].w, myButtons[i].h, myButtons[i].text, myButtons[i].pressoutline, myButtons[i].pressfill, myButtons[i].presstextc, 1);

        } else {

          drawButton( myButtons[i].x, myButtons[i].y, myButtons[i].w, myButtons[i].h, myButtons[i].text, myButtons[i].outline, myButtons[i].fill, myButtons[i].textc, 1);

        }

    }

   

  }

 

}

void setup()

{

  Serial.begin(9600);

 

  /*

  myCal.zonex[0][0] = 13;myCal.zonex[0][1] = 13;myCal.zonex[0][2] = 11;

  myCal.zonex[1][0] = -3;myCal.zonex[1][1] = 1;myCal.zonex[1][2] = 5;

  myCal.zonex[2][0] = -11;myCal.zonex[2][1] = -10;myCal.zonex[2][2] = -7;

 

  myCal.zoney[0][0] = -15;myCal.zoney[0][1] = -12;myCal.zoney[0][2] = -12;

  myCal.zoney[1][0] = -10;myCal.zoney[1][1] = -3;myCal.zoney[1][2] = -10;

  myCal.zoney[2][0] = 1;myCal.zoney[2][1] = -3;myCal.zoney[2][2] = -6;

  */

 

  myCal.zonex[0][0] = 0;myCal.zonex[0][1] = 0;myCal.zonex[0][2] = 0;

  myCal.zonex[1][0] = 0;myCal.zonex[1][1] = 0;myCal.zonex[1][2] = 0;

  myCal.zonex[2][0] = 0;myCal.zonex[2][1] = 0;myCal.zonex[2][2] = 0;

 

  myCal.zoney[0][0] = 0;myCal.zoney[0][1] = 0;myCal.zoney[0][2] = 0;

  myCal.zoney[1][0] = 0;myCal.zoney[1][1] = 0;myCal.zoney[1][2] = 0;

  myCal.zoney[2][0] = 0;myCal.zoney[2][1] = 0;myCal.zoney[2][2] = 0;

 

 

  setupButtons();

  setupPlayback();

  ResetDJ(); //this will likely be replaced with a load function, to load from the flash memory the playback array

  brightness = 10;

  fader = 0;

 

  MakeButton( 0, 5, 5, 50, 50, green, gray, black, gray, black, green, "BitDJ", &LoadBitDJ);

  MakeButton( 1, 70, 5, 50, 50, orange, gray, black, gray, black, orange, "SoftLED", &DoSoftLED);

  MakeButton( 4, 5, 70, 50, 50, black, gray, white, gray, white, black, "Default", &doMySerial);

  MakeButton( 6, 70, 70, 50, 50, blue, gray, black, gray, black, blue, "Config", &DoSystemScreen);

  //green, gray, black, gray, black, white

  //black, gray, white, white, orange, black

 

  MakeButton( 5, 5, 5, 50, 50, blue, gray, black, gray, black, white, "Bright", &doBrightness);

  MakeButton( 2, 70, 5, 50, 50, blue, gray, black, gray, black, white, "Touch", &RunCalibration);

  MakeButton( 26, 5, 70, 50, 50, blue, gray, black, gray, black, white, "Sleep", &screenSleep);

  MakeButton( 3, 70, 70, 50, 50, green, gray, black, gray, black, white, "Exit", &BackToHome);

 

 

  MakeButton( 7, 5, 5, 35, 35, black, gray, orange, gray, white, black, "4", &toggle0);

  MakeButton( 8, 45, 5, 35, 35, black, gray, orange, gray, white, black, "5", &toggle1);

  MakeButton( 9, 85, 5, 35, 35, black, gray, orange, gray, white, black, "6", &toggle2);

  MakeButton( 10, 5, 45, 35, 35, black, gray, orange, gray, white, black, "7", &toggle3);

  MakeButton( 11, 45, 45, 35, 35, black, gray, orange, gray, white, black, "8", &toggle4);

  MakeButton( 12, 85, 45, 35, 35, black, gray, orange, gray, white, black, "9", &toggle5);

  MakeButton( 13, 5, 85, 35, 35, green, gray, red, gray, black, white, "Rec", &togglerec);

  MakeButton( 14, 45, 85, 35, 35, green, gray, black, gray, black, white, "Next", &DoBitDJ2);

  MakeButton( 15, 85, 85, 35, 35, green, gray, black, gray, black, white, "Exit", &BackToHome);

 

  MakeButton( 16, 5, 5, 35, 35, black, gray, orange, gray, white, black, "10", &toggle6);

  MakeButton( 17, 45, 5, 35, 35, black, gray, orange, gray, white, black, "11", &toggle7);

  MakeButton( 18, 5, 45, 35, 35, black, gray, orange, gray, white, black, "12", &toggle8);

 

  MakeButton( 19, 45, 45, 35, 35, black, gray, orange, gray, white, black, "13", &toggle9);

  MakeButton( 20, 85, 5, 35, 35, green, gray, black, gray, black, white, "Flip", &FlipAll);

  MakeButton( 21, 85, 45, 35, 35, green, gray, black, gray, black, white, "Play", &setPlay);

  MakeButton( 27, 85, 45, 35, 35, green, gray, black, gray, black, white, "Loop", &setLoop);

  MakeButton( 28, 85, 45, 35, 35, green, gray, black, gray, black, white, "Stop", &setStop);

 

  MakeButton( 22, 5, 85, 35, 35, green, gray, red, gray, black, white, "Rec", &togglerec);

  MakeButton( 23, 45, 85, 35, 35, green, gray, black, gray, black, white, "Prev", &DoBitDJ);

  MakeButton( 24, 85, 85, 35, 35, green, gray, black, gray, black, white, "Reset", &ResetDJ);//PrintDJ

 

  MakeButton( 25, 5, 5, 50, 50, blue, gray, black, gray, black, white, "Up", &BrightUp);

  MakeButton( 29, 70, 5, 50, 50, blue, gray, black, gray, black, white, "Down", &BrightDown);

  MakeButton( 30, 70, 70, 50, 50, green, gray, black, gray, black, white, "Exit", &DoSystemScreen);

  MakeButton( 31, 5, 70, 50, 50, blue, gray, black, gray, black, white, "Fade", &toggleFader);

 

  //delay(1000);

}

void screenSleep( void) {

  myButtons[26].pressed = 0;

  DrawButtons();

 

  for (int i = brightness; i>0; i--) {

    lcd_setBrightness(i);

    delay(30);

  }

 

  CLRBIT(PORTE, PE3);

 

  DrawMainFirstTime();

 

  while (1) {

    if (touch_get_cursor(&my_point)) {

      delay(50);

      break;

    }

  }

 

  SETBIT(PORTE, PE3);

 

  for (int i = 0; i<(brightness+1); i++) {

    lcd_setBrightness(i);

    delay(50);

  }

 

 

}

void fadeOut (void) {

  for (int i = brightness; i>0; i--) {

    lcd_setBrightness(i);

    delay(fader);

  }

 

  CLRBIT(PORTE, PE3);

}

void fadeIn(void) {

  SETBIT(PORTE, PE3);

 

  for (int i = 0; i<(brightness+1); i++) {

    lcd_setBrightness(i);

    delay(fader);

  }

}

void doBrightness( void) {

  fadeOut();

  lcd_clearScreen( black);

  clearButtons();

  buttonStatus( 25, 1);

  buttonStatus( 29, 1);

  buttonStatus( 30, 1);

  buttonStatus( 31, 1);

 

  if (fader == 0) {

    myButtons[31].pressed = 1;

  } else {

    myButtons[31].pressed = 0;

  }

 

  DrawButtons();

  fadeIn();

}

void BrightUp ( void) {

  if (brightness < 10) {

    brightness++;

  }

  lcd_setBrightness(brightness);

  myButtons[25].pressed = 0;

  DrawButtons();

}

void BrightDown ( void) {

  if (brightness > 1) {

    brightness--;

  }

  lcd_setBrightness(brightness);

  myButtons[29].pressed = 0;

  DrawButtons();

}

void toggleFader( void) {

  if (fader == 0) {

    fader = 10;

  } else {

    fader = 0;

  }

}

void RunCalibration ( void) {

  int i, j;

  POINT my_point;

 

  fadeOut();

  lcd_clearScreen( black);

  fadeIn();

 

  for (i = 0; i<CALIBRATE_POINTS; i++) {

  for (j = 0; j<CALIBRATE_POINTS; j++) {

    lcd_circle( (i)*CALIBRATE_DIV+CALIBRATE_OFF, (j)*CALIBRATE_DIV+CALIBRATE_OFF, 3, white, black);

    while (1) {

      if (touch_get_cursor(&my_point)) {

        lcd_circle( my_point.x, my_point.y, 3, white, white);

        Serial.print("x: "); Serial.print((i)*CALIBRATE_DIV+CALIBRATE_OFF-my_point.x, DEC);

        Serial.print("y: "); Serial.print((j)*CALIBRATE_DIV+CALIBRATE_OFF-my_point.y, DEC);

        Serial.println();

       

        myCal.zonex[i][j] = (i)*CALIBRATE_DIV+CALIBRATE_OFF-my_point.x;

        myCal.zoney[i][j] = (j)*CALIBRATE_DIV+CALIBRATE_OFF-my_point.y;

       

       

        break;

      }

    }

   

  }

  }

  fadeOut();

  DoSystemScreen ();

}

void doMySerial ( void) {

 

  Serial.print("This is a test\n\r");

 

 

}

short recording = 0;

short bitstatus[10];

unsigned long timesincerec = 0;

unsigned long playstarttime = 0;

#define PLAY_PLAY 0

#define PLAY_LOOP 1

#define PLAY_STOP 2

#define PLAY_MAX 50

typedef struct playstep {

  unsigned long time;

  unsigned long bitstat;

  int enabled;

} playstep;

playstep playback[PLAY_MAX];

int playptr;

short playmode;

int playbackptr;

void togglerec(void) {

  recording = !recording;

 

  if (recording) {

    if (playptr > 0) {

      timesincerec = millis() - playback[playptr - 1].time;

    } else {

      timesincerec = millis();

    }

  }

 

  SaveDJ();

};

void toggle0(void) { bitstatus[0] = !bitstatus[0]; Serial.print("P");Serial.print(0);Serial.println(bitstatus[0]);saver();};

void toggle1(void) { bitstatus[1] = !bitstatus[1]; Serial.print("P");Serial.print(1);Serial.println(bitstatus[1]);saver();};

void toggle2(void) { bitstatus[2] = !bitstatus[2]; Serial.print("P");Serial.print(2);Serial.println(bitstatus[2]);saver();};

void toggle3(void) { bitstatus[3] = !bitstatus[3]; Serial.print("P");Serial.print(3);Serial.println(bitstatus[3]);saver();};

void toggle4(void) { bitstatus[4] = !bitstatus[4]; Serial.print("P");Serial.print(4);Serial.println(bitstatus[4]);saver();};

void toggle5(void) { bitstatus[5] = !bitstatus[5]; Serial.print("P");Serial.print(5);Serial.println(bitstatus[5]);saver();};

void toggle6(void) { bitstatus[6] = !bitstatus[6]; Serial.print("P");Serial.print(6);Serial.println(bitstatus[6]);saver();};

void toggle7(void) { bitstatus[7] = !bitstatus[7]; Serial.print("P");Serial.print(7);Serial.println(bitstatus[7]);saver();};

void toggle8(void) { bitstatus[8] = !bitstatus[8]; Serial.print("P");Serial.print(8);Serial.println(bitstatus[8]);saver();};

void toggle9(void) { bitstatus[9] = !bitstatus[9]; Serial.print("P");Serial.print(9);Serial.println(bitstatus[9]);saver();};

void setPlay(void) {playmode=PLAY_PLAY; playstarttime = millis(); playbackptr = -1; buttonStatus( 21, 0);buttonStatus( 27, 1);DrawButtons();};

void setLoop(void) {playmode=PLAY_LOOP; playstarttime = millis(); playbackptr = -1; buttonStatus( 27, 0);buttonStatus( 28, 1);DrawButtons();};

void setStop(void) {playmode=PLAY_STOP; playstarttime = 0; playbackptr = -1; buttonStatus( 28, 0);buttonStatus( 27, 0);buttonStatus( 21, 1);DrawButtons();};

void setupPlayback( void) {

  playmode = PLAY_STOP;

}

void saver(void) {

  if (recording) {

    SaveDJ();

  }

}

void SaveDJ ( void) {

  unsigned long bitsave = 0;

  unsigned long prevtime;

  for (int i=0;i<10;i++){

    bitsave = bitsave << 1;

    bitsave = bitsave + bitstatus[9-i];

  }

  //Serial.print(bitstatus[i]);

 

  prevtime = timesincerec;

 

  playback[playptr].time = millis() - timesincerec;

  playback[playptr].bitstat = bitsave;

  playback[playptr].enabled = 1;

 

  //Serial.print(" tsr: ");

  //Serial.print(timesincerec);

  //Serial.print(" time: ");

  //Serial.print(playback[playptr].time);

 

 

  //Serial.print(bitsave);

  Serial.println();

 

  playptr++;

}

void PrintDJ( void) {

  Serial.println("------");

  for (int i=0;i<playptr;i++) {

    Serial.print("Time: ");

    Serial.print(playback[i].time);

    Serial.print(" Bitstat: ");

    Serial.print(playback[i].bitstat);

    Serial.print(" Enabled: ");

    Serial.print(playback[i].enabled);

    Serial.println();

  }

  Serial.println("------");

}

void ResetDJ( void) {

  for (int i=0;i<PLAY_MAX;i++){

    playback[i].enabled=0;

  }

  playptr = 0;

  myButtons[24].pressed = 0;

  DrawButtons();

  flashAllPins();

}

void FlipAll( void) {

  for (int i=0;i<10;i++){

    bitstatus[i]=!bitstatus[i];

  }

 

  saver();

 

  myButtons[7].pressed = !myButtons[7].pressed;

  myButtons[8].pressed = !myButtons[8].pressed;

  myButtons[9].pressed = !myButtons[9].pressed;

  myButtons[10].pressed = !myButtons[10].pressed;

  myButtons[11].pressed = !myButtons[11].pressed;

  myButtons[12].pressed = !myButtons[12].pressed;

  myButtons[16].pressed = !myButtons[16].pressed;

  myButtons[17].pressed = !myButtons[17].pressed;

  myButtons[18].pressed = !myButtons[18].pressed;

  myButtons[19].pressed = !myButtons[19].pressed;

 

  myButtons[20].pressed = 0;

 

  flashAllPins();

 

  DrawButtons();

};

void flashAllPins(void) {

  Serial.print("X");

  for (int i=0;i < 10;i++) {

    Serial.print(bitstatus[i]);

  }

  Serial.println();

}

void flashThePins(unsigned long bits) {

  int allpins[10];

 

  for (int i=0;i < 10;i++) {

    allpins[i] = bits & 1;

    bits = bits >> 1;

  }

 

  Serial.print("X");

  for (int i=0;i < 10;i++) {

    Serial.print(allpins[i]);

  }

  Serial.println();

}

void allOn( void) {

  for (int i=0;i<10;i++){

    bitstatus[i]=1;

  }

 

  myButtons[7].pressed = 1;

  myButtons[8].pressed = 1;

  myButtons[9].pressed = 1;

  myButtons[10].pressed = 1;

  myButtons[11].pressed = 1;

  myButtons[12].pressed = 1;

  myButtons[16].pressed = 1;

  myButtons[17].pressed = 1;

  myButtons[18].pressed = 1;

  myButtons[19].pressed = 1;

 

  myButtons[20].pressed = 0;

  DrawButtons();

};

void allOff( void) {

  for (int i=0;i<10;i++){

    bitstatus[i]=0;

  }

  myButtons[7].pressed = 0;

  myButtons[8].pressed = 0;

  myButtons[9].pressed = 0;

  myButtons[10].pressed = 0;

  myButtons[11].pressed = 0;

  myButtons[12].pressed = 0;

  myButtons[16].pressed = 0;

  myButtons[17].pressed = 0;

  myButtons[18].pressed = 0;

  myButtons[19].pressed = 0;

 

  myButtons[21].pressed = 0;

  DrawButtons();

};

void LoadBitDJ(void){

  //for (int i=0;i<10;i++){

  //  bitstatus[i]=0;

  //}

 

  fadeOut();

  flashAllPins();

  DoBitDJ();

  fadeIn();

}

void DoBitDJ ( void) {

  //fadeOut();

  lcd_clearScreen( black);

 

  clearButtons();

 

  buttonStatus( 7, 1);

  buttonStatus( 8, 1);

  buttonStatus( 9, 1);

  buttonStatus( 10, 1);

  buttonStatus( 11, 1);

  buttonStatus( 12, 1);

  buttonStatus( 13, 1);

  buttonStatus( 14, 1);

  buttonStatus( 15, 1);

 

  for (int i=0;i<6;i++){

    if (bitstatus[i]) {

      myButtons[i+7].pressed = 1;

    }

  }

  if (recording) {

    myButtons[13].pressed = 1;

  }

 

 

  DrawButtons();

  //fadeIn();

}

void DoBitDJ2 ( void) {

  //fadeOut();

  lcd_clearScreen( black);

 

  clearButtons();

 

  buttonStatus( 16, 1);

  buttonStatus( 17, 1);

  buttonStatus( 18, 1);

  buttonStatus( 19, 1);

  buttonStatus( 20, 1);

  buttonStatus( 21, 1);

  buttonStatus( 22, 1);

  buttonStatus( 23, 1);

  buttonStatus( 24, 1);

 

  for (int i=6;i<10;i++){

    if (bitstatus[i]) {

      myButtons[i+10].pressed = 1;

    }

  }

  if (recording) {

    myButtons[22].pressed = 1;

  }

 

  if (playmode == PLAY_PLAY) {

    buttonStatus( 27, 1);

  } else if (playmode == PLAY_LOOP) {

    buttonStatus( 28, 1);

  } else {

    buttonStatus( 21, 1);

  }

 

  DrawButtons();

  //fadeIn();

}

int stopSoftLED;

void DoSoftLED ( void) {

  POINT my_point;

  fadeOut();

  lcd_clearScreen( black);

  clearButtons();

  //buttonStatus( buttons[25], 1);

  //DrawButtons();

 

  Serial.println("SoftLED starting");

 

  for (int i=0;i<3;i++) {

    for (int j=0;j<3;j++){

      lcd_circle( i*42+20, j*42+20, 10, white, dimred);

    }

  }

 

  fadeIn();

 

  stopSoftLED = 0;

  while (!stopSoftLED) {

    if (touch_get_cursor(&my_point)) {

      //AdjustPoint( &my_point);

      //lcd_circle( my_point.x, my_point.y, 5, orange, black);

      //ActButtons(my_point.x, my_point.y);

      StopSoftLED();//if there's any click anywhere, stop and go back home

      delay(100); //delay a bit to allow lcd touch point to expire

    }

  }

 

  BackToHome ();

}

void StopSoftLED( void) {

  stopSoftLED = 1;

}

void DoSystemScreen ( void) {

  fadeOut();

  lcd_clearScreen( black);

  clearButtons();

 

  buttonStatus( 2, 1);

  buttonStatus( 3, 1);

  buttonStatus( 5, 1);

  buttonStatus( 26, 1);

 

  DrawButtons();

  fadeIn();

}

void BackToHome ( void) {

  clearButtons();

 

  DrawMain();

}

void DrawMain ( void) {

  fadeOut();

  lcd_clearScreen( black);

 

  clearButtons();

 

  buttonStatus( 0, 1);

  buttonStatus( 1, 1);

  buttonStatus( 4, 1);

  buttonStatus( 6, 1);

 

  DrawButtons();

  fadeIn();

}

void DrawMainFirstTime ( void) {

 

  lcd_clearScreen( black);

 

  clearButtons();

 

  buttonStatus( 0, 1);

  buttonStatus( 1, 1);

  buttonStatus( 4, 1);

  buttonStatus( 6, 1);

 

  DrawButtons();

}

void AdjustPoint( POINT* pnt) {

  //handle adjustments for a 3x3 imaginary grid made on the screen

  int zx = 2;

  int zy = 2;

 

  zx = pnt->x / CALIBRATE_DIV;

  zy = pnt->y / CALIBRATE_DIV;

 

  pnt->x = (pnt->x + myCal.zonex[zx][zy]);

  pnt->y = (pnt->y + myCal.zoney[zx][zy]);

}

void loop()

{

  //drawButton( 60, 30, 40, 20, myString, white, black, 1);

  //delay(1000);

  //drawButton( 60, 30, 40, 20, myString, white, white, 1);

  //delay(1000);

 

  /*

  Serial.print(123);

  Serial.print("X: ");

  Serial.print(myScreen.orientation, DEC);

  */

  POINT my_point;

  int foundmatch = 0;

  int i;

  unsigned long ptmp;

  char pinPrint[] = "0000000000";

 

  DrawMainFirstTime();

 

  while (1) {

    if (touch_get_cursor(&my_point)) {

      AdjustPoint( &my_point);

      //lcd_circle( my_point.x, my_point.y, 5, white, black);

      ActButtons(my_point.x, my_point.y);

      delay(100); //delay a bit to allow lcd touch point to expire

    }

   

    if (playmode != PLAY_STOP) {

      foundmatch = 0;

      for ( i = 1; i<=playptr; i++) {

        if ((playback[i].time) > (millis() - playstarttime)) {

          foundmatch = 1;

          break;

        }

      }

      if ((i>playptr)&&(playmode == PLAY_LOOP) && (foundmatch == 0)) {

        playstarttime = millis(); playbackptr = -1;

      }

      if ((i>playptr)&&(playmode == PLAY_PLAY) && (foundmatch == 0)) {

        setStop();

      }

      i--;

     

      if (foundmatch && (i < playptr) && (i != playbackptr) && (playmode != PLAY_STOP)) {

        playbackptr = i;

        //flashOutPins(playback[playptr - i].bitstat);

        //Serial.print((millis() - playstarttime));

        //Serial.print(" - ");

        //Serial.println(i);

        //flashOutPins(playback[i].bitstat);

        ptmp = playback[i].bitstat;

       

        /*Serial.print("X");

        for (int j=0; j<10;j++) {

          if ((ptmp >> j) & 1) {

            pinPrint[j] = 1;

          } else {

            pinPrint[j] = 0;

          }

        }

        Serial.println(pinPrint);

        */

        flashThePins(ptmp);

        Serial.println(ptmp);

        delay( 10);

      }

    }

   

  }

 

} //end loop

short buttonul[9][9] = {

  {0,0,0,0,4,1,2,2,3},

  {0,0,4,1,2,3,3,3,3},

  {0,4,2,3,3,3,3,3,3},

  {0,1,3,3,3,3,3,3,3},

  {4,2,3,3,3,3,3,3,3},

  {1,3,3,3,3,3,3,3,3},

  {2,3,3,3,3,3,3,3,3},

  {2,3,3,3,3,3,3,3,3},

  {3,3,3,3,3,3,3,3,3}

};

short buttonur[9][9] = {

  {3,2,2,1,4,0,0,0,0},

  {3,3,3,3,2,1,4,0,0},

  {3,3,3,3,3,3,2,4,0},

  {3,3,3,3,3,3,3,1,0},

  {3,3,3,3,3,3,3,2,4},

  {3,3,3,3,3,3,3,3,1},

  {3,3,3,3,3,3,3,3,2},

  {3,3,3,3,3,3,3,3,2},

  {3,3,3,3,3,3,3,3,3}

};

short buttonll[9][9] = {

  {3,3,3,3,3,3,3,3,3},

  {2,3,3,3,3,3,3,3,3},

  {2,3,3,3,3,3,3,3,3},

  {1,3,3,3,3,3,3,3,3},

  {4,2,3,3,3,3,3,3,3},

  {0,1,3,3,3,3,3,3,3},

  {0,4,2,3,3,3,3,3,3},

  {0,0,4,1,2,3,3,3,3},

  {0,0,0,0,4,1,2,2,3}

};

short buttonlr[9][9] = {

  {3,3,3,3,3,3,3,3,3},

  {3,3,3,3,3,3,3,3,2},

  {3,3,3,3,3,3,3,3,2},

  {3,3,3,3,3,3,3,3,1},

  {3,3,3,3,3,3,3,2,4},

  {3,3,3,3,3,3,3,1,0},

  {3,3,3,3,3,3,2,4,0},

  {3,3,3,3,2,1,4,0,0},

  {3,2,2,1,4,0,0,0,0}

};

void copycolor ( COLOR from, COLOR* to) {

  to->red = from.red;

  to->green = from.green;

  to->blue = from.blue;

}

void drawButton( int x, int y, int w, int h, char* text, COLOR outline, COLOR fill, COLOR textc, int alias) {

  //COLOR but2, but1, but3, but4;

 

  COLOR but2 = {207, 207, 207};

  COLOR but1 = {149, 149, 149};

  //COLOR but3 = {255, 255, 255};

  COLOR but3 = fill;

  COLOR but4 = {85, 85, 85};

 

  int i, j, xo, yo, pix, len;

 

  lcd_rectangle(x+4, y+4, x+w-4, y+h-4, fill, fill);

 

  lcd_rectangle(x+1, y+8, x+w-1, y+h-8, fill, fill);

  lcd_rectangle(x+8, y+1, x+w-8, y+8, fill, fill);

  lcd_rectangle(x+8, y+h-8, x+w-8, y+h-1, fill, fill);

 

  xo = 0; yo = 0;

  for ( i = 0; i < 9; i++) {

    for (j = 0; j < 9; j++) {

      pix = buttonul[i][j];

      if (pix == 0) {

        lcd_pixel( x + i + xo, y + j + yo, black);

      } else if (pix == 1) {

        lcd_pixel( x + i + xo, y + j + yo, but1);

      }if (pix == 2) {

        lcd_pixel( x + i + xo, y + j + yo, but2);

      }if (pix == 3) {

        lcd_pixel( x + i + xo, y + j + yo, but3);

      }if (pix == 4) {

        lcd_pixel( x + i + xo, y + j + yo, but4);

      }

    }

  }

 

  xo = 0; yo = h-8;

  for ( i = 0; i < 9; i++) {

    for (j = 0; j < 9; j++) {

      pix = buttonur[i][j];

      if (pix == 0) {

        lcd_pixel( x + i + xo, y + j + yo, black);

      } else if (pix == 1) {

        lcd_pixel( x + i + xo, y + j + yo, but1);

      }if (pix == 2) {

        lcd_pixel( x + i + xo, y + j + yo, but2);

      }if (pix == 3) {

        lcd_pixel( x + i + xo, y + j + yo, but3);

      }if (pix == 4) {

        lcd_pixel( x + i + xo, y + j + yo, but4);

      }

    }

  }

 

 

  xo = w-8; yo = 0;

  for ( i = 0; i < 9; i++) {

    for (j = 0; j < 9; j++) {

      pix = buttonll[i][j];

      if (pix == 0) {

        lcd_pixel( x + i + xo, y + j + yo, black);

      } else if (pix == 1) {

        lcd_pixel( x + i + xo, y + j + yo, but1);

      }if (pix == 2) {

        lcd_pixel( x + i + xo, y + j + yo, but2);

      }if (pix == 3) {

        lcd_pixel( x + i + xo, y + j + yo, but3);

      }if (pix == 4) {

        lcd_pixel( x + i + xo, y + j + yo, but4);

      }

    }

  }

 

 

  xo = w-8; yo = h-8;

  for ( i = 0; i < 9; i++) {

    for (j = 0; j < 9; j++) {

      pix = buttonlr[i][j];

      if (pix == 0) {

        lcd_pixel( x + i + xo, y + j + yo, black);

      } else if (pix == 1) {

        lcd_pixel( x + i + xo, y + j + yo, but1);

      }if (pix == 2) {

        lcd_pixel( x + i + xo, y + j + yo, but2);

      }if (pix == 3) {

        lcd_pixel( x + i + xo, y + j + yo, but3);

      }if (pix == 4) {

        lcd_pixel( x + i + xo, y + j + yo, but4);

      }

    }

  }

 

 

  lcd_line(x+7, y, x+w-7, y, outline);

  lcd_line(x, y+7, x, y+h-7, outline);

  lcd_line(x+7, y+h, x+w-7, y+h, outline);

  lcd_line(x+w, y+7, x+w, y+h-7, outline);

 

  len = strlen(text);

  lcd_puts( text, 1+x+w/2-(len * 6)/2, 1+y+h/2-4, textc, fill);

}
