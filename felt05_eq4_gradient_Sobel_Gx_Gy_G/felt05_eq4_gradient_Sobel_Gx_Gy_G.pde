PImage img, gray, sobelX, sobelY, sobel;
float[][] m = new float[512][512];//用來存 gray裡的值
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
      float Gx = -m[i-1][j-1] + m[i-1][j+1] 
                -m[i][j-1]*2 + m[i][j+1]*2 
                -m[i+1][j-1] + m[i+1][j+1];
      float Gy = m[i+1][j-1] + m[i+1][j]*2 + m[i+1][j+1]
                -m[i-1][j-1] - m[i-1][j]*2 - m[i-1][j+1];
      float G = sqrt(Gx*Gx+Gy*Gy);
      sobelX.pixels[ii] = color(Gx);
      sobelY.pixels[ii] = color(Gy);
      sobel.pixels[ii] = color(G);
    }
  }
  sobelX.updatePixels();
  sobelY.updatePixels();
  sobel.updatePixels();
}
void draw(){
  background(#ff0000);
  image(gray, 0, 0);
  //image(img, 512, 0);
  image(sobel, 512, 0);
  image(sobelX, 0, 512);
  image(sobelY, 512, 512);
}
