void mover_eje_x(){

  switch (SUBCOMANDO) {
    case '0':
      if(digitalRead(X_MAX_PIN) == HIGH && pasos_x < 2100){
        pasos++;
        mover_stepper_x();      
      }else{
        Serial.write("X+0\n");
        //46190
        //2100
        //15200
        //27660
        //42300
        Serial.println(pasos);
      }
      break;
    case '1':
      if(digitalRead(X_MIN_PIN) == HIGH){
        pasos++;
        digitalWrite(X_DIR_PIN , LOW);
        
        digitalWrite(X_STEP_PIN , HIGH);
        delayMicroseconds(DELAY_STEPPERS);
        digitalWrite(X_STEP_PIN , LOW);
        delayMicroseconds(DELAY_STEPPERS);
      }else{
        Serial.write("X-\n");
        //46192
        Serial.println(pasos);
      }
      break;
    case '2':
      break;
    case '3':
      break;
  }
  
}

void mover_stepper_x(){
  digitalWrite(X_DIR_PIN , HIGH);
        
  digitalWrite(X_STEP_PIN , HIGH);
  delayMicroseconds(DELAY_STEPPERS);
  digitalWrite(X_STEP_PIN , LOW);
  delayMicroseconds(DELAY_STEPPERS);   
   
}

void mover_eje_y(){

  switch (SUBCOMANDO) {
    case '+':
      if(digitalRead(Y_Y1_MAX_PIN) == HIGH){
        digitalWrite(Y_DIR_PIN , LOW);
        digitalWrite(Y1_DIR_PIN , HIGH);

        digitalWrite(Y_STEP_PIN , HIGH);
        digitalWrite(Y1_STEP_PIN , HIGH);
        delayMicroseconds(DELAY_STEPPERS);
        digitalWrite(Y_STEP_PIN , LOW);
        digitalWrite(Y1_STEP_PIN , LOW);
        delayMicroseconds(DELAY_STEPPERS);
      }else{
        Serial.write("Y+\n");
      }
      break;
    case '-':
      if(digitalRead(Y_Y1_MIN_PIN) == HIGH){  
        digitalWrite(Y_DIR_PIN , HIGH);
        digitalWrite(Y1_DIR_PIN , LOW);

        digitalWrite(Y_STEP_PIN , HIGH);
        digitalWrite(Y1_STEP_PIN , HIGH);
        delayMicroseconds(DELAY_STEPPERS);
        digitalWrite(Y_STEP_PIN , LOW);
        digitalWrite(Y1_STEP_PIN , LOW);
        delayMicroseconds(DELAY_STEPPERS);      
      }else{
        Serial.write("Y-\n");
      }
      break;
  }
  
}

void mover_electroiman(){

  switch (SUBCOMANDO) {
    case '+':
      if(digitalRead(Z_MAX_PIN) == HIGH){
        digitalWrite(Z_DIR_PIN , LOW);
        digitalWrite(ELECTRO_IMAN , HIGH);

        digitalWrite(Z_STEP_PIN , HIGH);
        delayMicroseconds(DELAY_ELECTROIMAN);
        digitalWrite(Z_STEP_PIN , LOW);
        delayMicroseconds(DELAY_ELECTROIMAN);        
      }else{
        Serial.write("Z+\n");
      }
      break;
    case '-':
      if(digitalRead(Z_MIN_PIN) == HIGH){
        digitalWrite(Z_DIR_PIN , HIGH);
        digitalWrite(ELECTRO_IMAN , LOW);
      
        digitalWrite(Z_STEP_PIN , HIGH);
        delayMicroseconds(DELAY_ELECTROIMAN);
        digitalWrite(Z_STEP_PIN , LOW);
        delayMicroseconds(DELAY_ELECTROIMAN);             
      }else{
        Serial.write("Z-\n");
      }
      break;
  }

}
