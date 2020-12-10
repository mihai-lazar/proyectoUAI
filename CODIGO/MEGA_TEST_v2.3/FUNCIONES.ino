void test(){

  COMANDO = 'Z';
  SUBCOMANDO = '+';
  mover_electroiman();
  
}

void home(){
  
  while(digitalRead(X_MIN_PIN) != LOW)
    mover_stepper_x('-');
  while(digitalRead(Y_Y1_MIN_PIN) != LOW)
    mover_stepper_y('-');
  while(digitalRead(Z_MAX_PIN) != LOW){
    SUBCOMANDO = '+';
    mover_electroiman();
  }
}
