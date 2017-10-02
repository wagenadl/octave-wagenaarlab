// DoubleImage.h

#ifndef DOUBLEIMAGE_H

#define DOUBLEIMAGE_H

class DoubleImage {
public:
  DoubleImage();
  DoubleImage(DoubleImage const &);
  DoubleImage(double const *data, int width, int height);
  DoubleImage(int width, int height);
  ~DoubleImage();
  bool ensureSize(int width, int height);
  // clears and returns true if size is changing
  double operator()(int x, int y) const;
  double &operator()(int x, int y);
  double const *data() const;
  double *data();
  double const *row(int y) const;
  double *row(int y);
  int width() const;
  int height() const;
  DoubleImage &operator=(DoubleImage const &);
  DoubleImage &operator+=(double);
  DoubleImage &operator-=(double);
  DoubleImage &operator*=(double);
  DoubleImage &operator/=(double);
  DoubleImage &operator+=(DoubleImage const &);
  DoubleImage &operator-=(DoubleImage const &);
  DoubleImage &operator*=(DoubleImage const &);
  DoubleImage &operator/=(DoubleImage const &);
  DoubleImage convNorm(DoubleImage const &v) const;
  // can only convolve with odd*odd shaped image
  // also, v must be smaller than we are.
  DoubleImage ace(double sx, int rx, double sy, int ry) const;
  void apply(double (*foo)(double));
  void noisify();
  double mean() const;
  static DoubleImage gaussian(double sigmax, int rx,
			      double sigmay=-1, int ry=-1);
private:
  bool ensureCompatible(DoubleImage const &);
  void resize(int n);
private:
  int wid;
  int hei;
  double *dat;
};

#endif
