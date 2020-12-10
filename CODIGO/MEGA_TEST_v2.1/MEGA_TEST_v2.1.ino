#define X_STEP_PIN 54
#define X_DIR_PIN 55
#define X_ENABLE_PIN 38
#define X_MIN_PIN 3
#define X_MAX_PIN 2

#define Y_STEP_PIN 60
#define Y_DIR_PIN 61
#define Y_ENABLE_PIN 56
#define Y1_STEP_PIN 46
#define Y1_DIR_PIN 48
#define Y1_ENABLE_PIN 62
#define Y_Y1_MIN_PIN 14
#define Y_Y1_MAX_PIN 15

#define DELAY_STEPPERS 550

#define Z_STEP_PIN 36
#define Z_DIR_PIN 34
#define Z_ENABLE_PIN 30
#define Z_MIN_PIN 18
#define Z_MAX_PIN 19
#define ELECTRO_IMAN 10

#define DELAY_ELECTROIMAN 900


unsigned long timer_e = 0;

String serial_buffer; // Data received from the serial port
char COMANDO;
char SUBCOMANDO;

void setup() {
  
  Serial.begin(9600); 
  Serial.setTimeout(100);

  pinMode(X_STEP_PIN , OUTPUT);
  pinMode(X_DIR_PIN , OUTPUT);
  pinMode(X_ENABLE_PIN , OUTPUT);
  
  pinMode(Y_STEP_PIN , OUTPUT);
  pinMode(Y_DIR_PIN , OUTPUT);
  pinMode(Y_ENABLE_PIN , OUTPUT);
  pinMode(Y1_STEP_PIN , OUTPUT);
  pinMode(Y1_DIR_PIN , OUTPUT);
  pinMode(Y1_ENABLE_PIN , OUTPUT);

  pinMode(Z_STEP_PIN , OUTPUT);
  pinMode(Z_DIR_PIN , OUTPUT);
  pinMode(Z_ENABLE_PIN , OUTPUT);
  pinMode(Z_MIN_PIN , INPUT);
  pinMode(ELECTRO_IMAN , OUTPUT);
 
  digitalWrite(X_ENABLE_PIN , LOW);
  digitalWrite(Y_ENABLE_PIN , LOW);
  digitalWrite(Y1_ENABLE_PIN , LOW);
  digitalWrite(Z_ENABLE_PIN , LOW);
  digitalWrite(ELECTRO_IMAN , LOW);
  
}

void loop ()
{

  switch (COMANDO) {
    case 'X':
      mover_eje_x();
      break;
    case 'Y':
      mover_eje_y();
      break;
    case 'Z':
      mover_electroiman();
      break;
  }

}
