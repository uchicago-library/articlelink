# always run gmake rather than make on FreeBSD
all .DEFAULT!
	gmake $@ $(MAKEFLAGS)
