PImage img, gray, sobel, sobel2;
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

  sobel = createImage(512, 512, RGB);
  sobel.loadPixels();
  sobel2 = createImage(512, 512, RGB);
  sobel2.loadPixels();
  for(int i=0+1; i<512-1; i++){
    for(int j=0+1; j<512-1; j++){
      int ii = i * 512 + j;
      float G = -m[i-1][j-1] + m[i-1][j+1] 
                -m[i][j-1]*2 + m[i][j+1]*2 
                -m[i+1][j-1] + m[i+1][j+1];
      float G2 = m[i-1][j-1] + m[i-1][j]*2 + m[i-1][j+1]
                -m[i+1][j-1] - m[i+1][j]*2 - m[i+1][j+1];
      sobel.pixels[ii] = color(G);
      sobel2.pixels[ii] = color(G2);
    }
  }
  sobel.updatePixels();
  sobel2.updatePixels();
}
void draw(){
  background(#ff0000);
  image(gray, 0, 0);
  image(img, 512, 0);
  image(sobel, 0, 512);
  image(sobel2, 512, 512);
}
