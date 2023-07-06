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
  for(int i=0; i<30; i++){
    float s = 20/3.0;
    line(x,y,z, x+Di[i].x*s, y+Di[i].y*s, z+Di[i].z*s);
    x+=Di[i].x*s;
    y+=Di[i].y*s;
    z+=Di[i].z*s;
  }
  //float s = 100;
  //line(200, 200, 0, 200+Dxyz.x*s, 200+Dxyz.y*s, 0+Dxyz.z*s);
}
