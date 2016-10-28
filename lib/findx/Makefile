OBJS=	findfirst_eq.mex findfirst_ne.mex \
	findfirst_ge.mex findfirst_gt.mex \
	findfirst_le.mex findfirst_lt.mex \
	findlast_eq.mex findlast_ne.mex \
	findlast_ge.mex findlast_gt.mex \
	findlast_le.mex findlast_lt.mex \
	crossseriesmatch_core.mex \
	binsearch_core.mex

MEX=mkoctfile --mex

#	crossseriesmatch_core.mex
#	extendpeaks_core.mex

deep: all subdirs

subdirs:

all: $(OBJS)

%.mex: %.c
	$(MEX) $^

%.mex: %.cpp
	$(MEX) $^

clean:; rm -f $(OBJS)
