int velocidad = 5;

void mover_grua(){
  
  if(movimientos.size() > 0){
    moviendose = true;
    
    if(serial_activado)
      mover_grua_serial();
    else
      mover_grua_sin_serial();
      
    
  }else{
    moviendose = false;
  }
  timer_grua = millis() + 1;

  
}


void mover(Container container_a_mover, PVector lugar_donde_mover){
  
  if(container_a_mover.pos_z < 2){
      for(int i = 2; i > container_a_mover.pos_z ; i--){
        if(Containers[container_a_mover.pos_x][container_a_mover.pos_y][i].ocupado){
               PVector location = buscar_libre_cercano(Containers[container_a_mover.pos_x][container_a_mover.pos_y][i], lugar_donde_mover);
               if(location.x != -1){
                 mover(Containers[container_a_mover.pos_x][container_a_mover.pos_y][i], location);
               }else{
                 return;            
          }
       }
    }
  }
    for(int i = 0; i < 3; i++){
      if(lugar_donde_mover.x == 4){
        println(0);
        lugar_donde_mover.z = 0;
        Chunk c = cam.chunkField.selectionGrid[int(lugar_donde_mover.x - 1)][int(lugar_donde_mover.y)];
        PVector donde_mover_location = new PVector(c.location.x, c.location.y, 30 + lugar_donde_mover.z*60);
        
        Containers[container_a_mover.pos_x][container_a_mover.pos_y][container_a_mover.pos_z] = new Container(false);
        
        x_anterior = container_a_mover.pos_x;
        y_anterior = container_a_mover.pos_y;
        
        container_a_mover.pos_x = int(lugar_donde_mover.x);
        container_a_mover.pos_y = int(lugar_donde_mover.y);
        container_a_mover.pos_z = int(lugar_donde_mover.z);
        Descarga[0][container_a_mover.pos_y] = container_a_mover;
        
        container_a_mover.selecionado = true; 
        container_a_mover.moviendose = true;
        container_a_mover.ocupado = false;
        container_a_mover.a_ocupar = true;
        
        movimientos.add(new Movimiento(container_a_mover.location, donde_mover_location, container_a_mover));
        cant_movimientos++;
        break;
      }else if(Containers[int(lugar_donde_mover.x)][int(lugar_donde_mover.y)][i].ocupado == false && Containers[int(lugar_donde_mover.x)][int(lugar_donde_mover.y)][i].a_ocupar == false ){
        
        lugar_donde_mover.z = i;
        Chunk c = cam.chunkField.selectionGrid[int(lugar_donde_mover.x)][int(lugar_donde_mover.y)];
        PVector donde_mover_location = new PVector(c.location.x, c.location.y, 30 + lugar_donde_mover.z*60);
  
        Containers[container_a_mover.pos_x][container_a_mover.pos_y][container_a_mover.pos_z] = new Container(false);
    
        x_anterior = container_a_mover.pos_x;
        y_anterior = container_a_mover.pos_y;
        container_a_mover.pos_x = int(lugar_donde_mover.x);
        container_a_mover.pos_y = int(lugar_donde_mover.y);
        container_a_mover.pos_z = int(lugar_donde_mover.z);
        Containers[container_a_mover.pos_x][container_a_mover.pos_y][container_a_mover.pos_z] = container_a_mover;
        
        container_a_mover.moviendose = true;
        container_a_mover.ocupado = false;
        container_a_mover.a_ocupar = true;
        
        movimientos.add(new Movimiento(container_a_mover.location, donde_mover_location, container_a_mover));
        cant_movimientos++;
        break;
      }else if(i == 2){
        if(seq_Container.size() > 0){
          
          for(int e = 0; e < seq_Container.size() ; e++){
             if(seq_Container.get(e).container.pos_x == container_a_mover.pos_x && seq_Container.get(e).container.pos_y == container_a_mover.pos_y && seq_Container.get(e).container.pos_z == container_a_mover.pos_z)
               seq_Container.remove(e);
          }
          if(seq_Container.size() > 0){
            cant_movimientos = 0;
            mover(seq_Container.get(0).container, seq_Container.get(0).mover_a);
          }  
        }
      }
    }

              
}



PVector buscar_libre_cercano(Container container_donde_buscar, PVector lugar_donde_mover){
  
  //for(int i = 2; i > container_donde_buscar.pos_z ; i--){
   // for(int e = 0; e < seq_Container.size() ; e++){
  //    if(container_donde_buscar.pos_x == seq_Container.get(e).container.pos_x && seq_Container.get(e).container.pos_y == container_donde_buscar.pos_y && seq_Container.get(e).container.pos_z != i){
   //     println("AQUI");
   //     return new PVector(2, 1, 0); 
   //   }
   // }
  //}
  

  int busqueda_x = container_donde_buscar.pos_x;
  int busqueda_y = container_donde_buscar.pos_y;
  
  distancias = new PVector[3][6][3];
  distancias_sort = new ArrayList<PVector>();
  
      int x_menor = -1;
      int y_menor = -1;
      int z_menor = -1;
      int suma_menor = 100;
      int suma_temp;    
    
    for(int x = 0 ; x < 3; x++){
        for(int y = 0 ; y < 6; y++){
          if((y != busqueda_y || x != busqueda_x) && (y != lugar_donde_mover.y || x != lugar_donde_mover.x)){
            for(int z = 0 ; z < 3; z++){
              if(!Containers[x][y][z].ocupado && !Containers[x][y][z].a_ocupar){    
                distancias_sort.add(new PVector(abs(busqueda_x - x), abs(busqueda_y - y), 2 - z));
                distancias[x][y][z] = new PVector(abs(busqueda_x - x), abs(busqueda_y - y), 2 - z);
                
                suma_temp = abs(busqueda_x - x) + abs(busqueda_y - y) + 2 - z;
                if(suma_menor > suma_temp){
                  suma_menor = suma_temp;
                  x_menor = x;
                  y_menor = y;
                  z_menor = z;
                }
                break;
              }
            }    
          }
        }   
    }

  return new PVector(x_menor, y_menor, z_menor); 

}


void mover_grua_serial(){
    if(!movimientos.get(0).buscado){
      if(Grua.location.y > movimientos.get(0).mover_de.y){
        Grua.location.y--;
        arduinoPort.write("X" + str(x_anterior) + "\n"); 
      }else if(Grua.location.y < movimientos.get(0).mover_de.y){
        Grua.location.y++;
        arduinoPort.write("X" + str(x_anterior) + "\n"); 
      }else if(Grua.location.x > movimientos.get(0).mover_de.x){
        Grua.location.x--;
        arduinoPort.write("Y" + str(y_anterior) + "\n"); 
      }else if(Grua.location.x < movimientos.get(0).mover_de.x){
        Grua.location.x++;
        arduinoPort.write("Y" + str(y_anterior) + "\n"); 
      }else if(Grua.location.z > movimientos.get(0).mover_de.z + 30){
        Grua.location.z--;
        arduinoPort.write("Z-\n"); 
      }else if (estado_arduino.equals("Z-")){
        movimientos.get(0).buscado = true;
        movimientos.get(0).container.selecionado = false;
        arduinoPort.write("Z=\n"); 
      }
    }
    
    if(movimientos.get(0).buscado && movimientos.get(0).container.a_ocupar){
      if(Grua.location.z < 260 && !llego){
        Grua.location.z++;
        arduinoPort.write("Z+\n"); 
        movimientos.get(0).container.location.z++;
      }else if(estado_arduino.equals("Z+") && !llego){
        llego = true;
      }else if(Grua.location.y > movimientos.get(0).mover_a.y && llego){
        Grua.location.y--;
        estado = "X" + str(movimientos.get(0).container.pos_x);
        arduinoPort.write("X" + str(movimientos.get(0).container.pos_x) + "\n"); 
        movimientos.get(0).container.location.y--;
      }else if(Grua.location.y < movimientos.get(0).mover_a.y && llego){
        Grua.location.y++;
        estado = "X" + str(movimientos.get(0).container.pos_x);
        arduinoPort.write("X" + str(movimientos.get(0).container.pos_x) + "\n");  
        movimientos.get(0).container.location.y++;
      }else if(Grua.location.x > movimientos.get(0).mover_a.x && llego){
        Grua.location.x--;
        estado = "Y" + str(movimientos.get(0).container.pos_y);  
        arduinoPort.write("Y" + str(movimientos.get(0).container.pos_y) + "\n");  
        movimientos.get(0).container.location.x--;
      }else if(Grua.location.x < movimientos.get(0).mover_a.x && llego){
        Grua.location.x++;
        estado = "Y" + str(movimientos.get(0).container.pos_y);  
        arduinoPort.write("Y" + str(movimientos.get(0).container.pos_y) + "\n");  
        movimientos.get(0).container.location.x++;
      }else if(estado_arduino.equals(estado)){
        movimientos.get(0).container.a_ocupar = false;
        llego = false;
      }
    }
    
    if(!movimientos.get(0).container.a_ocupar && !movimientos.get(0).container.ocupado){
      if(Grua.location.z > movimientos.get(0).mover_a.z + 30){
        Grua.location.z--;
        arduinoPort.write("Z-\n"); 
        movimientos.get(0).container.location.z--;
      }else if(estado_arduino.equals("Z-")){
        movimientos.get(0).container.moviendose = false;
        movimientos.get(0).container.ocupado = true;
        arduinoPort.write("Z=\n");
      }
    }
    
    if(movimientos.get(0).container.ocupado && movimientos.get(0).buscado){
      if(Grua.location.z < 260){
        Grua.location.z++;
        arduinoPort.write("Z+\n"); 
      }else if(estado_arduino.equals("Z+")){     
        arduinoPort.write("S\n"); 
        if(seq_Container.size() > 0){
          if(seq_Container.get(0).container.location.equals(movimientos.get(0).mover_a)){
            seq_Container.remove(0);
            if(seq_Container.size() > 0){
              mover(seq_Container.get(0).container, seq_Container.get(0).mover_a);
            }          
          }
        }
        movimientos.remove(0); 
      }
    }  
}

void mover_grua_sin_serial(){
    if(!movimientos.get(0).buscado){
      if(Grua.location.y > movimientos.get(0).mover_de.y)
        if(Grua.location.y - velocidad < movimientos.get(0).mover_de.y)        
          Grua.location.y =  movimientos.get(0).mover_de.y;
        else
          Grua.location.y -= velocidad;
      else if(Grua.location.y < movimientos.get(0).mover_de.y)
        if(Grua.location.y + velocidad > movimientos.get(0).mover_de.y)        
          Grua.location.y = movimientos.get(0).mover_de.y ;
        else
          Grua.location.y += velocidad;
      else if(Grua.location.x > movimientos.get(0).mover_de.x)
        if(Grua.location.x - velocidad < movimientos.get(0).mover_de.x)        
          Grua.location.x = movimientos.get(0).mover_de.x;
        else
          Grua.location.x -= velocidad;
      else if(Grua.location.x < movimientos.get(0).mover_de.x)
        if(Grua.location.x + velocidad > movimientos.get(0).mover_de.x)        
          Grua.location.x =  movimientos.get(0).mover_de.x;
        else
          Grua.location.x += velocidad;
      else if(Grua.location.z > movimientos.get(0).mover_de.z + 30)
        if(Grua.location.z - velocidad < movimientos.get(0).mover_de.z + 30)        
          Grua.location.z = movimientos.get(0).mover_de.z + 30;
        else
          Grua.location.z -= velocidad;
      else{
        movimientos.get(0).buscado = true;
        movimientos.get(0).container.selecionado = false;
      }
    }
    
    if(movimientos.get(0).buscado && movimientos.get(0).container.a_ocupar){
      if(Grua.location.z < 260){      
        if(Grua.location.z + velocidad > 260){        
          Grua.location.z = 260;
          movimientos.get(0).container.location.z = 260;
        }else{
          Grua.location.z += velocidad;   
          movimientos.get(0).container.location.z += velocidad;
        }
      }else if(Grua.location.y > movimientos.get(0).mover_a.y){
        if(Grua.location.y - velocidad < movimientos.get(0).mover_a.y){   
          Grua.location.y = movimientos.get(0).mover_a.y;
          movimientos.get(0).container.location.y = movimientos.get(0).mover_a.y;
        }else{
          Grua.location.y -= velocidad;   
          movimientos.get(0).container.location.y -= velocidad;
        }
      }else if(Grua.location.y < movimientos.get(0).mover_a.y){
        if(Grua.location.y + velocidad > movimientos.get(0).mover_a.y){        
          Grua.location.y = movimientos.get(0).mover_a.y;  
          movimientos.get(0).container.location.y = movimientos.get(0).mover_a.y;
        }else{
          Grua.location.y += velocidad;   
          movimientos.get(0).container.location.y += velocidad;
        }
      }else if(Grua.location.x > movimientos.get(0).mover_a.x){
        if(Grua.location.x - velocidad < movimientos.get(0).mover_a.x){        
          Grua.location.x = movimientos.get(0).mover_a.x;
          movimientos.get(0).container.location.x = movimientos.get(0).mover_a.x;
        }else{
          Grua.location.x -= velocidad;   
          movimientos.get(0).container.location.x -= velocidad;
        }
      }else if(Grua.location.x < movimientos.get(0).mover_a.x){
        if(Grua.location.x + velocidad > movimientos.get(0).mover_a.x){        
          Grua.location.x = movimientos.get(0).mover_a.x;
          movimientos.get(0).container.location.x = movimientos.get(0).mover_a.x;
        }else{
          Grua.location.x += velocidad;   
          movimientos.get(0).container.location.x += velocidad;
        }
      }else{
        movimientos.get(0).container.a_ocupar = false;
      }
    }
    
    if(!movimientos.get(0).container.a_ocupar && !movimientos.get(0).container.ocupado){
      if(Grua.location.z > movimientos.get(0).mover_a.z + 30){
        if(Grua.location.z - velocidad < movimientos.get(0).mover_a.z + 30){        
          Grua.location.z = movimientos.get(0).mover_a.z + 30;
          movimientos.get(0).container.location.z = movimientos.get(0).mover_a.z;
        }else{
          Grua.location.z -= velocidad;
          movimientos.get(0).container.location.z -= velocidad;
        }        
      }else{
        movimientos.get(0).container.moviendose = false;
        movimientos.get(0).container.ocupado = true;
      }
    }
    
    if(movimientos.get(0).container.ocupado && movimientos.get(0).buscado){
      if(Grua.location.z < 260)
        if(Grua.location.z + velocidad > 260){        
          Grua.location.z = 260;
        }else{
          Grua.location.z += velocidad;   
        }
      else{
        movimientos.remove(0); 
        cant_movimientos--;
        println(cant_movimientos);
        if(seq_Container.size() > 0 && cant_movimientos == 0){
          println("ENTRO");
          seq_Container.remove(0);
          if(seq_Container.size() > 0){
            mover(seq_Container.get(0).container, seq_Container.get(0).mover_a);
          }          
        }  
      }
    }
}
