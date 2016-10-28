ALL: matchupx_core.oct
clean:; rm -f *.oct

%.oct: %.cpp
	mkoctfile -std=c++11 $<
