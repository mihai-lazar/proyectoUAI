void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    String[] lines = loadStrings(selection.getAbsolutePath());
    println("there are " + lines.length + " lines");
    if(trim(lines[0]).equals("###CONF")){

      for (int i = 1 ; i < lines.length; i++) {
        String[] dato = trim(lines[i]).split(",");
        Chunk c;
        for (int e=0; e<cam.chunkField.selectionGrid.size(); e++) {
          c = cam.chunkField.selectionGrid.get(e);
          String fill;
          if(c.pos_x == int(dato[0]) && c.pos_y == int(dato[1])){
            PVector location = new PVector(c.location.x, c.location.y, 30 + int(dato[2])*60);
            fill = "FF" + dato[3].substring(1);
            Containers[int(dato[0])][int(dato[1])][int(dato[2])] = new Container(int(dato[0]), int(dato[1]), int(dato[2]), location, unhex(fill), 1);
            Containers[int(dato[0])][int(dato[1])][int(dato[2])].ocupado = true;
           break;
          }
        }

      }
      

                            
    for(int x=0; x<3; x++){
      for(int y=0; y<6; y++){
        for(int z=1; z<3; z++){        
          if(Containers[x][y][z].ocupado && !Containers[x][y][z-1].ocupado){ 
            Containers[x][y][z].fill = #F43B3B;
            print("Archivo con datos invalidos");
          }        
        }
      }
    }
    
    }else{
      print("Archivo invalido");
    }
  }
}
