PVector [] D = new PVector[100];
PVector [][] Di = new PVector[100][20];
void setup(){
  size(500,500,P3D);
  for(int i=0; i<100; i++){
    D[i] = Dxyz();
    for(int k=0; k<20; k++){
      float alpha = 0.3, beta = 0.1;
      float x = N(D[i].x, alpha), y = N(D[i].y, alpha), z = N(D[i].z, beta);
      Di[i][k] = new PVector(x, y, z);
    }
  }
}
void draw(){
  background(#FFFFF2);
  float s = 20;
  for(int i=0; i<100; i++){
    float x = i%10*50+25, y = i/10*50+25;
    stroke(0); ellipse(x,y,10,10);
    for(int k=0; k<20; k++){
      line(x,y,0, x+Di[i][k].x*s, y+Di[i][k].y*s, 0+Di[i][k].z*s);
    }
    stroke(#FF0000); line(x,y, x+D[i].x*s, y+D[i].y*s);
  }
}
PVector Dxyz(){
  float alpha=1, beta=1;
  return new PVector(alpha*U(), alpha*U(), beta*U());
}
float U(){
  return random(-1,+1);
}
float N(float Dx, float sigma){
  return randomGaussian()*sigma+Dx;
}
