class Chunk {
  PVector location; // location of chunk
  float size; // cube size of chunk
  float s_x, s_y; // screen location of chunk
  int pos_x, pos_y;
  boolean hover;
  
  Chunk(PVector location, float size, int pos_x, int pos_y) {
    this.location = location;
    this.size = size;
    this.pos_x = pos_x;
    this.pos_y = pos_y;
    hover = false;
  }
  
  void setScreen() {
    s_x = screenX(location.x, location.y, location.z);
    s_y = screenY(location.x, location.y, location.z);
  }
}

// Grid of Chunks for discretely continuous spatial selection
//
class ChunkGrid {
  int resolution, tolerance;
  float chunkU, chunkV;
  ArrayList<Chunk> selectionGrid;
  Chunk closest;
  boolean closestFound;
  
  // number of pixels within range to select
  int TOLERANCE = 40;
    
  PGraphics img;
  
  // Extent of Clickability
  int extentX;
  int extentY;
  int extentW;
  int extentH;
  
  ChunkGrid(PVector boundary, int resolution, int eX, int eY, int eW, int eH) {
    this.resolution = resolution;
    
    Chunk chunk; PVector chunkLocation;
    selectionGrid = new ArrayList<Chunk>();
    chunkU  = boundary.x / resolution;
    chunkV  = boundary.y / resolution;
    for(int u=0; u<6; u++) {
      for(int v=0; v<3; v++) {
        chunkLocation = new PVector(u + 0.625, 2*v + 1.25);
        chunkLocation.mult(80);
        chunk = new Chunk(chunkLocation, resolution, v, u);
        selectionGrid.add(chunk);
      }
    }
    for(int i= 0; i<3; i++){
      chunkLocation = new PVector(150 + i*100, 600);
      chunkLocation.mult(1);
      chunk = new Chunk(chunkLocation, resolution, 4, i);
      selectionGrid.add(chunk);
    }

    
    closestFound = false;
    
    extentX = eX;
    extentY = eY;
    extentW = eW;
    extentH = eH;
    
    drawGrid();
  }
  
  // Returns the location of chunk closest to user's mouse position
  //
  void checkChunks(int mouseX, int mouseY) {
    closestFound = false;
    
    // Updates Screenlocation for all chunks
    for (Chunk chunk: selectionGrid) chunk.setScreen();
    
    // Discovers closest chunk to mouse
    PVector mouse = new PVector(mouseX, mouseY);
    Chunk c; PVector c_location; int c_index = -1;
    float dist = Float.POSITIVE_INFINITY;
    for (int i=0; i<selectionGrid.size(); i++) {
      c = selectionGrid.get(i);
      c.hover = false;
      c_location = new PVector(c.s_x, c.s_y);
      if (mouse.dist(c_location) < dist && mouse.dist(c_location) < TOLERANCE) {
        dist = mouse.dist(c_location);
        c_index = i;
      }
    }
    
    // Retrieve and store closest chunk found
    if (mouseX > extentX && mouseX < extentX+extentW && mouseY > extentY && mouseY < extentY+extentH) {
      if (c_index >= 0) {
        closestFound = true;
        closest = selectionGrid.get(c_index);
        closest.hover = true;
      }
    }
  }
  
  // Draw PGraphic with Selection Grid 
  void drawGrid() {
    int w = int(chunkU*resolution);
    int h = int(chunkV*resolution);
    img = createGraphics(w, h);
    img.beginDraw(); img.clear();
    for (Chunk c: selectionGrid) {
      img.stroke(0, 255); img.noFill();
      img.rect(c.location.x-c.size/2, c.location.y-c.size/2, c.size, c.size);
    }
    img.endDraw();
  }
  
  void drawCursor() {
    if (closestFound) {
      pushMatrix(); translate(closest.location.x, closest.location.y, closest.location.z + closest.size/2);
      stroke(#FFFF00, 255); strokeWeight(1); noFill();
      box(closest.size, closest.size, closest.size);
      popMatrix();
    }
  }
}
