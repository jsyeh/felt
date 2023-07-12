void setup(){
  size(500,500,P3D);
}
void draw(){
  beginShape(TRIANGLES);
    stroke(255,0,0);
    fill(255,0,0);
    vertex(0, 500);
    
    stroke(0,255,0);
    fill(0,255,0);
    vertex(500,500);
    
    stroke(0,0,255);
    fill(0,0,255);
    vertex(250,0);
  endShape();
}
