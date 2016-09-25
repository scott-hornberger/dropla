/*
 *  This is how the arduino controller controls the bumpers, dispenser object, and global setting 
 *  (like BallsPM and beat division for each drop point).
 *  Ugly code, lots of hard coding (because it's interacting with hardware???).
 *  Needs some love.
 *
 * ALSO: Future Scott, this is a one way street. It would be cool if processing talked back to the arduino. Imagine the controller's lights flashin each time a ball is dropped.
 */


void openSerialConnections() {
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller.
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more, as in "'A', give me mo'!" spoken like you're from New Jersey
    }
  }
  else {  // We have made contact
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;
    // Repeat until we have as many bytes as we have sensors
    // If we have numSensors # of bytes:
    if (serialCount >= NUM_SENSORS ) {
      // Here we read in each sensor's data as a byte from 0 - 255
      // set it to the thing you want to control

      //float dispenserWidth = int(map(serialInArray[1], 0, 255, width, 0)); // but in exp 003 we use it for the bumper
      


      
      
      //println(blockRate);
      
      float bumper1X = int(map(serialInArray[2], 0, 255, 0, width));    // Sensor data. We used it for the dispenser. 
      float bumper1Y = int(map(serialInArray[0], 0, 255, height, 0)); // but in exp 003 we use it for the bumper
      float angle1 = (map(serialInArray[1],0,255,PI,0));
      
      bumper1.update(bumper1X, bumper1Y, angle1);
      
      float bumper2X = int(map(serialInArray[5], 0, 255, 0, width));    // Sensor data. We used it for the dispenser. 
      float bumper2Y = int(map(serialInArray[3], 0, 255, height, 0)); // but in exp 003 we use it for the bumper
      float angle2 = (map(serialInArray[4],0,255,PI,0));
      
      bumper2.update(bumper2X, bumper2Y, angle2);
      
      
      float dispenserX = int(map(serialInArray[6], 0, 255, 0, width));    // Sensor data. We used it for the dispenser.
      float dispenserWidth = (map(serialInArray[8], 0, 255, width/4, width));
      int blockRate = int(map(serialInArray[7],0,255,5,100));
      globalBlockRate = blockRate;
      //println(blockRate);
      
      for (int i = 0; i < 4; i++) {
        if (int(map(serialInArray[9 + i],0,255,0,1)) == 1) {
          dispenser.dropPoints[i].increaseCode();
        } else {
          dispenser.dropPoints[i].acceptingChange();
        }
      }
      
      int signal1 = int(map(serialInArray[13],0,255,0,1));
      int signal2 = int(map(serialInArray[14],0,255,0,1));
      noteShift(signal1,signal2);
      
      
      dispenser.setVertices(dispenserX,dispenserWidth);
      dispenser.setBlockRate(blockRate);

      //// print the values (for debugging purposes only):
      //println(xpos + "\t" + ypos);

      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}
