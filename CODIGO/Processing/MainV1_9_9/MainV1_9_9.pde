public void settings() {
  //size(1280, 800, P3D);
  fullScreen(P3D);
}

void setup() {
  
}

void draw() {
  if (!initialized) {
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
