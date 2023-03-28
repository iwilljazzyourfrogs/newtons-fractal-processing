class ComplexNumber {
  float real;
  float imaginary;
  
  color col = color(0, 0, 0);
  ComplexNumber(float x, float y) {
    real = x;
    imaginary = y;
  }
}

ComplexNumber add(ComplexNumber a, ComplexNumber b) {
  float r = a.real + b.real;
  float i = a.imaginary + b.imaginary;
  return new ComplexNumber(r, i);
}

ComplexNumber sub(ComplexNumber a, ComplexNumber b) {
  float r = a.real - b.real;
  float i = a.imaginary - b.imaginary;
  return new ComplexNumber(r, i);
}

ComplexNumber mult(ComplexNumber a, ComplexNumber b) {
  float r = (a.real * b.real) - (a.imaginary * b.imaginary);
  float i = (a.real * b.imaginary) + (a.imaginary * b.real);
  return new ComplexNumber(r, i);
}

ComplexNumber div(ComplexNumber z1, ComplexNumber z2) {
  float a = z1.real;
  float b = z1.imaginary;
  float c = z2.real;
  float d = z2.imaginary;
  float r = (a*c + b*d) / (c*c + d*d);
  float i = (b*c - a*d) / (c*c + d*d);
  return new ComplexNumber(r, i);
}

ComplexNumber conjugate(ComplexNumber z) {
  return new ComplexNumber(z.real, -z.imaginary);
}

float absolute(ComplexNumber z) {
  return sqrt(z.real * z.real + z.imaginary * z.imaginary);
}

float argument(ComplexNumber z) {
  float theta = atan(z.imaginary / (z.real + 0.00000001));
  if (abs(z.real) != z.real) {
    theta += PI;
  }
  return theta;
}

ComplexNumber power(ComplexNumber z, int n) {
  float r = absolute(z);
  float theta = argument(z);
  float a = pow(r, n) * cos(n * theta);
  float b = pow(r, n) * sin(n * theta);
  return new ComplexNumber(a, b);
}

ComplexNumber polarToCartesian(float r, float theta) {
  return new ComplexNumber(r * cos(theta), r * sin(theta));
}
