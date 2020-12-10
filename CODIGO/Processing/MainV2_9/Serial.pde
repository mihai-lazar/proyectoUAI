

void connect_serial() {
  println ("Escaneado puertos abiertos...");
   
    int lastPort = Serial.list().length -1;
   
    while (lastPort<0) {
      println("No se encontraron puertos, re-escaneado...");
      delay(1000);
      lastPort = Serial.list().length -1;
    }
   
   println("Puertos disponibles...");
   
   int home = 0;
    while (!found) {
      String portName = Serial.list()[lastPort -1];
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
          println("Respuesta del puerto " + portName);
          connectedPort = portName;
          delay(200);
          while(home != 3){
            if(home == 0){
              arduinoPort.write("Z+\n"); 
             }else if(home == 1){
              arduinoPort.write("X0\n"); 
             }else if(home == 2){
              arduinoPort.write("Y0\n"); 
             } 
            if(estado_arduino.equals("Z+")){
              home = 1;
            }else if(estado_arduino.equals("X0")){
              home = 2;
            }else if(estado_arduino.equals("Y0")){
              home = 3;
              arduinoPort.write("S\n"); 
            }
          }

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
  estado_arduino = port.readStringUntil('\n');
  estado_arduino = trim(estado_arduino);
  println(estado_arduino);
  if (estado_arduino.equals("H")) {
    found = true;   
  }
}
