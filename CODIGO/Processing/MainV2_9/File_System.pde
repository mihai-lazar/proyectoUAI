void fileSelectedInput(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    String[] lines = loadStrings(selection.getAbsolutePath());
    println("there are " + lines.length + " lines");
    if(trim(lines[0]).equals("###CONF")){
      clear_all();
      for (int i = 1 ; i < lines.length; i++) {
        String[] dato = trim(lines[i]).split(",");
        Chunk c;        
        for(int x = 0 ; x < 4 ; x++){
          for(int y = 0 ; y < 6 ; y++){
            c = cam.chunkField.selectionGrid[x][y];
            if(c != null){
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

void fileSelectedOutput(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String currentFile;
    String input = "";
    println("User selected " + selection.getAbsolutePath());
    // Do we have a txt at the end? 
    if (selection.getName().length() < 4 || selection.getName().indexOf(".txt") != selection.getName().length()-4 ) {
      // problem missing ".txt"
      currentFile = selection.getAbsolutePath()+".txt"; // very rough approach...
    } else {
      currentFile = selection.getAbsolutePath();
    }
    
    String[] lines = new String[0];
    lines = append (lines, "###CONF");
    for(int x=0; x<3; x++){
      for(int y=0; y<6; y++){
        for(int z=0; z<3; z++){
          if(Containers[x][y][z].ocupado){
            input = str(x) + "," + str(y) + "," + str(z) + "," + hex(Containers[x][y][z].fill);
            lines = append (lines, input);
          }
        }
      }
    }
    saveStrings( currentFile, lines); 
    
  }
}

void fileSelectedInputSeq(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    String[] lines = loadStrings(selection.getAbsolutePath());
    println("there are " + lines.length + " lines");
    if(trim(lines[0]).equals("###SEQ")){
      
      Seq = new int[lines.length][2][3];
      for (int i = 1 ; i < lines.length; i++) {
        String[] dato = trim(lines[i]).split("-");       
        Seq[i-1][0] = int(dato[0].split(","));
        Seq[i-1][1] = int(dato[1].split(","));
      }
      
      for (int i = 0 ; i < lines.length - 1; i++) {
        print(Seq[i][0][0]);
        print(Seq[i][0][1]);
        print(Seq[i][0][2]);
        print(" ");
        print(Seq[i][1][0]);
        print(Seq[i][1][1]);
        println(Seq[i][1][2]);
        if(Seq[i][1][0] == 3)
          Seq[i][1][0] = 4;
        seq_Container.add(new Seq_Container(new PVector(Seq[i][1][0], Seq[i][1][1], Seq[i][1][2]), Containers[Seq[i][0][0]][Seq[i][0][1]][Seq[i][0][2]]));
      }
      cant_movimientos = -2;
      
      /*ArrayList<Seq_Container> seq_Containe_newOrder = new ArrayList<Seq_Container>();
      int largo = seq_Container.size();
      for(int i = 0; i < seq_Container.size() ; i++){
        for(int e = 0 ; e < seq_Container.size() ; e++){
          if(seq_Container.get(i).container.pos_x == seq_Container.get(e).container.pos_x && seq_Container.get(i).container.pos_y == seq_Container.get(e).container.pos_y && seq_Container.get(i).container.pos_z != seq_Container.get(e).container.pos_z){
            
          }           
        }
        
      }*/
      
      mover(seq_Container.get(0).container, seq_Container.get(0).mover_a);
    
    }else{
      print("Archivo invalido");
    }
  }
}
