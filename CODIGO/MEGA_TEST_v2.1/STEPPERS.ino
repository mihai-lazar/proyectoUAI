void mover_eje_x(){

  switch (SUBCOMANDO) {
    case '+':
      if(digitalRead(X_MAX_PIN) == HIGH){
        digitalWrite(X_ENABLE_PIN , LOW);
        digitalWrite(X_DIR_PIN , HIGH);
      }else{
        digitalWrite(X_ENABLE_PIN , HIGH);
        SUBCOMANDO = '-';
      }
      break;
    case '-':
      if(digitalRead(X_MIN_PIN) == HIGH){
        digitalWrite(X_ENABLE_PIN , LOW);
        digitalWrite(X_DIR_PIN , LOW);
      }else{
        digitalWrite(X_ENABLE_PIN , HIGH);
        SUBCOMANDO = '+';
      }
      break;
  }

  digitalWrite(X_STEP_PIN , HIGH);
  delayMicroseconds(DELAY_STEPPERS);
  digitalWrite(X_STEP_PIN , LOW);
  delayMicroseconds(DELAY_STEPPERS);
  
}

void mover_eje_y(){

  switch (SUBCOMANDO) {
    case '+':
      if(digitalRead(Y_Y1_MAX_PIN) == HIGH){
        digitalWrite(Y_ENABLE_PIN , LOW);
        digitalWrite(Y1_ENABLE_PIN , LOW);
        digitalWrite(Y_DIR_PIN , HIGH);
        digitalWrite(Y1_DIR_PIN , LOW);
      }else{
        digitalWrite(Y_ENABLE_PIN , HIGH);
        digitalWrite(Y1_ENABLE_PIN , HIGH);
      }
      break;
    case '-':
      if(digitalRead(Y_Y1_MIN_PIN) == HIGH){
        digitalWrite(Y_ENABLE_PIN , LOW);
        digitalWrite(Y1_ENABLE_PIN , LOW);    
        digitalWrite(Y_DIR_PIN , LOW);
        digitalWrite(Y1_DIR_PIN , HIGH);
      }else{
        digitalWrite(Y_ENABLE_PIN , HIGH);
        digitalWrite(Y1_ENABLE_PIN , HIGH);
      }
      break;
  }

  digitalWrite(Y_STEP_PIN , HIGH);
  digitalWrite(Y1_STEP_PIN , HIGH);
  delayMicroseconds(DELAY_STEPPERS);
  digitalWrite(Y_STEP_PIN , LOW);
  digitalWrite(Y1_STEP_PIN , LOW);
  delayMicroseconds(DELAY_STEPPERS);
  
}

void mover_electroiman(){

  switch (SUBCOMANDO) {
    case '+':
      if(digitalRead(Z_MAX_PIN) == HIGH){
        digitalWrite(Z_ENABLE_PIN , LOW);
        digitalWrite(Z_DIR_PIN , LOW);
        digitalWrite(ELECTRO_IMAN , HIGH);
      }
      break;
    case '-':
      if(digitalRead(Z_MIN_PIN) == HIGH){
        digitalWrite(Z_ENABLE_PIN , LOW);
        digitalWrite(Z_DIR_PIN , HIGH);
        digitalWrite(ELECTRO_IMAN , LOW);
      }
      break;
  }

  digitalWrite(Z_STEP_PIN , HIGH);
  delayMicroseconds(DELAY_ELECTROIMAN);
  digitalWrite(Z_STEP_PIN , LOW);
  delayMicroseconds(DELAY_ELECTROIMAN);
  
}
