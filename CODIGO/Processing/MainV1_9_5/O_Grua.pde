class Container{
  int pos_x, pos_y, pos_z;
  PVector location;
  int fill;
  int codigo;
  boolean ocupado;
  boolean selecionado;
  
  Container(int pos_x, int pos_y, int pos_z, PVector location, int fill, int codigo) {
    this.pos_x = pos_x;
    this.pos_y = pos_y;
    this.pos_z = pos_z;
    this.location = location;
    this.fill = fill;
    this.codigo = codigo;
  }
  
  
  Container(boolean ocupado) {
    this.ocupado = ocupado;
  }
  
  void drawMe() {
    pushMatrix();
      translate(location.x, location.y, location.z);
      if(pos_z == 0){
        if(selecionado)
          fill(#0002FF, 100); 
        else
          fill(fill, 300-50*pos_z); 
      }else if(pos_z == 1){
        if(selecionado)
          fill(#0002FF, 100); 
        else
          fill(fill, 300-50*pos_z); 
      }else if(pos_z == 2){
        if(selecionado)
          fill(#0002FF, 100); 
        else
          fill(fill, 300-50*pos_z); 
      }
      noStroke();
      box(58.8, 147.45, 59.575);
      popMatrix();  
  }
  
}

class Container_Fantasma{
  int x, y, z;
  float pos_x, pos_y;
  PVector location;
  int fill;
  int codigo;
  boolean ocupado;
  boolean selecionado;
  
  void chunk(Chunk chunk) {
    this.x = chunk.pos_x;
    this.y = chunk.pos_y;
    this.pos_x = chunk.location.x;
    this.pos_y = chunk.location.y;
    
    this.drawMe();
  }
  
void drawMe() {
    boolean z_selecionado = false;
    if(x < 3){
      for(int i=0; i<3; i++){
        if(Containers[x][y][i].selecionado)
          z_selecionado = true;
      }
      
        for(int i=2; i>=0; i--){
          if(Containers[x][y][i].ocupado && !z_selecionado){
            if(i == 2){
              pushMatrix(); translate(pos_x, pos_y, 59.575*(i+1)+1);
              fill(#F43B3B, 200); noStroke();
              box(58.8, 147.45, 1);
              popMatrix();
            }else{
              pushMatrix(); translate(pos_x, pos_y, 49.575/2 + 59.575*(i+1));
              if(selected)
                fill(#0002FF, 100); 
              else
                fill(#5CFB68, 200); noStroke();
              box(48.8, 137.45, 49.575);
              popMatrix();
            }
            break;
          }else if(i == 0){
            pushMatrix(); translate(pos_x, pos_y, 49.575/2);
            if(selected)
              fill(#0002FF, 100); 
            else
              fill(#5CFB68, 200); noStroke();
            box(48.8, 137.45, 49.575);
            popMatrix();     
    
         }
       } 
    }else{
      if(selected){
        pushMatrix(); translate(pos_x, pos_y, 49.575/2);
        fill(#0002FF, 100); 
        box(48.8, 137.45, 49.575);
        popMatrix();   
      }
    }
  }
  
}

class Grua{
  int pos_x, pos_y, pos_z;
  PVector location;
  PVector mover_a;
  int fill;
  int codigo;
  boolean ocupado;
  boolean selecionado;
  
  Grua(int pos_x, int pos_y, int pos_z, PVector location, int fill, int codigo) {
    this.pos_x = pos_x;
    this.pos_y = pos_y;
    this.pos_z = pos_z;
    this.location = location;
    this.mover_a = location;
    this.fill = fill;
    this.codigo = codigo;
  }
  
  Grua(PVector location) {
    this.location = location;
    this.mover_a = new PVector(location.x, location.y, location.z);
  }
  
  Grua(boolean ocupado) {
    this.ocupado = ocupado;
  }
  
  void drawMe() {
    pushMatrix(); 
    translate(location.x, location.y, location.z + 30/2.0);
    fill(255, 150); 
    noStroke(); 
    strokeWeight(1);
    box(objectSize, objectSize, objectSize);
    popMatrix();
  }
  
}

class Movimiento{
  PVector mover_de;
  PVector mover_a; 
  
  boolean buscado = false;
  
  Movimiento(PVector mover_de, PVector mover_a) {
    this.mover_de = mover_de;
    this.mover_a = mover_a;
  }
  
  Movimiento(PVector mover_a) {
    this.mover_a = mover_a;
  }
  
    Movimiento() {
  }
}
