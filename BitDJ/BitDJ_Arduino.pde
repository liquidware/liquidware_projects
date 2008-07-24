 #include <SoftwareSerial.h>

#define rxPin 3

#define txPin 2

SoftwareSerial mySerial =  SoftwareSerial(rxPin, txPin);

int pins[10];

char thebyte;

void setup()

{

  // define pin modes for tx, rx:

 

  pinMode(rxPin, INPUT);

  pinMode(txPin, OUTPUT);

  mySerial.begin(9600);

  beginSerial(9600);

 

  pinMode(4, OUTPUT);

  pinMode(5, OUTPUT);

  pinMode(6, OUTPUT);

  pinMode(7, OUTPUT);

  pinMode(8, OUTPUT);

  pinMode(9, OUTPUT);

  pinMode(10, OUTPUT);

  pinMode(11, OUTPUT);

  pinMode(12, OUTPUT);

  pinMode(13, OUTPUT);

}

int i,thepin;

char pin, status;

int printout;

void loop()

{

  printout = 0;

 

  thebyte = mySerial.read();

  Serial.print(thebyte);

 

  if (thebyte == 'P') {

    pin = mySerial.read();

    status = mySerial.read();

    thepin = pin - 48;

    if (status == '1') {

      pins[thepin] = 1;

    } else {

      pins[thepin] = 0;

    }

    printout = 1;

  } else if (thebyte == 'X') {

    for (i=0;i<10;i++){

      thebyte = mySerial.read();

      //Serial.print(thebyte);

      if (thebyte == '1') {

        pins[i] = 1;

      } else {

        pins[i] = 0;

      }

    }

    printout = 1;

  }

 

 

 

  if (printout) {

  for (i=0;i<10;i++) {

    

    Serial.print(pins[i]);

    if (pins[i]) {

      digitalWrite(4+i, HIGH);

    } else {

      digitalWrite(4+i, LOW);

    }

  }

 

  Serial.println();

  }

 

 

}
