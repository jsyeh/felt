void setup(){
  size(800,800);
  for(int i=0; i<5; i++){
    for(int j=0; j<5; j++){
      rect(i*100+150, j*100+150, 100, 100);
    }
  }
}
void draw(){
  
}
void mousePressed(){
  int i = (mouseX-150)/100, j = (mouseY-150)/100;
  fill(255,0,0);
  rect(i*100+150, j*100+150, 100, 100);
}
void mouseMoved(){
  println(mouseX, mouseY);
}
