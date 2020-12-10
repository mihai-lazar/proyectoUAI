

void connect_serial() {
  println ("scan open com ports...");
   
    boolean found = false;
    int lastPort = Serial.list().length -1;
   
    while (lastPort<0)
    {
      println("No com ports in use. Rescanning...");
      delay(1000);
      lastPort = Serial.list().length -1;
    }
   
   println("Locating device...");
   
    println(Serial.list());
   
    while (!found)
    {
      String portName = Serial.list()[lastPort];
      println("Connecting to -> " + portName);
      delay(200);
   
      try {
        arduinoPort = new Serial(this, portName, 115200);
        arduinoPort.clear();
        arduinoPort.bufferUntil(10);
        arduinoPort.write('H');   -- Send  Hello
   
        int l = 5;
        while (!found && l >0)
        {
          delay(200);
          println("Waiting for response from device on " + portName);
          l--;
        }
   
        if (!found)
        {
          println("No response from device on " + portName);
          arduinoPort.clear();
          arduinoPort.stop();
          delay(200);
        }
   
      }
      catch (Exception e) {
        println("Exception connecting to " + portName);
        println(e);
      }
   
      lastPort--;
      if (lastPort <0)
        lastPort = Serial.list().length -1;
    }  
  
}
