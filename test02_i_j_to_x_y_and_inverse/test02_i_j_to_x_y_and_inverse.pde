void setup(){
  size(500,500);
  for(int i=0; i<5; i++){
    for(int j=0; j<5; j++){
      rect(i*100, j*100, 100, 100);
    }
  }
}
void draw(){
  
}
void mousePressed(){
  int i = mouseX/100, j = mouseY/100;
  fill(255,0,0);
  rect(i*100, j*100, 100, 100);
}
void mouseMoved(){
  println(mouseX, mouseY);
}
