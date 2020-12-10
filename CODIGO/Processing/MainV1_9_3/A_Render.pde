void render3D() {
  
  // Update camera position settings for a number of frames after key updates
  //
  if (cam.moveTimer > 0) {
    cam.moved();
  }
  
  //Dibuja y calcula los graficos 3D
  hint(ENABLE_DEPTH_TEST);
  cam.on();
   
  //Dibujamos el plano
  fill(255, 50);
  rect(0, 0, B.x, B.y);
  
  //Dibujamos los cuadritos pequeños del plano
  pushMatrix(); translate(0, 0, 1);
  image(cam.chunkField.img, 0, 0, B.x, B.y);
  popMatrix();
  
  //Dobujamos el objeto que representa la grua
  Grua.drawMe();
  
  //Dibujamos todos los objetos que representan a container ocupados de la matriz
  if (cam.enableChunks) {  
    for(int x=0; x<3; x++){
      for(int y=0; y<6; y++){
        for(int z=0; z<3; z++){        
          if(Containers[x][y][z].ocupado){  
            Containers[x][y][z].drawMe();           
          }        
        }
      }
    }  
    
    for(int y=0; y<3; y++){
      if(Descarga[0][y].ocupado){  
        Descarga[0][y].drawMe();    
      }
    }
    
  }
  
  //Objeto Fantasma de container
  if (cam.enableChunks && cam.chunkField.closestFound) {   
    Container_Fantasma.chunk(cam.chunkField.closest);    
  } 
  
}

// Begin Drawing 2D Elements
//
void render2D() {
  
  hint(DISABLE_DEPTH_TEST);
  cam.off();
  
  // Diameter of Cursor Objects
  //
  
  // Arrow-Object: Draw Cursor Ellipse and Text
  //
  noFill(); stroke(#FFFF00, 200);
  //ellipse(s_x, s_y, diam, diam);
  fill(#FFFF00, 200); textAlign(LEFT, CENTER);
  //text("OBJECT: Move with Arrow Keys", s_x + 0.6*diam, s_y);
  
  // Draw Slider Bars for Controlling Zoom and Rotation (2D canvas begins)
  //
  cam.drawControls();
  
  // Draw Margin ToolBar
  //
  bar_left.draw();
}


void loadingScreen(int phase, int numPhases, String status) {

  // Place Loading Bar Background
  //

  pushMatrix(); 
  translate(width/2, height/2);
  int BAR_WIDTH  = 400;
  int BAR_HEIGHT =  48;
  int BAR_BORDER =  10;

  // Draw Loading Bar Outline
  //
  noStroke(); 
  fill(255, 200);
  rect(-BAR_WIDTH/2, -BAR_HEIGHT/2, BAR_WIDTH, BAR_HEIGHT, BAR_HEIGHT/2);
  noStroke(); 
  fill(0, 200);
  rect(-BAR_WIDTH/2+BAR_BORDER, -BAR_HEIGHT/2+BAR_BORDER, BAR_WIDTH-2*BAR_BORDER, BAR_HEIGHT-2*BAR_BORDER, BAR_HEIGHT/2);

  // Draw Loading Bar Fill
  //
  float percent = float(phase+1)/numPhases;
  noStroke(); 
  fill(255, 150);
  rect(-BAR_WIDTH/2 + BAR_HEIGHT/4, -BAR_HEIGHT/4, percent*(BAR_WIDTH - BAR_HEIGHT/2), BAR_HEIGHT/2, BAR_HEIGHT/4);

  // Draw Loading Bar Text
  //
  textAlign(CENTER, CENTER); 
  fill(255);
  text(status, 0, 0);

  popMatrix();
}

void clear_all(){
    for(int x=0; x<3; x++){
      for(int y=0; y<6; y++){
        for(int z=0; z<3; z++){        
          Containers[x][y][z].ocupado = false;   
        }        
      }
    }   
}
