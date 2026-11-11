int columns = 4;
int rows = 7;
color[] palette = {
  #BBCFE5, // Azul pastel
  #5DD8DF, // Turquesa
  #E7FF00, // Amarillo
  #C5D0D4, // Gris claro
  #DCD5E9  // Lavanda
};
color bgColor = #1A4C41;
int totalFrames = 250;
float[] grainPattern;

void setup() {
  size(1080, 1920, P2D);
  smooth(8);
  pixelDensity(1);
  frameRate(25);
  colorMode(HSB, 360, 100, 100);
  prepareGrain();// Preparar el granulado
}
void draw() {
  background(bgColor);
  // Calcular el tiempo del bucle
  float time = radians(360) * ((frameCount - 1) % totalFrames) / float(totalFrames);
  motion(time);// Dibujar los módulos
  applyGrain();

  // Guardar los fotogramas
  // saveFrame("frames/frame-####.png");

  // Finalizar después de 250 fotogramas
  //if (frameCount >= totalFrames) {
    //exit();
  }
  //println("Fotograma guardado: " + frameCount + " / " + totalFrames);
//}
