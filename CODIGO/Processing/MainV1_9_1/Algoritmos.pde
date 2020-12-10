void mover(Container container_a_mover, PVector lucar_donde_mover){
  
  container_a_mover.ocupado = false;
  container_a_mover.selecionado = false;
    
  Containers[int(lucar_donde_mover.x)][int(lucar_donde_mover.y)][int(lucar_donde_mover.z)] = new Container(int(lucar_donde_mover.x), int(lucar_donde_mover.y), int(lucar_donde_mover.z), lucar_donde_mover, container_a_mover.fill, 1);
  Containers[int(lucar_donde_mover.x)][int(lucar_donde_mover.y)][int(lucar_donde_mover.z)].ocupado = true;
              
  print("MOVER AUTOMATICO " + str(selecion_x) + "," + str(selecion_y) + "," + str(selecion_z));
  //println(" A " + str(temp_x) + "," + str(temp_y) + "," + str(z));              
              
  //selecion_z = -1;
  //selected = false;
  //break;  
  
  
}



PVector buscar_libre_cercano(Container container_donde_buscar){
  
  int busqueda_x = container_donde_buscar.pos_x;
  int busqueda_y = container_donde_buscar.pos_y;
  
  int x_positivo = busqueda_x;
  int x_negativo = busqueda_x;
  
  int y_positivo = busqueda_y;
  int y_negativo = busqueda_y;
  
  if(x_negativo > 0)
      x_negativo--;
  if(x_positivo < 2)
      x_positivo++;
  if(y_negativo > 0)
      y_negativo--;
  if(y_positivo < 5)
      y_positivo++;
  
  int lugares_por_revisar = 54;
  distancias = new ArrayList<PVector>();
  while(lugares_por_revisar > 0){
    
    for(int x = x_negativo; x <= x_positivo ; x++){
      if(x == x_negativo || x == x_positivo){
        for(int y = y_negativo; y <= y_positivo ; y++){
          if(x != busqueda_x || y != busqueda_y){
            for(int z = 0 ; z < 3; z++){
              if(!Containers[x][y][z].ocupado){           
                distancias.add(new PVector(abs(busqueda_x - x), abs(busqueda_y - y), z));
              }
              lugares_por_revisar--;
            }
          }
        }
      }else{
        for(int y = y_negativo; y <= y_positivo; y++){
          if(y == y_negativo || y == y_positivo){
            for(int z = 0 ; z < 3; z++){        
              if(!Containers[x][y][z].ocupado){
                distancias.add(new PVector(abs(busqueda_x - x), abs(busqueda_y - y), z));
              }
              lugares_por_revisar--; 
            }
          }
        }
      }
    }
    
    if(distancias.size() > 0){
      
      printArray(distancias);
      println();
 
      Collections.sort(distancias, VEC_CMP);
      printArray(distancias);
      println();
      println(lugares_por_revisar);
      return distancias.get(0);
      
    }
    
         
    if(x_negativo > 0)
      x_negativo--;
    if(x_positivo < 2)
      x_positivo++;
    if(y_negativo > 0)
      y_negativo--;
    if(y_positivo < 5)
      y_positivo++;
  }
  
  PVector location = new PVector(-1, -1, -1);
  print(location);
  return location;

}


static final Comparator<PVector> VEC_CMP = new Comparator<PVector>() {
  @ Override final int compare(final PVector a, final PVector b) {
    int cmp;
    return
      (cmp = Float.compare(a.x, b.x)) != 0? cmp :
      (cmp = Float.compare(a.y, b.y)) != 0? cmp :
      Float.compare(a.z, b.z);
  }
};
