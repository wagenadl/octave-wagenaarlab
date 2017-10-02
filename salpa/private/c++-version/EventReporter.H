/* artifilt/EventReporter.H: part of meabench, an MEA recording and analysis tool
** Copyright (C) 2000-2003  Daniel Wagenaar (wagenaar@caltech.edu)
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

#ifndef EVENTREPORTER_H

#define EVENTREPORTER_H

#include <common/MEABDefs.H>

#include <base/dbx.H>

class EventReporter {
public:
  class SalpaEvent {
  public:
    timeref_t time;
    int duration;
    short channel;
  };
  EventReporter(EventSFSrv *srv0, short hw0): srv(srv0), hw(hw0), t0(0) {
    //  sdbx("EventReporter: hw=%i srv=%p",hw,srv);
  }
  void reset(timeref_t t00) { t0=t00; }
  void report(timeref_t start, timeref_t end) {
//     sdbx("EventReporter: hw=%i srv=%p start=%Li end=%Li",
// 	 hw,srv,start,end);
    SalpaEvent *e=(SalpaEvent*)srv->wheretowrite();
    e->time=start-t0;
    e->duration = end-start;
    e->channel=hw;
    srv->donewriting(1);
  }
private:
  EventSFSrv *srv;
  short hw;
  timeref_t t0;
};

#endif
