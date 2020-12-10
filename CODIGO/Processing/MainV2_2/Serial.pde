

void connect_serial() {
  println ("Escaneado puertos abiertos...");
   
    int lastPort = Serial.list().length -1;
   
    while (lastPort<0) {
      println("No se encontraron puertos, re-escaneado...");
      delay(1000);
      lastPort = Serial.list().length -1;
    }
   
   println("Puertos disponibles...");
   
   
    while (!found) {
      String portName = Serial.list()[lastPort];
      println("Conectando al puerto -> " + portName);
   
      try {
        arduinoPort = new Serial(this, portName, 9600);
        println("Esperando respuesta en el puerto " + portName);
        delay(1000);
        arduinoPort.clear();
        arduinoPort.bufferUntil('\n'); 
        arduinoPort.write('H');   // Send  Hello
        delay(200);
        
        if (!found) {
          println("No se obtuvo respuesta del puerto " + portName);
          arduinoPort.clear();
          arduinoPort.stop();
          delay(200);
        }else{
          connectedPort = portName;
        }
   
      }
      catch (Exception e) {
        println("Error al conectarse al puerto " + portName);
        println(e);
      }
   
      lastPort--;
      if (lastPort <0)
        lastPort = Serial.list().length -1;
    }  
  
}

void serialEvent (Serial port) {
  String val = port.readStringUntil('\n');
  val = trim(val);
  println(val);
  if (val.equals("H")) {
    found = true;   
  }
}
