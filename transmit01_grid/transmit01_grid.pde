void setup(){
  size(500,500,P3D);
}
void draw(){
  background(#FFFFF2);
  //noFill();
  translate(width/2, height/2);
  rotateY(radians(frameCount));
  for(int i=0; i<20; i++){
    for(int j=0; j<20; j++){
      for(int k=0; k<20; k++){
        float x = i*10-100, y = j*10-100, z = k*10-100;
        pushMatrix();
          translate(x, y, z);
          box(10);
        popMatrix();
      }
    }
  }
}
