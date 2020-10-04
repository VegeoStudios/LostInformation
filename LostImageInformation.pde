String img1name = "original.png";
String img2name = "compressed.jpg";

public void setup() {
  size(2400, 800);
  
  PImage img1 = loadImage(img1name);
  PImage img2 = loadImage(img2name);
  
  img1.resize(width / 3, width / 3);
  img2.resize(width / 3, width / 3);
  
  image(img1, 0, 0);
  image(img2, width / 3, 0);
  image(getLostInformation(img1, img2), (width / 3) * 2, 0);
  
  saveFrame();
}

public PImage getLostInformation(PImage original, PImage compressed) {
  
  if (original.width != compressed.width || original.height != compressed.height) {
    println("ERROR: Original dimensions do not match compressed image.");
    return null;
  }
  
  PImage lostInformation = createImage(original.width, original.height, RGB);
  
  float[] diffArray = new float[lostInformation.pixels.length];
  
  lostInformation.loadPixels();
  original.loadPixels();
  compressed.loadPixels();
  
  int lostAmount = 0;
  float highestDiff = 0;
  float totalDifference = 0;
  
  for (int i = 0; i < lostInformation.pixels.length; i++) {
    float diff = abs(getColorDifference(original.pixels[i], compressed.pixels[i]));
    if (diff > highestDiff) highestDiff = diff;
    if (diff > 0) lostAmount++;
    totalDifference += diff;
    
    diffArray[i] = diff;
  }
  
  println("Highest difference value: " + highestDiff);
  
  for (int i = 0; i < lostInformation.pixels.length; i++) {
    lostInformation.pixels[i] = color(map(diffArray[i], 0.0, highestDiff, 0.0, 255.0));
  }
  
  float percentLost = ((float)lostAmount / (float)lostInformation.pixels.length) * 100;
  println("Information loss: " + percentLost + "%\nTotal value difference: " + totalDifference + "\nLost pixels: " + lostAmount + "\nAccurate pixels: " + (lostInformation.pixels.length - lostAmount));
  
  lostInformation.updatePixels();
  return lostInformation;
}

public float getColorDifference(color c1, color c2) {
  float rDiff = red(c1) - red(c2);
  float gDiff = green(c1) - green(c2);
  float bDiff = blue(c1) - blue(c2);
  
  float rgDiff = sqrt((rDiff * rDiff) + (gDiff * gDiff));
  float rgbDiff = sqrt((rgDiff * rgDiff) + (bDiff * bDiff));
  
  return rgbDiff / sqrt(3);
}
