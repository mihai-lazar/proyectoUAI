import processing.serial.*;    
Serial arduinoPort;    
boolean found = false;
String connectedPort;

public void settings() {
  //size(1280, 800, P3D);
  fullScreen(P3D);
}

void setup() {
  
  connect_serial();
  
}

void draw(){ 
  
  boolean connected = false;
  for(String search : Serial.list()) {
    if (search.equals(connectedPort)) {
      connected = true;
    }
  }
  
  
  if(connected){          if (!initialized) {
        // Inicializamos, se ejecuta hasta que la inicializacion es exitosa
        init();
        
      } else {
        
        //Actualizamos los settings y valores para este frame
        listen();
        
        if(millis() > timer_grua){
          mover_grua();
        }
        
        //Renderizamos el frame actual
        background(#356172);
        render3D();
        render2D();
        
        
      }
  }

}
