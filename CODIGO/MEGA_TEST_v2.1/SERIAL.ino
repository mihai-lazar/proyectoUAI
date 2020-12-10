void serialEvent() {
  
  serial_buffer = Serial.readStringUntil('\n'); // read it and store it in val
  serial_buffer.trim();

  if(serial_buffer[0] == 'H'){
    Serial.write("H\n");
  }else if(serial_buffer[0] == 'X'){
    COMANDO = serial_buffer[0];
    SUBCOMANDO = serial_buffer[1];
  }else if(serial_buffer[0] == 'Y'){
    COMANDO = serial_buffer[0];
    SUBCOMANDO = serial_buffer[1];
  }else if(serial_buffer[0] == 'Z'){
    COMANDO = serial_buffer[0];
    SUBCOMANDO = serial_buffer[1];
  }else{
    COMANDO = serial_buffer[0];
  }

}
