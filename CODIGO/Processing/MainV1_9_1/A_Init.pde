

// Objeto de la camara con sus opciones de control
Camera cam;
PVector B;  // Espacio de la caja del ambiente
int MARGIN; // Margen en pixeles alrededor de la pantalla

// Barra semi transdparente lateral para controles
Toolbar bar_left;
int BAR_X, BAR_Y, BAR_W, BAR_H;
boolean showGUI;

// Objecto que representa la ubicacion de la Grua
Grua Grua;
int objectSize = 30;
float s_x, s_y;

// Objetis container agregados con el mouse o cargados de una configuracion
Container[][][] Containers;
Container[][] Descarga;
float cursor_x, cursor_y;

Container_Fantasma Container_Fantasma;

int[][][] Seq;

// Contenedores de Font de Processing
PFont f12, f18, f24;

ArrayList<PVector> distancias;
import java.util.List;
import java.util.Collections;
import java.util.Comparator;

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

    // Set Fonts
    //
    f12 = createFont("Helvetica", 12);
    f18 = createFont("Helvetica", 18);
    f24 = createFont("Helvetica", 24);
    textFont(f12);

    // Creamos la superficien del grid
    //
    B = new PVector(500, 750, 0);
    MARGIN = 25;
  } else if (initPhase == 1) {

    // Iniciamos la matriz de containers y el objeto que representa la grua
    Grua = new Grua(new PVector(objectSize/2, objectSize/2, 260));
    Containers = new Container[3][6][3];
    Descarga = new Container[1][3];
    Container_Fantasma = new Container_Fantasma();

    for (int x=0; x<3; x++) {
      Descarga[0][x] = new Container(false);
      for (int y=0; y<6; y++) {
        for (int z=0; z<3; z++) {
          Containers[x][y][z] = new Container(false);
        }
      }
    }
  } else if (initPhase == 2) {

    // Iniciamos la GUI
    initToolbars();
    initCamera();
  } else if (initPhase == 3) {

    if (bar_left.radios.size()   > 0)
      for (RadioButton   b : bar_left.radios  ) 
        if (b.name == "BLANCO")
          b.value = !b.value;

    initialized = true;
  }

  loadingScreen(initPhase, NUM_PHASES, status[initPhase]);
  if (!initialized) initPhase++; 
  delay(phaseDelay);
}

void initCamera() {

  // Iniciamos la camara 3D
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
  bar_left.title = "SIMULADOR PORTUARIO\n";
  bar_left.credit = "by Mihai Lazar\n\n";
  bar_left.explanation = "";
  bar_left.controlY = BAR_Y + bar_left.margin + 2*bar_left.CONTROL_H;
  bar_left.addRadio("BLANCO", 200, true, '!', false, #FFFFFF);
  bar_left.addRadio("NARANJO", 200, true, '@', false, #FF7600);
  bar_left.addRadio("NEGRO", 200, true, '#', false, #000000);
  bar_left.addRadio("GRIS", 200, true, '$', false, #BABABA);
  bar_left.addSlider("SPACER", "kg", 50, 100, 72, 1, '<', '>', false);
  bar_left.addButton("CARGAR", #009900, 'b', false);
  bar_left.addButton("GUARDAR", #009900, 'b', false);
  bar_left.addButton("SECUENCIA", #009900, 'b', false);
  bar_left.addButton("RESET", #009900, 'b', false);
  bar_left.sliders.remove(0);
}
