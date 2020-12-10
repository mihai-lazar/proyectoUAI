public void settings() {
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
    if (showGUI) listen();
    
    //Renderizamos el frame actual
    background(0);
    render3D();
    if (showGUI) render2D();
  }
}
