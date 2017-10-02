/* artifilt/StreamLF.H: part of meabench, an MEA recording and analysis tool
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

// StreamLF.H

#ifndef STREAMLF_H

#define STREAMLF_H

#include <base/Timeref.H>
#include <common/Types.H>
#include <rawsrv/Defs.H>

#define LF_TARGET

class LF_Source {
public:
  LF_Source(int hw0, RawSFSrv &data0, timeref_t offset0):
    hw(hw0), data(data0),offset(offset0) {
  }
  raw_t const &operator[](timeref_t dt) const { return data[dt+offset][hw]; }
  raw_t &operator[](timeref_t dt) { return data[dt+offset][hw]; }
public: // read only !
  int hw;
private:
  RawSFSrv &data;
  timeref_t offset;
};

class LF_Dest {
public:
  LF_Dest(int hw0, RawSFSrv &data0):
    hw(hw0), data(data0) {
  }
  raw_t const &operator[](timeref_t dt) const { return data[dt][hw]; }
  raw_t &operator[](timeref_t dt) { return data[dt][hw]; }
public: // read only !
  int hw;
private:
  RawSFSrv &data;
};

#include "LocalFit.H"

#endif
