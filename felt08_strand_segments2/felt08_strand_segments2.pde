PVector D;
PVector[] Di;
void setup(){
  size(400,400,P3D);
  D = new PVector(random(-1,+1),random(-1,+1),random(-1,+1));
  Di = new PVector[30];
  for(int i=0; i<30; i++){
    float sigma = 0.5;
    Di[i] = new PVector(randomGaussian()*sigma + D.x, 
                        randomGaussian()*sigma + D.y, 
                        randomGaussian()*sigma + D.z).normalize();
  }
}
void draw(){
  translate(width/2,height/2);
  rotateY(radians(frameCount));
  translate(-width/2,-height/2);
  background(#FFFFF2);
  float x=200, y=200, z=0;
  for(int i=0; i<15; i++){
    float s = 20/3.0;
    line(x,y,z, x+Di[i].x*s, y+Di[i].y*s, z+Di[i].z*s);
    x+=Di[i].x*s;
    y+=Di[i].y*s;
    z+=Di[i].z*s;
  }
  float x2=200, y2=200, z2=0;
  for(int i=15; i<30; i++){
    float s = 20/3.0;
    line(x2,y2,z2, x2-Di[i].x*s, y2-Di[i].y*s, z2-Di[i].z*s);
    x2-=Di[i].x*s;
    y2-=Di[i].y*s;
    z2-=Di[i].z*s;
  }
}
