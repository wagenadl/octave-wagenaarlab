# artifilt/Makefile.am: part of meabench, an MEA recording and analysis tool
# Copyright (C) 2000-2002  Daniel Wagenaar (wagenaar@caltech.edu)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

EXTRA_salpa_SOURCES = Defs.H LocalFit.H SOLocalFit.H StreamLF.H EventReporter.H
bin_PROGRAMS=salpa posthocartifilt
salpa_SOURCES = salpa.C StreamLF.C
posthocartifilt_SOURCES = posthocartifilt.C LocalFit.C
include $(top_srcdir)/Makefile.base