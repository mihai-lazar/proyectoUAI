

// Objeto de la camara con sus opciones de control
Camera cam;
PVector B; // Espacio de la caja del ambiente
int MARGIN; // Margen en pixeles alrededor de la pantalla

// Barra semi transdparente lateral para controles
Toolbar bar_left;
int BAR_X, BAR_Y, BAR_W, BAR_H;
boolean showGUI;

// Objecto que representa la ubicacion de la Grua
PVector objectLocation; 
int objectSize = 30;
float s_x, s_y;

// Objetis container agregados con el mouse o cargados de una configuracion
Container[][][] Containers;
boolean placeAdditions;
float cursor_x, cursor_y;
PVector additionLocation;

// Contenedores de Font de Processing
PFont f12, f18, f24;

// Contador para ver estado de la inicializacion
boolean initialized;
int initPhase = 0;
int phaseDelay = 0;
String status[] = {
  "Iniciando Canvas ...",
  "Cargando Datos ...",
  "Iniciando Ambiente 3D ...",
  "Listo!"
};
int NUM_PHASES = status.length;

void init() {
  
  initialized = false;
    
  if (initPhase == 0) {
    
    // Load default background image
    //
    
    // Set Fonts
    //
    f12 = createFont("Helvetica", 12);
    f18 = createFont("Helvetica", 18);
    f24 = createFont("Helvetica", 24);
    textFont(f12);
    
    // Create canvas for drawing everything to earth surface
    //
    B = new PVector(500, 750, 0);
    MARGIN = 25;
    
  } else if (initPhase == 1) {
    
    // Init Data / Sample 3D objects to manipulate
    //
    objectLocation = new PVector(objectSize/2, objectSize/2, 260);
    Containers = new Container[3][6][3];
    
    for(int x=0; x<3; x++){
      for(int y=0; y<6; y++){
        for(int z=0; z<3; z++){
         Containers[x][y][z] = new Container(false);
        }
      }
    }
    
    placeAdditions = true;
    
  } else if (initPhase == 2) {
    
    // Initialize GUI3D
    //
    showGUI = true;
    initToolbars();
    initCamera();
    
  } else if (initPhase == 3) {
    
    initialized = true;
  }
  
  loadingScreen(loadingBG, initPhase, NUM_PHASES, status[initPhase]);
  if (!initialized) initPhase++; 
  delay(phaseDelay);

}

void initCamera() {
  
  // Initialize 3D World Camera Defaults
  //
  cam = new Camera (B, MARGIN);
  cam.init(); // Must End with init() if any BASIC variables within Camera() are changed from default
  
  // Add non-camera UI blockers and edit camera UI characteristics AFTER cam.init()
  //
  //cam.vs.xpos = width - 3*MARGIN - BAR_W;
  //cam.hs.enable = false; //disable rotation
  cam.drag.addBlocker(MARGIN, MARGIN, BAR_W, BAR_H);
  cam.drag.addBlocker(width - MARGIN - BAR_W, MARGIN, BAR_W, BAR_H);
  
  // Turn cam off while still initializing
  //
  cam.off();  
}

void initToolbars() {
  
  // Initialize Toolbar
  BAR_X = MARGIN;
  BAR_Y = MARGIN;
  BAR_W = 250;
  BAR_H = 800 - 2*MARGIN;
  
  // Left Toolbar
  bar_left = new Toolbar(BAR_X, BAR_Y, BAR_W, BAR_H, MARGIN);
  bar_left.title = "";
  bar_left.credit = "(Right-hand Toolbar)\n\n";
  bar_left.explanation = "Framework for explorable 3D model parameterized with sliders, radio buttons, and 3D Cursor. ";
  bar_left.explanation += "\n\nPress ' r ' to reset all inputs\nPress ' p ' to print camera settings\nPress ' a ' to add add objects\nPress ' h ' to hide GUI";
  bar_left.controlY = BAR_Y + bar_left.margin + 6*bar_left.CONTROL_H;
  bar_left.addRadio("Button A", 200, true, '!', false);
  bar_left.addRadio("Button B", 200, true, '@', false);
  bar_left.addRadio("Button C", 200, true, '#', false);
  bar_left.addRadio("Button D", 200, true, '$', false);
  bar_left.addRadio("Button E", 200, true, '%', false);
  bar_left.addSlider("SPACER",   "kg", 50, 100, 72, 1, '<', '>', false);
  bar_left.addSlider("Slider 1", "kg", 50, 100, 72, 1, '<', '>', false);
  bar_left.addSlider("Slider 2", "kg", 50, 100, 72, 1, '<', '>', false);
  bar_left.addSlider("Slider 3", "kg", 50, 100, 72, 1, '<', '>', false);
  bar_left.addSlider("Slider 4", "kg", 50, 100, 72, 1, '<', '>', false);
  bar_left.addSlider("Slider 5", "kg", 50, 100, 72, 1, '<', '>', false);
  bar_left.addSlider("Slider 6", "kg", 50, 100, 72, 1, '<', '>', false);
  bar_left.addSlider("Slider 7", "kg", 50, 100, 72, 1, '<', '>', false);
  bar_left.addButton("Button 1", #009900, 'b', true);
  bar_left.sliders.remove(0);
}

// Converts latitude, longitude to local friendly screen units (2D or 3D)
PVector latlonToXY(PVector latlon, float latMin, float latMax, float lonMin, float lonMax, float xMin, float yMin, float xMax, float yMax) {
  float X_Width = xMax - xMin;
  float Y_Width = yMax - yMin;
  float lat_scaler = (latlon.x - latMin) / abs(latMax - latMin);
  float lon_scaler = (latlon.y - lonMin) / abs(lonMax - lonMin);
  float X  = xMin + X_Width * lon_scaler;
  float Y  = yMin - Y_Width * lat_scaler + Y_Width;
  return new PVector(X,Y);
}
