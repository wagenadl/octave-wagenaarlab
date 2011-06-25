OBJS=	findfirst_eq.mexglx findfirst_ne.mexglx \
	findfirst_ge.mexglx findfirst_gt.mexglx \
	findfirst_le.mexglx findfirst_lt.mexglx \
	findlast_eq.mexglx findlast_ne.mexglx \
	findlast_ge.mexglx findlast_gt.mexglx \
	findlast_le.mexglx findlast_lt.mexglx

MEX=mex32

#	crossseriesmatch_core.mexglx
#	extendpeaks_core.mexglx

deep: all subdirs

subdirs:

all: $(OBJS)

%.mexglx: %.c
	$(MEX) $^

%.mexglx: %.cpp
	$(MEX) -lstdc++ $^

clean:; rm -f $(OBJS)