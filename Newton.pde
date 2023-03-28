int n = 5;
int numIter = 10;

float zoom = 1.0;

ComplexNumber[] roots = new ComplexNumber[n];

ComplexNumber[][] grid;
ComplexNumber[][] iterGrid;

boolean rendering = false;

void settings() {
  size(600, 600);
  if (rendering) {
    size(8192, 8192);
  }
}

void setup() {
  for (int i = 0; i < n; i++) {
    roots[i] = polarToCartesian(random(1) / (zoom * 2), i * (TWO_PI / n));
    roots[i].col = hueToRGB(i * (360 / n));
  }
  
  grid = new ComplexNumber[width][height];
  
  float maxX = 1 / zoom;
  float minX = -maxX;
  float maxY = 1 / zoom;
  float minY = -maxY;
  
  println("Starting grid");
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float newX = map(x, 0, width, minX, maxX);
      float newY = map(y, height, 0, minY, maxY);
      grid[x][y] = new ComplexNumber(newX , newY);
    }
  }
  println("Created grid");
  
  iterGrid = grid.clone();
  
  println("Starting algorithm");
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < width; y++) {
      for (int i = 0; i < numIter; i++) {
        iterGrid[x][y] = newton(iterGrid[x][y]);
      }
      ComplexNumber nearestRoot = null;
      for (ComplexNumber root : roots) {
        float distance = dist(iterGrid[x][y].real, iterGrid[x][y].imaginary, root.real, root.imaginary);
        if (nearestRoot != null) {
          float distToCurrent = dist(iterGrid[x][y].real, iterGrid[x][y].imaginary, nearestRoot.real, nearestRoot.imaginary);
          if (distance < distToCurrent) {
            nearestRoot = root;
          }
        } else {
          nearestRoot = root;
        }
      }
      grid[x][y].col = nearestRoot.col;
    }
    if (x % (width / 100) == 0) {
      println(100 / float(width) * x);
    }
  }
  
  println("Finished algorithm");
  println("Starting render");
  
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      pixels[x+y*width] = grid[x][height - y - 1].col;
    }
  }
  updatePixels();
  
  println("Finished render");

  if (rendering) {
    println("Saving");
    save("Newton.png");
    println("Saved");
    exit();
  } else {
    for (ComplexNumber root : roots) {
      float x = map(root.real, minX, maxX, 0, width);
      float y = map(root.imaginary, minY, maxY, 0, height);
      stroke(0);
      fill(root.col);
      circle(x, y, 10);
    }
  }
}

color hueToRGB(float h) {
  h = (h + 360) % 360;
  float M = 255.0;
  float z = M * (1 - abs((h / 60) % 2 - 1));
  
  if (0 <= h && h < 60) {
    return color(M, z, 0);
  } else if (60 <= h && h < 120) {
    return color(z, M, 0);
  } else if (120 <= h && h < 180) {
    return color(0, M, z);
  } else if (180 <= h && h < 240) {
    return color(0, z, M);
  } else if (240 <= h && h < 300) {
    return color(z, 0, M);
  } else {
    return color(M, 0, z);
  }
}

ComplexNumber f(ComplexNumber z) {
  ComplexNumber prod = new ComplexNumber(1, 0);
  for (int i = 0; i < n; i++) {
    ComplexNumber term = sub(z, roots[i]); //(z - root)
    prod = mult(prod, term); //(multiply to the others)
  }
  return prod;
}

ComplexNumber fDash(ComplexNumber z) {
  ComplexNumber sum = new ComplexNumber(0, 0);
  for (int i = 0; i < n; i++) {
    ComplexNumber currentRoot = roots[i];
    ComplexNumber term = new ComplexNumber(1, 0);
    for (ComplexNumber root : roots) {
      if (currentRoot != root) {
        ComplexNumber subTerm = sub(z, root);
        term = mult(term, subTerm);
      }
    }
    sum = add(sum, term);
  }
  return sum;
}

ComplexNumber newton(ComplexNumber z) {
  ComplexNumber n = f(z);
  ComplexNumber d = fDash(z);
  ComplexNumber frac = div(n, d);
  ComplexNumber nextZ = sub(z, frac);
  return nextZ;
}
