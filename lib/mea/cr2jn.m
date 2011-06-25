/* gui/JNMEA.H: part of meabench, an MEA recording and analysis tool
** Copyright (C) 2010  Daniel Wagenaar (daw@caltech.edu)
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

// JNMEA.H - created by jnlayout.pl. Do not edit manually.

inline void cr2JN(int c, int r, int &ix, int &iy) {
  int ixx[8][8];
  int iyy[8][8];
  ixx(1,1) = 0;
  iyy(1,1) = 0;
  ixx(2,1) = 13;
  iyy(2,1) = 7;
  ixx(3,1) = 12;
  iyy(3,1) = 8;
  ixx(4,1) = 9;
  iyy(4,1) = 7;
  ixx(5,1) = 7;
  iyy(5,1) = 7;
  ixx(6,1) = 4;
  iyy(6,1) = 8;
  ixx(7,1) = 3;
  iyy(7,1) = 7;
  ixx(8,1) = 16;
  iyy(8,1) = 0;
  ixx(1,2) = 14;
  iyy(1,2) = 6;
  ixx(2,2) = 9;
  iyy(2,2) = 5;
  ixx(3,2) = 10;
  iyy(3,2) = 6;
  ixx(4,2) = 8;
  iyy(4,2) = 8;
  ixx(5,2) = 8;
  iyy(5,2) = 6;
  ixx(6,2) = 6;
  iyy(6,2) = 6;
  ixx(7,2) = 2;
  iyy(7,2) = 6;
  ixx(8,2) = 7;
  iyy(8,2) = 5;
  ixx(1,3) = 13;
  iyy(1,3) = 5;
  ixx(2,3) = 11;
  iyy(2,3) = 5;
  ixx(3,3) = 12;
  iyy(3,3) = 6;
  ixx(4,3) = 10;
  iyy(4,3) = 8;
  ixx(5,3) = 6;
  iyy(5,3) = 8;
  ixx(6,3) = 4;
  iyy(6,3) = 6;
  ixx(7,3) = 5;
  iyy(7,3) = 5;
  ixx(8,3) = 3;
  iyy(8,3) = 5;
  ixx(1,4) = 12;
  iyy(1,4) = 4;
  ixx(2,4) = 8;
  iyy(2,4) = 4;
  ixx(3,4) = 15;
  iyy(3,4) = 5;
  ixx(4,4) = 11;
  iyy(4,4) = 7;
  ixx(5,4) = 5;
  iyy(5,4) = 7;
  ixx(6,4) = 1;
  iyy(6,4) = 5;
  ixx(7,4) = 4;
  iyy(7,4) = 4;
  ixx(8,4) = 0;
  iyy(8,4) = 4;
  ixx(1,5) = 16;
  iyy(1,5) = 4;
  ixx(2,5) = 14;
  iyy(2,5) = 4;
  ixx(3,5) = 10;
  iyy(3,5) = 4;
  ixx(4,5) = 12;
  iyy(4,5) = 0;
  ixx(5,5) = 5;
  iyy(5,5) = 1;
  ixx(6,5) = 1;
  iyy(6,5) = 3;
  ixx(7,5) = 6;
  iyy(7,5) = 4;
  ixx(8,5) = 2;
  iyy(8,5) = 4;
  ixx(1,6) = 15;
  iyy(1,6) = 3;
  ixx(2,6) = 13;
  iyy(2,6) = 3;
  ixx(3,6) = 9;
  iyy(3,6) = 3;
  ixx(4,6) = 11;
  iyy(4,6) = 1;
  ixx(5,6) = 6;
  iyy(5,6) = 0;
  ixx(6,6) = 4;
  iyy(6,6) = 2;
  ixx(7,6) = 5;
  iyy(7,6) = 3;
  ixx(8,6) = 3;
  iyy(8,6) = 3;
  ixx(1,7) = 11;
  iyy(1,7) = 3;
  ixx(2,7) = 14;
  iyy(2,7) = 2;
  ixx(3,7) = 13;
  iyy(3,7) = 1;
  ixx(4,7) = 9;
  iyy(4,7) = 1;
  ixx(5,7) = 8;
  iyy(5,7) = 2;
  ixx(6,7) = 6;
  iyy(6,7) = 2;
  ixx(7,7) = 7;
  iyy(7,7) = 3;
  ixx(8,7) = 2;
  iyy(8,7) = 2;
  ixx(1,8) = 0;
  iyy(1,8) = 8;
  ixx(2,8) = 12;
  iyy(2,8) = 2;
  ixx(3,8) = 10;
  iyy(3,8) = 2;
  ixx(4,8) = 10;
  iyy(4,8) = 0;
  ixx(5,8) = 7;
  iyy(5,8) = 1;
  ixx(6,8) = 4;
  iyy(6,8) = 0;
  ixx(7,8) = 3;
  iyy(7,8) = 1;
  ixx(8,8) = 16;
  iyy(8,8) = 8;
