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

int algoritmo = 1;

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
           
      if(algoritmo == 1){
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
      }else if(algoritmo == 2){
        for (int i = 0 ; i < lines.length - 1; i++) {
          int[][] container_1 = {{-1 , -1 , -1} , {-1 , -1 , -1}};
          int[][] container_2 = {{-1 , -1 , -1} , {-1 , -1 , -1}};
          if(Seq[i][1][0] == 3)
            Seq[i][1][0] = 4;
          if(Seq[i][0][0] != -1){
            for (int e = 0 ; e < lines.length - 1; e++) {
              if(Seq[i][0][0] == Seq[e][0][0] && Seq[i][0][1] == Seq[e][0][1] && Seq[i][0][2] != Seq[e][0][2]){
                if(Seq[e][1][0] == 3)
                  Seq[e][1][0] = 4;
                if(container_1[0][1]  == -1){
                  container_1[0][0] = Seq[e][0][0];
                  container_1[0][1] = Seq[e][0][1];
                  container_1[0][2] = Seq[e][0][2];
                  
                  container_1[1][0] = Seq[e][1][0];
                  container_1[1][1] = Seq[e][1][1];
                  container_1[1][2] = Seq[e][1][2];
                }else if(container_2[0][1]  == -1){
                  container_2[0][0] = Seq[e][0][0];
                  container_2[0][1] = Seq[e][0][1];
                  container_2[0][2] = Seq[e][0][2];
                  
                  container_2[1][0] = Seq[e][1][0];
                  container_2[1][1] = Seq[e][1][1];
                  container_2[1][2] = Seq[e][1][2];         
                }             
                Seq[e][0][0] = -1;
                Seq[e][0][1] = -1;
                Seq[e][0][2] = -1;
              }
            }
            
            print(Seq[i][0][2]);
            print(container_1[0][2]);
            println(container_2[0][2]);
            
            if(Seq[i][0][2] > container_1[0][2] && Seq[i][0][2] > container_2[0][2]){
              seq_Container.add(new Seq_Container(new PVector(Seq[i][1][0], Seq[i][1][1], Seq[i][1][2]), Containers[Seq[i][0][0]][Seq[i][0][1]][Seq[i][0][2]]));
                if(container_1[0][2] > container_2[0][2]){
                  seq_Container.add(new Seq_Container(new PVector(container_1[1][0], container_1[1][1], container_1[1][2]), Containers[container_1[0][0]][container_1[0][1]][container_1[0][2]]));
                  seq_Container.add(new Seq_Container(new PVector(container_2[1][0], container_2[1][1], container_2[1][2]), Containers[container_2[0][0]][container_2[0][1]][container_2[0][2]]));
                }else{
                  seq_Container.add(new Seq_Container(new PVector(container_2[1][0], container_2[1][1], container_2[1][2]), Containers[container_2[0][0]][container_2[0][1]][container_2[0][2]]));
                  seq_Container.add(new Seq_Container(new PVector(container_1[1][0], container_1[1][1], container_1[1][2]), Containers[container_1[0][0]][container_1[0][1]][container_1[0][2]]));
                }
            }else if(Seq[i][0][2] > container_1[0][2] && Seq[i][0][2] < container_2[0][2]){ 
              seq_Container.add(new Seq_Container(new PVector(container_2[1][0], container_2[1][1], container_2[1][2]), Containers[container_2[0][0]][container_2[0][0]][container_2[0][0]]));
              seq_Container.add(new Seq_Container(new PVector(Seq[i][1][0], Seq[i][1][1], Seq[i][1][2]), Containers[Seq[i][0][0]][Seq[i][0][1]][Seq[i][0][2]]));
              seq_Container.add(new Seq_Container(new PVector(container_1[1][0], container_1[1][1], container_1[1][2]), Containers[container_1[0][0]][container_1[0][1]][container_1[0][2]]));
            }else if(Seq[i][0][2] < container_1[0][2] && Seq[i][0][2] < container_2[0][2]){
              if(container_1[0][2] > container_2[0][2]){
                  seq_Container.add(new Seq_Container(new PVector(container_1[1][0], container_1[1][1], container_1[1][2]), Containers[container_1[0][0]][container_1[0][1]][container_1[0][2]]));
                  seq_Container.add(new Seq_Container(new PVector(container_2[1][0], container_2[1][1], container_2[1][2]), Containers[container_2[0][0]][container_2[0][1]][container_2[0][2]]));
                }else{
                  seq_Container.add(new Seq_Container(new PVector(container_2[1][0], container_2[1][1], container_2[1][2]), Containers[container_2[0][0]][container_2[0][1]][container_2[0][2]]));
                  seq_Container.add(new Seq_Container(new PVector(container_1[1][0], container_1[1][1], container_1[1][2]), Containers[container_1[0][0]][container_1[0][1]][container_1[0][2]]));
                }          
              seq_Container.add(new Seq_Container(new PVector(Seq[i][1][0], Seq[i][1][1], Seq[i][1][2]), Containers[Seq[i][0][0]][Seq[i][0][1]][Seq[i][0][2]]));
            }  
            Seq[i][0][0] = -1;
            Seq[i][0][1] = -1;
            Seq[i][0][2] = -1;     
          }
          
        }
        
        println(seq_Container.size());
        
        for(int z = 0 ; z < seq_Container.size() ; z++){
          print(seq_Container.get(z).container.pos_x);
          print(seq_Container.get(z).container.pos_y);
          print(seq_Container.get(z).container.pos_z);
          print("  ");
          println(seq_Container.get(z).mover_a);
  
        }
      }
      
      cant_movimientos = 0;
      
      mover(seq_Container.get(0).container, seq_Container.get(0).mover_a);
    
    }else{
      print("Archivo invalido");
    }
  }
}
