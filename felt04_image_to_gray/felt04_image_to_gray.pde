PImage img, gray;
void setup(){
  size(1024, 512);
  img = loadImage("baboon.png");
  img.loadPixels();
  
  gray = createImage(512, 512, RGB);
  gray.loadPixels();
  for(int i=0; i<512*512; i++){
    gray.pixels[i] = color(brightness(img.pixels[i]));
  }
  gray.updatePixels();
}
void draw(){
  background(#ff0000);
  image(gray,0,0);
  image(img,512,0);
}
