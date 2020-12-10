void mover_eje_x(){

  switch (SUBCOMANDO) {
    case '+':
      digitalWrite(X_DIR_PIN , HIGH);
      if(millis() - timer_e > 1){
        if(digitalRead(X_STEP_PIN) == LOW)
          digitalWrite(X_STEP_PIN , HIGH);
        else
          digitalWrite(X_STEP_PIN , LOW);
       timer_e = millis();
      }
      break;
    case '-':
      digitalWrite(X_DIR_PIN , LOW);
      break;
  }


  
}

void mover_eje_y(){

  switch (SUBCOMANDO) {
    case '+':
      digitalWrite(Y_DIR_PIN , HIGH);
      digitalWrite(Y1_DIR_PIN , LOW);
      break;
    case '-':
      digitalWrite(Y_DIR_PIN , LOW);
      digitalWrite(Y1_DIR_PIN , HIGH);
      break;
  }

  if(millis() - timer_e > 1){
    if(digitalRead(Y_STEP_PIN) == LOW){
      digitalWrite(Y_STEP_PIN , HIGH);
      digitalWrite(Y1_STEP_PIN , LOW);
    }else{
      digitalWrite(Y_STEP_PIN , LOW);
      digitalWrite(Y1_STEP_PIN , HIGH);
    }
    timer_e = millis();
  }
  
}

void mover_electroiman(){

  switch (SUBCOMANDO) {
    case '+':
      digitalWrite(Z_DIR_PIN , HIGH);
      digitalWrite(ELECTRO_IMAN , HIGH);
      break;
    case '-':
      digitalWrite(Z_DIR_PIN , LOW);
      digitalWrite(ELECTRO_IMAN , LOW);
      break;
  }

  if(millis() - timer_e > 1){
    if(digitalRead(Z_STEP_PIN) == LOW)
      digitalWrite(Z_STEP_PIN , HIGH);
    else
      digitalWrite(Z_STEP_PIN , LOW);
    timer_e = millis();
  }
  
}
