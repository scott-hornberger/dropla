const int LEFT = 0;
const int RIGHT= 1;

const int THIN = 2;
const int WIDE = 3;

const int LESS = 4;
const int MORE = 5;

const int BEAT1 = 6;
const int BEAT2 = 7;
const int BEAT3 = 8;
const int BEAT4 = 9;

const int FIFTH = 10;
const int OCTAVE = 11;

const int NUM_SWITCHES = 12;

const int MIN = 0;
const int MAX = 255;

int switchStates[NUM_SWITCHES];

int sensor1A = 0;   // first controller x-axis
int sensor1B = 0;   // first controller angle
int sensor1C = 0;   // first controller y-axis

int sensor2A = 0;   // second controller x-axis
int sensor2B = 0;   // second controller angle
int sensor2C = 0;   // second controller y-axis

int dispenserX = 255/2;
int dispenserBlockRate = 255/2;
int dispenserWidth = 255/2;

int beat1;
int beat2;
int beat3;
int beat4;

int beat1Prev;
int beat2Prev;
int beat3Prev;
int beat4Prev;

int fifth;
int fifthPrev;

int octave;
int octavePrev;

int inByte = 0;     // incoming serial byte

void setup() {

  //initializeButtons();
  for (int button = 2; button < 2 + NUM_SWITCHES; button++) {
    pinMode(button, INPUT);
  }
  // start serial port at 9600 bps:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }


  establishContact();  // send a byte to establish contact until receiver responds
}

void loop() {
  handleCom();
  sendData();

}


void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');   // send a capital A
    delay(300);
  }
}

void handleCom() {
  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    // read first analog input, divide by 4 to make the range 0-255:
    sensor1A = map(analogRead(A0), 0 , 1024,0,255);
    // delay 10ms to let the ADC recover:
    delay(1);
    // read second analog input, divide by 4 to make the range 0-255:
    sensor1B = map(analogRead(A1), 0 , 1024,0,255);
    delay(1);
    // read  switch, map it to 0 or 255
    sensor1C = map(analogRead(A2), 0 , 1024,0,255);
    // delay 10ms to let the ADC recover:
    delay(1);

    // read first analog input, divide by 4 to make the range 0-255:
    sensor2A = map(analogRead(A3), 0 , 1024,0,255);
    // delay 10ms to let the ADC recover:
    delay(1);
    // read second analog input, divide by 4 to make the range 0-255:
    sensor2B = map(analogRead(A4), 0 , 1024,0,255);
    delay(1);
    // read  switch, map it to 0 or 255
    sensor2C = map(analogRead(A5), 0 , 1024,0,255);
    // delay 10ms to let the ADC recover:
    delay(15);


    for (int button = 2; button < 2 + NUM_SWITCHES; button++) {
      switchStates[button - 2] = digitalRead(button);
    }
    setDispenserInfo(switchStates);

  }
}

void setDispenserInfo(int switchStates[]) {
  if (switchStates[LEFT] == HIGH) {
    changeDispenserX(-1);
  }
  if (switchStates[RIGHT] == HIGH) {
    changeDispenserX(1);
  }
  if (switchStates[THIN] == HIGH) {
    changeDispenserWidth(-1);
  }
  if (switchStates[WIDE] == HIGH) {
    changeDispenserWidth(1);
  }
  if (switchStates[MORE] == HIGH) {
    changeDispenserBlockRate(-1);
  }
  if (switchStates[LESS] == HIGH) {
    changeDispenserBlockRate(1);
  }
  if (switchStates[BEAT1] != beat1Prev) {
    if (switchStates[BEAT1] == HIGH) {
      beat1 = MAX; 
    }
    else {
      beat1 = MIN;
    }
  }
  beat1Prev = switchStates[BEAT1];

  if (switchStates[BEAT2] != beat2Prev) {
    if (switchStates[BEAT2] == HIGH) {
      beat2 = MAX; 
    }
    else {
      beat2 = MIN;
    }
  }
  beat2Prev = switchStates[BEAT2];

  if (switchStates[BEAT3] != beat3Prev) {
    if (switchStates[BEAT3] == HIGH) {
      beat3 = MAX; 
    }
    else {
      beat3 = MIN;
    }
  }
  beat3Prev = switchStates[BEAT3];

  if (switchStates[BEAT4] != beat4Prev) {
    if (switchStates[BEAT4] == HIGH) {
      beat4 = MAX; 
    }
    else {
      beat4 = MIN;
    }
  }
  beat4Prev = switchStates[BEAT4];

  if (switchStates[FIFTH] != fifthPrev) {
    if (switchStates[FIFTH] == HIGH) {
      fifth = MAX; 
    }
    else {
      fifth = MIN;
    }
  }
  fifthPrev = switchStates[FIFTH];

  if (switchStates[OCTAVE] != octavePrev) {
    if (switchStates[OCTAVE] == HIGH) {
      octave = MAX; 
    }
    else {
      octave = MIN;
    }
  }
  octavePrev = switchStates[OCTAVE];
}

void changeDispenserX(int mult) {
  const int RATE = 1;
  int newX = dispenserX + (mult * RATE);
  if (newX >= MIN && newX <= MAX)
    dispenserX = newX;
} 

void changeDispenserBlockRate(int mult) {
  const int RATE = 1;
  int newBlockRate = dispenserBlockRate + (mult * RATE);
  if (newBlockRate >= MIN && newBlockRate <= MAX)
    dispenserBlockRate = newBlockRate;
} 

void changeDispenserWidth(int mult) {
  const int RATE = 3;
  int newWidth = dispenserWidth + (mult * RATE);
  if (newWidth >= MIN && newWidth <= MAX)
    dispenserWidth = newWidth;
} 

void sendData() {
  // send sensor values:
  Serial.write(sensor1A);
  Serial.write(sensor1B);
  Serial.write(sensor1C);

  Serial.write(sensor2A);
  Serial.write(sensor2B);
  Serial.write(sensor2C);

  Serial.write(dispenserX);
  Serial.write(dispenserBlockRate);
  Serial.write(dispenserWidth);

  Serial.write(beat1);
  Serial.write(beat2);
  Serial.write(beat3);
  Serial.write(beat4);
  
  Serial.write(fifth);
  Serial.write(octave);
}


