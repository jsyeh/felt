PImage img, gray, sobelX, sobelY, sobel;
float[][] m = new float[256][256];//用來存 gray裡的值
float[] Gx = new float[256*256];
float[] Gy = new float[256*256];
float[] G = new float[256*256];
PVector[][]Layer = new PVector[12][256*256]; //3層 directed Layers + 9層 undirected layers
float[][] LayerX = new float[12][256*256]; //其實 PVector or float 都可以，我重覆宣告了
float[][] LayerY = new float[12][256*256];
float[][] LayerZ = new float[12][256*256];

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
    for(int ii=0; ii<256*256; ii++){
      boolean directed = true; //directed
      if(L>=3) directed = false; //undirected
      Layer[L][ii] = Dxyz(ii, directed);
      LayerX[L][ii] = Layer[L][ii].x;
      LayerY[L][ii] = Layer[L][ii].y;
      LayerZ[L][ii] = Layer[L][ii].z;
    }
  }
}
boolean L0, L1, L2, L3 = true;
void keyPressed(){
  if(key=='1') L0 = true;
  if(key=='2') L1 = true;
  if(key=='3') L2 = true;
}
void keyReleased(){
  if(key=='1') L0 = false;
  if(key=='2') L1 = false;
  if(key=='3') L2 = false;
}
void draw(){
  background(0);
  stroke(255,128);
  float s = 0.3;
  for(int i=0; i<256; i+=1){
    for(int j=0; j<256; j+=1){
      int ii = i*256+j;
      if(mousePressed){
        //照著梯度的垂直方向，畫出來的線，剛好和線的方向有關
        line(j*4,i*4, j*4+Gy[ii]/20.0, i*4-Gx[ii]/20.0); //沒有亂數的原始梯度值轉成的edge方向
      }else{
        stroke(img.pixels[ii]); //照原始照片，加上色彩
        //畫越多層越慢，預設先畫 Undirected layers
        if(L3) line(j*4-LayerX[3][ii]/s, i*4-LayerY[3][ii]/s, j*4+LayerX[3][ii]/s, i*4+LayerY[3][ii]/s); //Undirected
        //下面是 Directed layers
        if(L0) line(j*4-LayerX[0][ii]/s, i*4-LayerY[0][ii]/s, j*4+LayerX[0][ii]/s, i*4+LayerY[0][ii]/s);
        if(L1) line(j*4-LayerX[1][ii]/s, i*4-LayerY[1][ii]/s, j*4+LayerX[1][ii]/s, i*4+LayerY[1][ii]/s);
        if(L2) line(j*4-LayerX[2][ii]/s, i*4-LayerY[2][ii]/s, j*4+LayerX[2][ii]/s, i*4+LayerY[2][ii]/s);
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
