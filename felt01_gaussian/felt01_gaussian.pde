void setup(){
  size(500,500);
  for(int i=0; i<500; i++){
    float x = (i-250)/250.0;
    float y = gaussian(x, 0.1, 0);
    ellipse(i,y*28,3,3); //這裡湊答案湊很久
  }
}
//https://en.wikipedia.org/wiki/Normal_distribution
float gaussian(float x, float sigma, float mean){
  float up = ((x-mean)/sigma)*((x-mean)/sigma);
  return (1/sigma/sqrt(2*PI) )*exp(-0.5*up);
}
