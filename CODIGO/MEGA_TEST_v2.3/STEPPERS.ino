void mover_eje_x(){
        //46190 MAXIMO
        //2100
        //15200
        //27660
        //42300
  switch (SUBCOMANDO) {
    case '0':
      if(pasos_x < 2000){
        pasos_x++;
        mover_stepper_x('+');      
      }else if(pasos_x > 2000){
        pasos_x--;
        mover_stepper_x('-');  
      }else{
        Serial.write("X0\n");
      }
      break;
    case '1':
      if(pasos_x < 17000){
        pasos_x++;
        mover_stepper_x('+');      
      }else if(pasos_x > 17000){
        pasos_x--;
        mover_stepper_x('-');  
      }else{
        Serial.write("X1\n");
      }
      break;
    case '2':
      if(pasos_x < 32000){
        pasos_x++;
        mover_stepper_x('+');      
      }else if(pasos_x > 32000){
        pasos_x--;
        mover_stepper_x('-');  
      }else{
        Serial.write("X2\n");
      }
      break;
    case '3':
      if(pasos_x < 47000){
        pasos_x++;
        mover_stepper_x('+');      
      }else if(pasos_x > 47000){
        pasos_x--;
        mover_stepper_x('-');  
      }else{
        Serial.write("X3\n");
      }
      break;
  }
  
}

void mover_stepper_x(char dir){
  
  if(dir == '+'){
    digitalWrite(X_DIR_PIN , HIGH);
  }else{  
    digitalWrite(X_DIR_PIN , LOW);
  }
         
  digitalWrite(X_STEP_PIN , HIGH);
  delayMicroseconds(DELAY_STEPPERS);
  digitalWrite(X_STEP_PIN , LOW);
  delayMicroseconds(DELAY_STEPPERS);   
   
}

void mover_eje_y(){

  //34948
  //1917
  //7038
  //6548
  ///6454
  //5696
  //6051
  
  switch (SUBCOMANDO) {
    case '0':
      if(pasos_y < 2000){
        pasos_y++;
        mover_stepper_y('+');      
      }else if(pasos_y > 2000){
        pasos_y--;
        mover_stepper_y('-');  
      }else{
        Serial.write("Y0\n");
      }
      break;
    case '1':
      if(pasos_y < 8500){
        pasos_y++;
        mover_stepper_y('+');      
      }else if(pasos_y > 8500){
        pasos_y--;
        mover_stepper_y('-');  
      }else{
        Serial.write("Y1\n");
      }
      break;
    case '2':
      if(pasos_y < 15000){
        pasos_y++;
        mover_stepper_y('+');      
      }else if(pasos_y > 15000){
        pasos_y--;
        mover_stepper_y('-');  
      }else{
        Serial.write("Y2\n");
      }
      break;
    case '3':
      if(pasos_y < 21500){
        pasos_y++;
        mover_stepper_y('+');      
      }else if(pasos_y > 21500){
        pasos_y--;
        mover_stepper_y('-');  
      }else{
        Serial.write("Y3\n");
      }
      break;
    case '4':
      if(pasos_y < 28000){
        pasos_y++;
        mover_stepper_y('+');      
      }else if(pasos_y > 28000){
        pasos_y--;
        mover_stepper_y('-');  
      }else{
        Serial.write("Y4\n");
      }
      break;
    case '5':
      if(pasos_y < 34500){
        pasos_y++;
        mover_stepper_y('+');      
      }else if(pasos_y > 34500){
        pasos_y--;
        mover_stepper_y('-');  
      }else{
        Serial.write("Y5\n");
      }
      break;
      
  }
  
}

void mover_stepper_y(char dir){
  if(dir == '+'){
    digitalWrite(Y_DIR_PIN , LOW);
    digitalWrite(Y1_DIR_PIN , HIGH);
  }else{  
    digitalWrite(Y_DIR_PIN , HIGH);
    digitalWrite(Y1_DIR_PIN , LOW);
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
        digitalWrite(Z_DIR_PIN , LOW);

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
      
        digitalWrite(Z_STEP_PIN , HIGH);
        delayMicroseconds(DELAY_ELECTROIMAN);
        digitalWrite(Z_STEP_PIN , LOW);
        delayMicroseconds(DELAY_ELECTROIMAN);             
      }else{
        Serial.write("Z-\n");
      }
      break;
    case '=':
      if(digitalRead(ELECTRO_IMAN) == LOW)
        digitalWrite(ELECTRO_IMAN , HIGH);
      else
        digitalWrite(ELECTRO_IMAN , LOW);
      SUBCOMANDO = 'S';
      break;
  }

}
