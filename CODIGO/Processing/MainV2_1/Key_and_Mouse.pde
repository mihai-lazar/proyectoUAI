int selecion_z = -1; int selecion_x; int selecion_y;
boolean first_selection = true;
boolean selected = false;
int global_fill = #FFFFFF;

void listen() {
  
  // screenX() and screenY() methods need 3D camera active
  //
  cam.on();
  
  // Arrow-Object: Calculate Object's Screen Location
  //
  s_x = screenX(Grua.location.x, Grua.location.y, Grua.location.z + 30/2.0);
  s_y = screenY(Grua.location.x, Grua.location.y, Grua.location.z + 30/2.0);
    
  // Trigger the button
  //
  if (bar_left.buttons.get(0).trigger) {
    println("Cargando Configuracion");
    selectInput("Select a file to process:", "fileSelectedInput");
    bar_left.buttons.get(0).trigger = false;
  }
  if (bar_left.buttons.get(1).trigger) {
    println("Guardando Configuracion");
    selectOutput("Select a file to write to:", "fileSelectedOutput");
    bar_left.buttons.get(1).trigger = false;
  }
  if (bar_left.buttons.get(2).trigger) {
    println("Cargando Secuencia");
    selectInput("Select a file to process:", "fileSelectedInputSeq");
    bar_left.buttons.get(2).trigger = false;
  }
  if (bar_left.buttons.get(3).trigger) {
    println("Cargando Secuencia");
    clear_all();
    bar_left.buttons.get(3).trigger = false;
  }
}

void mousePressed() { if (initialized) {
  
  cam.pressed();
  bar_left.pressed();
  
} }

void mouseClicked() { if (initialized) {
  
  if(!moviendose){
    if (cam.chunkField.closestFound && cam.enableChunks && !cam.hoverGUI()) {
  
      temp_x = cam.chunkField.closest.pos_x;
      temp_y = cam.chunkField.closest.pos_y;
      if (mouseButton == LEFT) {
        if(temp_x < 3){
          for(int z=0; z<3; z++){
          if(!Containers[temp_x][temp_y][z].ocupado){
            PVector location = new PVector(cam.chunkField.closest.location.x, cam.chunkField.closest.location.y, 0);
            location.z = 30 + z*60;
            if(!selected && movimientos.size() == 0){                       
              Containers[temp_x][temp_y][z] = new Container(temp_x, temp_y, z, location, global_fill, 1);
              Containers[temp_x][temp_y][z].ocupado = true;
              break;
            }else if(selected){
              if(selecion_x != temp_x || selecion_y != temp_y){

                
                mover(Containers[selecion_x][selecion_y][selecion_z], new PVector(temp_x, temp_y, z));
                print("MOVER " + str(selecion_x) + "," + str(selecion_y) + "," + str(selecion_z));
                println(" A " + str(temp_x) + "," + str(temp_y) + "," + str(z));              
                
                selecion_z = -1;
                selected = false;
                println("desselecionado");
                break;
              } 
            }
          }
          
        }     
      }else{  
         if(selected && !Descarga[0][temp_y].ocupado){ 
              PVector location = new PVector(cam.chunkField.closest.location.x, cam.chunkField.closest.location.y, 30);
              if(selecion_x != temp_x || selecion_y != temp_y){
                Containers[selecion_x][selecion_y][selecion_z].ocupado = false;
    
                Descarga[0][temp_y] = new Container(temp_x, temp_y, 0, location, Containers[selecion_x][selecion_y][selecion_z].fill, 1);
                Descarga[0][temp_y].ocupado = true;
                print("MOVER " + str(selecion_x) + "," + str(selecion_y) + "," + str(selecion_z));
                println(" A " + str(temp_x) + "," + str(temp_y) + "," + str(0));
                
                Containers[selecion_x][selecion_y][selecion_z].selecionado = false;
                selecion_z = -1;
                selected = false;
                println("desselecionado");
              } 
         }
      }
    }else if (mouseButton == RIGHT) {
        if(temp_x < 3 && movimientos.size() == 0){
           for(int i=2; i>=0; i--){
             if(Containers[temp_x][temp_y][i].ocupado){
              Containers[temp_x][temp_y][i].ocupado = false;
              if(Containers[temp_x][temp_y][i].selecionado){
                Containers[temp_x][temp_y][i].selecionado = false;
                selecion_z = -1;
                selected = false;
                println("desselecionado");
              }            
              break;
            }else{
      
            }
            
           }
        }
    }else if (mouseButton == CENTER) {
        //if(movimientos.size() == 0){
          selecion_z++;
          if(first_selection){
            selecion_x = temp_x;
            selecion_y = temp_y;
            first_selection = false;
          }       
          
          if(selecion_z < 3){
            if((selecion_x == temp_x && selecion_y == temp_y || selecion_z == 0) && Containers[temp_x][temp_y][selecion_z].ocupado == true){
              selected = true;
              println("selecionado");
              Containers[temp_x][temp_y][selecion_z].selecionado = true; 
              if(selecion_z > 0)
                Containers[temp_x][temp_y][selecion_z-1].selecionado = false;             
            }else{
              if(selecion_z > 0)
                selecion_z -= 1;
              Containers[selecion_x][selecion_y][selecion_z].selecionado = false; 
              selecion_z = -1;
              selected = false;
              println("desselecionado");
            }
            selecion_x = temp_x;
            selecion_y = temp_y;
    
          }else{
            Containers[selecion_x][selecion_y][selecion_z-1].selecionado = false; 
            selecion_x = temp_x;
            selecion_y = temp_y;
            selecion_z = -1;
            selected = false;
            println("desselecionado");
          }
    
        //}
      }
  
    }
  }
}}

void mouseReleased() { if (initialized) {
  
  bar_left.released();
  cam.moved();
  
} }

void mouseMoved() { if (initialized) {
  
  cam.moved();
  
} }

void keyPressed() { if (initialized) {
    
  cam.moved();
  bar_left.pressed();
  
  switch(key) {
    case 'f':
      cam.showFrameRate = !cam.showFrameRate;
      break;
    case 'c':
      cam.reset();
      break;
    case 'r':
      //Containers.clear();
      bar_left.restoreDefault();
      break;
    case 'p':
      println("cam.offset.x = " + cam.offset.x);
      println("cam.offset.x = " + cam.offset.x);
      println("cam.zoom = "     + cam.zoom);
      println("cam.rotation = " + cam.rotation);
      break;
    case '-':
      Grua.location.z -= 20;
      break;
    case '+':
      Grua.location.z += 20;
      break;
    case '!':
      print('!');
      break;
  }
  
  if (key == CODED) {
    if (keyCode == UP) {
      Grua.location.y -= 20;
    } else if (keyCode == DOWN) {
      Grua.location.y += 20;
    } else if (keyCode == LEFT) {
      Grua.location.x -= 20;
    } else if (keyCode == RIGHT) {
      Grua.location.x += 20;
    } 
  }
  
} }

void keyReleased() { if (initialized) {
    
    bar_left.released();
  
} }
