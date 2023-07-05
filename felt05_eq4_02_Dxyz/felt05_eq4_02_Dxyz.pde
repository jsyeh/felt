PImage img, gray, sobelX, sobelY, sobel;
float[][] m = new float[512][512];//用來存 gray裡的值
float[] Gx = new float[512*512];
float[] Gy = new float[512*512];
float[] G = new float[512*512];
void setup(){
  size(1024, 1024);
  img = loadImage("baboon.png");
  img.loadPixels();
  
  gray = createImage(512, 512, RGB);
  gray.loadPixels();
  for(int i=0; i<512*512; i++){
    gray.pixels[i] = color(brightness(img.pixels[i]));
    m[i/512][i%512] = brightness(img.pixels[i]);
  }
  gray.updatePixels();

  sobelX = createImage(512, 512, RGB);
  sobelX.loadPixels();
  sobelY = createImage(512, 512, RGB);
  sobelY.loadPixels();
  sobel = createImage(512, 512, RGB);
  sobel.loadPixels();
  for(int i=0+1; i<512-1; i++){
    for(int j=0+1; j<512-1; j++){
      int ii = i * 512 + j;
      //計算梯度
      Gx[ii] = -m[i-1][j-1] + m[i-1][j+1] 
               -m[i][j-1]*2 + m[i][j+1]*2 
               -m[i+1][j-1] + m[i+1][j+1];
      Gy[ii] = m[i+1][j-1] + m[i+1][j]*2 + m[i+1][j+1]
              -m[i-1][j-1] - m[i-1][j]*2 - m[i-1][j+1];
      G[ii] = sqrt(Gx[ii]*Gx[ii]+Gy[ii]*Gy[ii]);
      sobelX.pixels[ii] = color(Gx[ii]);
      sobelY.pixels[ii] = color(Gy[ii]);
      sobel.pixels[ii] = color(G[ii]);
    }
  }
  sobelX.updatePixels();
  sobelY.updatePixels();
  sobel.updatePixels();
}
void draw(){
  background(#ff0000);
  //image(gray, 0, 0);
  //image(img, 512, 0);
  image(sobel, 512, 0);
  image(sobelX, 0, 512);
  image(sobelY, 512, 512);
  if(mousePressed && D!=null){
    line(mouseX, mouseY, mouseX+D.x, mouseY+D.y);
    ellipse(mouseX, mouseY, 10, 10);
  }
  //照著梯度的垂直方向，畫出來的線，剛好和線的方向有關
  stroke(255);
  for(int i=0; i<512; i+=4){
    for(int j=0; j<512; j+=4){
      int ii = i*512+j;
      line(j,i, j+Gy[ii]/20.0, i-Gx[ii]/20.0);
      //沒有亂數的原始梯度值轉成的edge方向
    }
  }
}
PVector D = null;
void mouseDragged(){
  if(mouseX>=0 && mouseX<512 && mouseY>=0 && mouseY<512){
    int ii = mouseY*512+mouseX;
    D = Dxyz(ii);
  }
}
PVector Dxyz(int ii){
  float alpha=0.01, beta=1;
  float GGy = Gx[ii]; //因為要垂直轉90度，所以x,y交換
  float GGx = -Gy[ii]; //因為要垂直轉90度，所以x,y交換
  float GG = G[ii];
  return new PVector(GGx*GG + alpha*U(), GGy*GG + alpha*U(), beta*U());
}
float U(){
  return random(-1,+1);
}
