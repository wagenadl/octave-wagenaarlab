/* base/CyclBuf.H: part of meabench, an MEA recording and analysis tool
** Copyright (C) 2000-2002  Daniel Wagenaar (wagenaar@caltech.edu)
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

// CyclBuf.H

#ifndef CYCLBUF_H

#define CYCLBUF_H

#include <base/Timeref.H>

template <class T> class CyclBuf {
public:
  CyclBuf(int logsiz0) {
    logsiz = logsiz0;
    data_ = new T[1<<logsiz];
    latest_=0;
    mask = (1<<logsiz)-1;
    own=true;
  }
  CyclBuf(int logsiz0, T *data, timeref_t latest0=0, bool own0=false) {
    logsiz=logsiz0;
    data_ = data;
    latest_=latest0;
    mask = (1<<logsiz)-1;
    own=own0;
  }
  CyclBuf<T>& operator=(CyclBuf<T> const &src) {
    logsiz = src.logsiz;
    data_ = new T[1<<logsiz];
    latest_ = src.latest_;
    mask = src.mask;
    own = true;
    for (unsigned int i=0; i<=mask; i++)
      data_[i] = src.data_[i];
    return *this;
  }
  ~CyclBuf() { if (own && data_) delete [] data_; }
  timeref_t latest() const { return latest_; }
  T const &operator[](timeref_t t) const { return data_[t&mask]; }
  T &operator[](timeref_t t) { return data_[t&mask]; }
  T *wheretowrite() { return data_+(latest_&mask); }
  void donewriting(int n) { latest_+=n; }
  void reset() { latest_=0; }
private:
  bool own;
  T *data_;
  timeref_t latest_;
  unsigned int mask;
  int logsiz;
};

#endif
