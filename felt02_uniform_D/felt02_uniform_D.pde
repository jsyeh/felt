PVector [] D = new PVector[100];
void setup(){
  size(500,500,P3D);
  for(int i=0; i<100; i++){
    D[i] = Dxyz();
  }
}
void draw(){
  background(#FFFFF2);
  for(int i=0; i<100; i++){
    float x = i%10*50+25, y = i/10*50+25;
    ellipse(x,y,10,10);
    line(x,y, x+D[i].x*30, y+D[i].y*30);
  }
}
PVector Dxyz(){
  float alpha=1, beta=1;
  return new PVector(alpha*U(), alpha*U(), beta*U());
}
float U(){
  return random(-1,+1);
}
