PImage img, gray, sobelX, sobelY, sobel;
float[][] m = new float[256][256];//用來存 gray裡的值
float[] Gx = new float[256*256];
float[] Gy = new float[256*256];
float[] G = new float[256*256];
float sigma = 0.5; // 可試試不同的 sigma值，segmentN越大，sigma要越小
int segmentN = 10; // 10 segments OR 30 segments
PVector[][][]Layer = new PVector[12][256*256][segmentN]; //3層 directed Layers + 9層 undirected layers
float[][][] LayerX = new float[12][256*256][segmentN]; //其實 PVector or float 都可以，我重覆宣告了
float[][][] LayerY = new float[12][256*256][segmentN];
float[][][] LayerZ = new float[12][256*256][segmentN]; //30個 segment 可以組合出一根 strand, 每個pixel是一根strand
void setup(){
  size(1024, 1024);
  img = loadImage("baboon.png");
  //img = loadImage("block.png");//用方塊圖，方便debug，並找到y方向的錯誤
  img.resize(256,256);
  img.loadPixels();
  
  gray = createImage(256, 256, RGB);
  gray.loadPixels();
  for(int i=0; i<256*256; i++){
    gray.pixels[i] = color(red(img.pixels[i]));
    m[i/256][i%256] = red(img.pixels[i]);
  }
  gray.updatePixels();

  sobelX = createImage(256, 256, RGB);
  sobelX.loadPixels();
  sobelY = createImage(256, 256, RGB);
  sobelY.loadPixels();
  sobel = createImage(256, 256, RGB);
  sobel.loadPixels();
  for(int i=0+1; i<256-1; i++){
    for(int j=0+1; j<256-1; j++){
      int ii = i * 256 + j;
      //Sobel法，計算梯度
      Gx[ii] = -m[i-1][j-1] + m[i-1][j+1] 
               -m[i][j-1]*2 + m[i][j+1]*2 
               -m[i+1][j-1] + m[i+1][j+1];
      Gy[ii] = -m[i-1][j-1] - m[i-1][j]*2 - m[i-1][j+1]
               +m[i+1][j-1] + m[i+1][j]*2 + m[i+1][j+1]; //小心y方向的錯誤
      G[ii] = sqrt( Gx[ii]*Gx[ii] + Gy[ii]*Gy[ii] );
      sobelX.pixels[ii] = color(Gx[ii]);
      sobelY.pixels[ii] = color(Gy[ii]);
      sobel.pixels[ii] = color(G[ii]);
    }
  }
  sobelX.updatePixels();
  sobelY.updatePixels();
  sobel.updatePixels();
  for(int L = 0; L<12; L++){ //3層 directed, 9層 undirected
    //LL[L] = true; //12層全秀，要16秒，且CPU 100%快當掉了
    for(int ii=0; ii<256*256; ii++){
      boolean directed = true; //directed
      if(L>=3) directed = false; //undirected
      PVector D = Dxyz(ii, directed);
      for(int s=0; s<segmentN; s++){ //10 or 30 segments = 1 strand毛
        Layer[L][ii][s] = new PVector(randomGaussian()*sigma + D.x, 
                                      randomGaussian()*sigma + D.y, 
                                      randomGaussian()*sigma + D.z).normalize();
        LayerX[L][ii][s] = Layer[L][ii][s].x;
        LayerY[L][ii][s] = Layer[L][ii][s].y;
        LayerZ[L][ii][s] = Layer[L][ii][s].z;
      }
    }
  }
  updateDensity();
}
int NX=256, NY=256, NZ=32;
float [][][]density = new float[NX][NY][NZ];//z方向到底是多少？
float [][][]T = new float[NX][NY][NZ]; //因為論文的i方向是光的方向，現在要用z來代表
void addDensity(float x, float y, float z){
  int ix = int(x), iy = int(y), iz = int(z);
  if(ix<0 || ix>=NX || iy<0 || iy>=NY || iz<0 || iz>=NZ) return;
  density[ix][iy][iz]++; //x,y,z 的 z方向在最右邊呢！與論文不同
}
void updateDensity(){//假設最簡單的，從正上方光線射入
  float len = 2.0;
  for(int L=12-1; L>=0; L--){
    for(int i=0; i<256; i+=1){
      for(int j=0; j<256; j+=1){
        int ii = i*256+j;
        float x = j*(NX/256), y = i*(NY/256), z = L*(NZ/12); //現在要考慮z的值
        addDensity(x,y,z);
        for(int s=0; s<segmentN; s++){
          x += LayerX[L][ii][s]*len;
          y += LayerY[L][ii][s]*len;
          z += LayerZ[L][ii][s]*len;
          addDensity(x,y,z);
        }
      }
    }
  }
  updateTransmittance();
}
float f = 1, ds = 1;
void updateTransmittance(){
  //根據 felt論文及 2005頭髮的論文 Tijk 的 ijk 不是 xyz。i方向是光的方向，也就是z的方向
  for(int ix=0; ix<NX; ix++){
    for(int iy=0; iy<NY; iy++){ //決定平面的點
      float prevTrans = 1; //100%通過光線
      for(int iz=0; iz<NZ; iz++){ //往z方向打穿，也是從 imin一直打到i為止
        T[ix][iy][iz] = prevTrans;
        prevTrans *= exp(-density[ix][iy][iz]*f*ds);
      }
    }
  }
}
//boolean L0, L1, L2, L3 = true;
boolean [] LL = new boolean[12]; //LL[0] LL[1] LL[2]  vs. LL[3] ... LL[11]
void keyPressed(){
  if(key=='1') LL[0] = true;
  if(key=='2') LL[1] = true;
  if(key=='3') LL[2] = true;
}
void keyReleased(){
  if(key=='1') LL[0] = false;
  if(key=='2') LL[1] = false;
  if(key=='3') LL[2] = false;
}
void draw(){
  float transparent = 0.5;
  for(int L=0; L<3; L++){
    if(LL[L]==true) transparent = 0.2;
  }

  background(0);
  stroke(255,128);
  float len = 2.0;
  LL[3]=true;
  for(int L=3; L>=0; L--){ //12層全秀，要16秒，且CPU 100%快當掉了
    for(int i=0; i<256; i+=1){
      for(int j=0; j<256; j+=1){
        int ii = i*256+j;
        if(mousePressed){
          //照著梯度的垂直方向，畫出來的線，剛好和線的方向有關
          line(j*4,i*4, j*4+Gy[ii]/20.0, i*4-Gx[ii]/20.0); //沒有亂數的原始梯度值轉成的edge方向
        }else{
          stroke(img.pixels[ii], 255*transparent); //照原始照片，加上色彩
          //畫越多層越慢，預設先畫 Undirected layers
          if(LL[L]){
            float x = j*4, y = i*4;
            for(int s=0; s<segmentN; s++){
              line(x, y, x+LayerX[L][ii][s]*len, y+LayerY[L][ii][s]*len); //Undirected
              x += LayerX[L][ii][s]*len;
              y += LayerY[L][ii][s]*len;
            }
          }
        }
      }
    }
  }
  if(mousePressed) image(gray, 0, 0); //按mouse時，秀出gray的圖，方便比較
}
PVector Dxyz(int ii, boolean directed){
  float alpha=1500, beta=1; //要調 alpha 的值
  if(!directed) return new PVector(alpha*U(), alpha*U(), beta*U()).normalize(); //Undirected Layer
  
  float GGx = -Gy[ii]; //因為要垂直轉90度，所以x,y交換
  float GGy = Gx[ii]; //因為要垂直轉90度，所以x,y交換
  float GG = G[ii];
  return new PVector(GGx*GG + alpha*U(), GGy*GG + alpha*U(), beta*U()).normalize(); //Directed Layer
}
float U(){
  return random(-1,+1);
}
