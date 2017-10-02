// DoubleImage.cpp

#include "DoubleImage.h"
#include <math.h>
#include <string.h>

void DoubleImage::resize(int n) {
  delete [] dat;
  dat = new double[n];
}

DoubleImage::DoubleImage() {
  wid = hei = 0;
  dat = 0;
}

DoubleImage::DoubleImage(DoubleImage const &o) {
  wid = o.wid;
  hei = o.hei;
  dat = new double[wid*hei];
  memcpy(data(), o.data(), sizeof(double)*wid*hei);
}

DoubleImage &DoubleImage::operator=(DoubleImage const &o) {
  delete dat;
  wid = o.wid;
  hei = o.hei;
  dat = new double[wid*hei];
  memcpy(data(), o.data(), sizeof(double)*wid*hei);
  return *this;
}

DoubleImage::~DoubleImage() {
  delete [] dat;
}

DoubleImage::DoubleImage(double const *src, int width, int height) {
  wid = width;
  hei = height;
  dat = 0;
  resize(wid*hei);
  memcpy(data(), src, sizeof(double)*width*height);
}

DoubleImage::DoubleImage(int width, int height) {
  wid = width;
  hei = height;
  dat = 0;
  resize(wid*hei);
}

bool DoubleImage::ensureSize(int w, int h) {
  if (w==wid && h==hei)
    return false;
  wid = w; hei=h;
  resize(wid*hei);
  return true;
}

double DoubleImage::operator()(int x, int y) const {
  return row(y)[x];
}


double &DoubleImage::operator()(int x, int y) {
  return row(y)[x];
}


double const *DoubleImage::data() const {
  return dat;
}


double *DoubleImage::data() {
  return dat;
}


double const *DoubleImage::row(int y) const {
  return data() + wid*y;
}


double *DoubleImage::row(int y) {
  return data() + wid*y;
}


int DoubleImage::width() const {
  return wid;
}

int DoubleImage::height() const {
  return hei;
}

void DoubleImage::apply(double (*foo)(double)) {
  int n = wid*hei;
  double *dst = data();
  while (n--) {
    *dst = foo(*dst);
    dst++;
  }
}

void DoubleImage::noisify() {
  int n = wid*hei;
  double *dst = data();
  while (n--) 
    *dst++ += rand()/(RAND_MAX+1.0);
}

double DoubleImage::mean() const {
  double a = 0;
  int n = wid*hei;
  double const *src = data();
  while (n--) 
    a += *src++;
  return a / (wid*hei);
}

DoubleImage &DoubleImage::operator+=(double v) {
  int n = wid*hei;
  double *dst = data();
  while (n--)
    *dst++ += v;
  return *this;
}


DoubleImage &DoubleImage::operator-=(double v) {
  int n = wid*hei;
  double *dst = data();
  while (n--)
    *dst++ -= v;
  return *this;
}


DoubleImage &DoubleImage::operator*=(double v) {
  int n = wid*hei;
  double *dst = data();
  while (n--)
    *dst++ *= v;
  return *this;
}


DoubleImage &DoubleImage::operator/=(double v) {
  int n = wid*hei;
  double *dst = data();
  while (n--)
    *dst++ /= v;
  return *this;
}


DoubleImage &DoubleImage::operator+=(DoubleImage const &v) {
  if (ensureCompatible(v)) {
    int n = wid*hei;
    double const *src = v.data();
    double *dst = data();
    while (n--)
      *dst++ += *src++;
  }
  return *this;
}


DoubleImage &DoubleImage::operator-=(DoubleImage const &v) {
  if (ensureCompatible(v)) {
    int n = wid*hei;
    double const *src = v.data();
    double *dst = data();
    while (n--)
      *dst++ -= *src++;
  }
  return *this;
}


DoubleImage &DoubleImage::operator*=(DoubleImage const &v) {
  if (ensureCompatible(v)) {
    int n = wid*hei;
    double const *src = v.data();
    double *dst = data();
    while (n--)
      *dst++ *= *src++;
  }
  return *this;
}


DoubleImage &DoubleImage::operator/=(DoubleImage const &v) {
  if (ensureCompatible(v)) {
    int n = wid*hei;
    double const *src = v.data();
    double *dst = data();
    while (n--)
      *dst++ /= *src++;
  }
  return *this;
}

DoubleImage DoubleImage::convNorm(DoubleImage const &v) const {
  int w2 = v.width();
  int h2 = v.height();
  if ((w2&1)==0 || (h2&1)==0)
    return DoubleImage();
  if (w2>=wid || h2>=hei)
    return DoubleImage();
  int rx = (w2-1)/2;
  int ry = (h2-1)/2;

  DoubleImage r(wid, hei);

  for (int y=0; y<ry; y++) {
    double const *src = row(0);
    double *dst = r.row(y);
    double const *s2_ = v.row(ry - y);
    for (int x=0; x<rx; x++) { // topleft corner
      double const *s2 = s2_ + rx - x;
      double a = 0;
      double b = 0;
      for (int dy=0; dy<ry+1+y; dy++) {
        double const *sa = src + wid*dy;
        double const *sb = s2 + w2*dy;
        for (int dx=0; dx<rx+1+x; dx++) {
          double q = *sb++;
          a += *sa++ * q;
          b += q;
        }
      }
      *dst++ = a/b;
    }
    for (int x=rx; x<wid-rx; x++) { // top edge
      double const *s2 = s2_;
      double a = 0;
      double b = 0;
      for (int dy=0; dy<ry+1+y; dy++) {
        double const *sa = src + wid*dy;
        double const *sb = s2 + w2*dy;
        for (int dx=0; dx<w2; dx++) {
          double q = *sb++;
          a += *sa++ * q;
          b += q;
        }
      }
      *dst++ = a/b;
      src++;
    }
    for (int x=wid-rx; x<wid; x++) { // top right corner
      double const *s2 = s2_;
      double a = 0;
      double b = 0;
      for (int dy=0; dy<ry+1+y; dy++) {
        double const *sa = src + wid*dy;
        double const *sb = s2 + w2*dy;
        for (int dx=0; dx<rx+wid-x; dx++) {
          double q = *sb++;
          a += *sa++ * q;
          b += q;
        }
      }
      *dst++ = a/b;
      src++;
    }
  }
  
  for (int y=ry; y<hei-ry; y++) {
    double const *src = row(y-ry);
    double *dst = r.row(y);
    double const *s2_ = v.row(0);
    for (int x=0; x<rx; x++) { // left edge
      double const *s2 = s2_ + rx - x;
      double a = 0;
      double b = 0;
      for (int dy=0; dy<h2; dy++) {
        double const *sa = src + wid*dy;
        double const *sb = s2 + w2*dy;
        for (int dx=0; dx<rx+1+x; dx++) {
          double q = *sb++;
          a += *sa++ * q;
          b += q;
        }
      }
      *dst++ = a/b;
    }
    
    for (int x=rx; x<wid-rx; x++) { // bulk
      double const *s2 = s2_;
      double a = 0;
      double b = 0;
      for (int dy=0; dy<h2; dy++) {
        double const *sa = src + wid*dy;
        double const *sb = s2 + w2*dy;
        for (int dx=0; dx<w2; dx++) {
          double q = *sb++;
          a += *sa++ * q;
          b += q;
        }
      }
      *dst++ = a/b;
      src++;
    }

    for (int x=wid-rx; x<wid; x++) { // right edge
      double const *s2 = s2_;
      double a = 0;
      double b = 0;
      for (int dy=0; dy<h2; dy++) {
        double const *sa = src + wid*dy;
        double const *sb = s2 + w2*dy;
        for (int dx=0; dx<rx+wid-x; dx++) {
          double q = *sb++;
          a += *sa++ * q;
          b += q;
        }
      }
      *dst++ = a/b;
      src++;
    }
  }

  for (int y=hei-ry; y<hei; y++) {
    double const *src = row(y-ry);
    double *dst = r.row(y);
    double const *s2_ = v.row(0);
    for (int x=0; x<rx; x++) { // bottom left corner
      double const *s2 = s2_ + rx - x;
      double a = 0;
      double b = 0;
      for (int dy=0; dy<ry+hei-y; dy++) {
        double const *sa = src + wid*dy;
        double const *sb = s2 + w2*dy;
        for (int dx=0; dx<rx+1+x; dx++) {
          double q = *sb++;
          a += *sa++ * q;
          b += q;
        }
      }
      *dst++ = a/b;
    }

    for (int x=rx; x<wid-rx; x++) { // bottom edge
      double const *s2 = s2_;
      double a = 0;
      double b = 0;
      for (int dy=0; dy<ry+hei-y; dy++) {
        double const *sa = src + wid*dy;
        double const *sb = s2 + w2*dy;
        for (int dx=0; dx<w2; dx++) {
          double q = *sb++;
          a += *sa++ * q;
          b += q;
        }
      }
      *dst++ = a/b;
      src++;
    }
    for (int x=wid-rx; x<wid; x++) { // bottom right corner
      double const *s2 = s2_;
      double a = 0;
      double b = 0;
      for (int dy=0; dy<ry+hei-y; dy++) {
        double const *sa = src + wid*dy;
        double const *sb = s2 + w2*dy;
        for (int dx=0; dx<rx+wid-x; dx++) {
          double q = *sb++;
          a += *sa++ * q;
          b += q;
        }
      }
      *dst++ = a/b;
      src++;
    }
  }
  
  return r;
}

bool DoubleImage::ensureCompatible(DoubleImage const &v) {
  if (v.width() == wid && v.height() == hei)
    return true;

  *this = DoubleImage();
  return false;
}

DoubleImage DoubleImage::gaussian(double sigx, int rx, double sigy, int ry) {
  if (sigy<0)
    sigy = sigx;
  if (ry<0)
    ry = rx;
  DoubleImage f(2*rx+1, 2*ry+1);
  double sx2 = sigx*sigx;
  double sy2 = sigy*sigy;
  for (int y=-ry; y<=ry; y++) {
    double *dst = f.row(y+ry);
    for (int x=-rx; x<=rx; x++) 
      *dst++ = exp(-.5*(x*x/sx2 + y*y/sy2));
  }
  return f;
}

DoubleImage DoubleImage::ace(double sigx, int rx, double sigy, int ry) const {
  DoubleImage g = gaussian(sigx, rx, sigy, ry);
  DoubleImage avg = convNorm(g);
  DoubleImage dif = *this; dif -= avg;
  DoubleImage rms = dif; rms *= rms;
  rms = rms.convNorm(g);
  rms.apply(sqrt);
  rms = rms.convNorm(g); // this may not really matter
  rms += rms.mean()/4;
  dif /= rms;
  return dif;
}
