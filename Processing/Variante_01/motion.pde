void motion(float time) {
  float margin = 3; // Separación entre módulos
  
  // Velocidad del movimiento
  float rowSpeed = 2;
  float columnSpeed = 3;
  
  // Tamaños mínimos y máximos
  float minSize = 0.45;
  float maxSize = 2.3;

  // Alturas de las filas
  float[] rowSizes = new float[rows];
  float totalRowSize = 0;

  // Calcular el movimiento vertical
  for (int row = 0; row < rows; row++) {
    float rowWave = sin(time * rowSpeed + row * 1.4);
    rowSizes[row] = map(rowWave, -1, 1, minSize, maxSize);
    totalRowSize += rowSizes[row];
  }
  float positionY = 0;
  // Recorrer las filas
  for (int row = 0; row < rows; row++) {
    float cellHeight = rowSizes[row] / totalRowSize * height;
    float y = positionY + cellHeight / 2;

    // Guardar las anchuras de los módulos
    float[] columnSizes = new float[columns];
    float totalColumnSize = 0;

    // Calcular el movimiento horizontal
    for (int column = 0; column < columns; column++) {
      float columnWave = sin(
        time * columnSpeed + row * 0.8 + column * 1.7
      );
      columnSizes[column] = map(columnWave, -1, 1, minSize, maxSize);
      totalColumnSize += columnSizes[column];
    }
    float positionX = 0;

    // Recorrer las columnas
    for (int column = 0; column < columns; column++) {
     
      // Posición y dimensiones
      float cellWidth = columnSizes[column] / totalColumnSize * width;
      float x = positionX + cellWidth / 2;
      float moduleWidth = max(0, cellWidth - margin);
      float moduleHeight = max(0, cellHeight - margin);

      // Calcular la expansión del módulo
      float widthExpansion = cellWidth / (width / float(columns));
      float heightExpansion = cellHeight / (height / float(rows));

      float expansion = (widthExpansion + heightExpansion) / 2;

      // Relacionar el tamaño con el color
      float colorAmount = map(expansion, 0.45, 1.75, 0, 1);
      colorAmount = constrain(colorAmount, 0, 1);

      pushStyle();
      colorMode(RGB, 255);
       color moduleColor;

      // Transición del azul al turquesa
      if (colorAmount < 0.5) {
        float amount = map(colorAmount, 0, 0.5, 0, 1);
        moduleColor = lerpColor(palette[0], palette[1], amount);
      } else {
        float amount = map(colorAmount, 0.5, 1, 0, 1);// Transición del turquesa al amarillo
        moduleColor = lerpColor(palette[1], palette[2], amount);
      }

      // Dibujar el módulo
      gradientTexture(
        x,
        y,
        moduleWidth,
        moduleHeight,
        moduleColor,
        row,
        column
      );
      popStyle();
      positionX += cellWidth;
    }
    positionY += cellHeight;
  }
}
