/* base/Error.H: part of meabench, an MEA recording and analysis tool
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

// Error.H

#ifndef ERROR_H

#define ERROR_H

#include <errno.h>
#include <string.h>
#include <stdio.h>

#include <string>
using namespace std;

class Error {
public:
  Error(string issuer0="", string cause0="") {
    issuer=issuer0;
    cause=cause0;
  }
  virtual ~Error() {}
  void report(char const *src=0) const {
    if (src)
      fprintf(stderr,"%s: %s\n",src,msg().c_str());
    else
      fprintf(stderr,"%s\n",msg().c_str());
  }
  void reportnotice(char const *src=0) const {
    if (src)
      fprintf(stderr,"(%s: Notice from %s: %s)\n",src,issuer.c_str(),cause.c_str());
    else
      fprintf(stderr,"(Notice from %s: %s)\n",issuer.c_str(),cause.c_str());
  }
  void reportfatal(char const *src=0) const {
    if (src)
      fprintf(stderr,"%s: FATAL %s\n",src,msg().c_str());
    else
      fprintf(stderr,"FATAL %s\n",msg().c_str());
  }
  virtual string msg() const {
    return string("Error from ") + issuer + ": " + cause;
  }
protected:
  string issuer;
  string cause;
};

class Expectable: public Error {
public:
  Expectable(string issuer0="", string cause0=""): Error(issuer0, cause0) {
  }
  virtual string msg() const {
    return string("Notice from ") + issuer + ": " + cause;
  }
};

class Usage: public Error {
public:
  Usage(string issuer0="", string cause0=""): Error(issuer0,cause0) {
  }
  virtual string msg() const {
    return string("Usage: ") + issuer + " " + cause;
  }
};

class SysErr: public Error {
public:
  SysErr(string issuer0="", string cause0=""): Error(issuer0,cause0) {
    sysno = errno;
    sysmsg = strerror(errno);
  }
  virtual string msg() const {
    if (sysno==EINTR)
      return string("Interrupt in ") + issuer + " ("+cause+")"; // oops - should've thrown Intr
    else
      return string("Error from ") + issuer.c_str() + ": " +
	cause.c_str() + " [" + sysmsg.c_str() +"]";
  }
private:
  int sysno;
  string sysmsg;
};

class Intr: public Error {
public:
  Intr(): Error() { }
  virtual string msg() const {
    return "(Interrupt)";
  }
};

class PlainErr: public Error {
public:
  PlainErr(string cause0=""): Error("",cause0) { }
  virtual string msg() const { return cause; }
};

#endif
