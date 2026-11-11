void gradientTexture(float x, float y, float moduleWidth, float moduleHeight, color baseColor, int row, int column) {
  float gradientIntensity = 0.60;// Intensidad del degradado
  // Parámetros de la sombra
  float shadowOffsetX = 30;
  float shadowOffsetY = 15;
  float shadowSpread = 5;
  color shadowColor = #419582;

  // Movimiento de la sombra en bucle
  float time = radians(360) * ((frameCount - 1) % totalFrames) / float(totalFrames);
  float shadowSpeed = 2;
  float shadowWave = cos(time * shadowSpeed + PI);
  float shadowOpacity = map(shadowWave, -1, 1, 60, 255);

  pushStyle();
  colorMode(RGB, 255);

  // Colores del degradado
  color color1 = lerpColor(baseColor, palette[0], gradientIntensity);
  color color2 = lerpColor(baseColor, palette[2], gradientIntensity);

  // Dibujar una única sombra
  drawRoundedSolidShape(
    x + shadowOffsetX,
    y + shadowOffsetY,
    moduleWidth + shadowSpread,
    moduleHeight + shadowSpread,
    shadowColor,
    shadowOpacity
    );

  // Dibujar la forma con degradado
  drawRoundedGradientShape(x, y, moduleWidth, moduleHeight, color1, color2);

  // Dibujar los círculos decorativos
  drawCircleDetails(x, y, moduleWidth, moduleHeight, row, column);

  popStyle();
}
// Dibujar la sombra redondeada
void drawRoundedSolidShape(float x, float y, float moduleWidth, float moduleHeight, color shapeColor, float alphaValue) {

  push();
  translate(x, y);
  rectMode(CENTER);
  noStroke();

  float cornerRadius = min(moduleWidth, moduleHeight) / 2;

  fill(shapeColor, alphaValue);
  rect(0, 0, moduleWidth, moduleHeight, cornerRadius);
  pop();
}
// Dibujar una forma con degradado
void drawRoundedGradientShape(float x, float y, float moduleWidth, float moduleHeight, color color1, color color2) {

  push();
  translate(x, y);
  noStroke();

  float halfWidth = moduleWidth / 2;// Dimensiones de la figura
  float halfHeight = moduleHeight / 2;
  float cornerRadius = min(moduleWidth, moduleHeight) / 2;// Esquinas redondeadas

  // Divisiones del degradado
  int steps = max(48, ceil(moduleWidth * 1.5));
  beginShape(TRIANGLE_STRIP);

  for (int i = 0; i <= steps; i++) {
    float px = map(i, 0, steps, -halfWidth, halfWidth);// Posición horizontal
    float amount = float(i) / steps;// Transición cromática
    color gradientColor = lerpColor(color1, color2, amount);

    // Calcular el contorno redondeado
    float distanceX = abs(px);
    float limitY = halfHeight;

    if (distanceX > halfWidth - cornerRadius) {
      float distanceCorner = distanceX - (halfWidth - cornerRadius);
      limitY = halfHeight - cornerRadius
        + sqrt(max(0, cornerRadius * cornerRadius
        - distanceCorner * distanceCorner));
    }
    // Dibujar la superficie con degradado
    fill(gradientColor);
    vertex(px, -limitY);
    vertex(px, limitY);
  }
  endShape();
  pop();
}
// Preparar la textura de granulado
void prepareGrain() {
  loadPixels();
  grainPattern = new float[pixels.length];// Crear la textura
  randomSeed(2026);// Mantener el mismo patrón

  // Generar pequeñas variaciones de luminosidad
  for (int i = 0; i < grainPattern.length; i++) {
    grainPattern[i] = (float) randomGaussian() * 9;
  }
}
void applyGrain() {// Aplicar el granulado a las formas
  float grainIntensity = 0.6;
  // Color del fondo
  int bgR = (bgColor >> 16) & 255;
  int bgG = (bgColor >> 8) & 255;
  int bgB = bgColor & 255;

  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    // Color del píxel
    int pixelColor = pixels[i];
    int r = (pixelColor >> 16) & 255;
    int g = (pixelColor >> 8) & 255;
    int b = pixelColor & 255;

    // Diferencia respecto al fondo
    float difference = max(
      abs(r - bgR),
      max(abs(g - bgG), abs(b - bgB))
      );

    // Aplicar la textura solo fuera del fondo
    if (difference > 0) {
      // Suavizar la textura en los bordes
      float edgeFactor = constrain(difference / 30.0, 0, 1);
      float grain = grainPattern[i] * grainIntensity * edgeFactor;

      r = int(constrain(r + grain, 0, 255));
      g = int(constrain(g + grain, 0, 255));
      b = int(constrain(b + grain, 0, 255));

      // Actualizar el píxel
      pixels[i] = 0xFF000000 | (r << 16) | (g << 8) | b;
    }
  }
  updatePixels();
}
// Dibujar los círculos decorativos
void drawCircleDetails(float x, float y, float moduleWidth, float moduleHeight, int row, int column) {

  // Dibujar círculos solo en algunos módulos
  if ((row + column) % 3 != 0) {
    return;
  }
  // Evitar módulos demasiado pequeños
  if (moduleWidth < 80 || moduleHeight < 55) {
    return;
  }
  push();
  translate(x, y);
  noStroke();

  // Tamaño de los círculos
  float circleSize = min(moduleWidth, moduleHeight) * 0.16;

  // Distancia entre los centros
  float spacing = circleSize * 1.2;

  // Número de círculos
  int circleCount = 3;

  // Posición inicial del grupo
  float startX = -((circleCount - 1) * spacing) / 2;
  float startY = -moduleHeight * 0.20;

  // Dibujar los tres círculos
  for (int i = 0; i < circleCount; i++) {
    float cx = startX + i * spacing;
    float cy = startY;
    fill(255);// Color círculos pequeños
    ellipse(cx, cy, circleSize, circleSize);
  }
  pop();
}
