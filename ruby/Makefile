# Generated automatically from Makefile.in by configure.
SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = .
VPATH = .

CC = gcc -L/usr/local/lib -lgdbm -lgdbm_compat -lcrypt
DBM = -fpcc-struct-return
YACC = bison -y
INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644
MAKEINFO = makeinfo

CFLAGS = -g
LDFLAGS =  $(CFLAGS)
LIBS =  -lm
DEFS =  -DHAVE_UNISTD_H=1 -DHAVE_SYSCALL_H=1 -DHAVE_A_OUT_H=1 -DDIRENT=1 -DGETGROUPS_T=gid_t -DRETSIGTYPE=void -DHAVE_GETOPT_LONG=1 -DHAVE_MEMMOVE=1 -DHAVE_STRERROR=1 -DHAVE_STRTOUL=1 -DHAVE_STRDUP=1 -DHAVE_STRSTR=1 -DHAVE_SETENV=1 -DHAVE_KILLPG=1 -DHAVE_MKDIR=1 -DHAVE_STRFTIME=1 -DHAVE_SOCKET=1 -DHAVE_RANDOM=1 -DHAVE_WAIT4=1 -DHAVE_WAITPID=1 -DHAVE_ALLOCA_H=1 -DHAVE_ST_BLKSIZE=1 -DHAVE_ST_BLOCKS=1 -DHAVE_ST_RDEV=1

prefix = /usr/local
binprefix = 
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
infodir = $(prefix)/info

#### End of system configuration section. ####

.c.o:
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(DEFS) -I$(srcdir) -I$(srcdir)/lib $<

HDRS          = defines.h \
		dln.h \
		ident.h \
		io.h \
		node.h \
		re.h \
		regex.h \
		ruby.h \
		st.h \
		version.h

SRCS          = array.c \
		bignum.c \
		class.c \
		compar.c \
		dbm.c \
		dict.c \
		dir.c \
		dln.c \
		enum.c \
		error.c \
		etc.c \
		eval.c \
		file.c \
		gc.c \
		inits.c \
		io.c \
		math.c \
		methods.c \
		missing.c \
		numeric.c \
		object.c \
		pack.c \
		parse.y \
		process.c \
		random.c \
		range.c \
		re.c \
		regex.c \
		ruby.c \
		socket.c \
		sprintf.c \
		st.c \
		string.c \
		struct.c \
		time.c \
		variable.c \
		version.c

OBJS	      = array.o \
		bignum.o \
		class.o \
		compar.o \
		dbm.o \
		dict.o \
		dir.o \
		dln.o \
		enum.o \
		error.o \
		etc.o \
		eval.o \
		file.o \
		gc.o \
		inits.o \
		io.o \
		math.o \
		methods.o \
		missing.o \
		numeric.o \
		object.o \
		pack.o \
		parse.o \
		process.o \
		random.o \
		range.o \
		re.o \
		regex.o \
		ruby.o \
		socket.o \
		sprintf.o \
		st.o \
		string.o \
		struct.o \
		time.o \
		variable.o \
		version.o

DISTFILES = README NEWS TODO THANKS COPYING INSTALL \
ChangeLog Makefile.in configure.in \
$(HDRS) $(SRCS) configure

PROGRAM	      = ruby

all:		$(PROGRAM)

$(PROGRAM):     $(OBJS)
		@echo -n "Loading $(PROGRAM) ... "
		@rm -f $(PROGRAM)
		@$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o $(PROGRAM)
		@echo "done"

install: $(PROGMAM)
	$(INSTALL_PROGRAM) $(PROGRAM) $(bindir)/$(PROGRAM)

clean:;		@rm -f $(OBJS)

realclean:;	@rm -f $(OBJS)
		@rm -f core ruby *~

dbm.o:dbm.c
	$(CC) -c $(DBM) $(CFLAGS) $(CPPFLAGS) $(DEFS) -I$(srcdir) -I$(srcdir)/lib dbm.c

# Prevent GNU make v3 from overflowing arg limit on SysV.
.NOEXPORT:
###
parse.o : parse.y ruby.h defines.h env.h ident.h node.h st.h regex.h 
###
array.o : array.c ruby.h defines.h 
bignum.o : bignum.c ruby.h defines.h 
class.o : class.c ruby.h defines.h env.h node.h st.h 
compar.o : compar.c ruby.h defines.h 
dbm.o : dbm.c ruby.h defines.h 
dict.o : dict.c ruby.h defines.h st.h 
dir.o : dir.c ruby.h defines.h 
dln.o : dln.c defines.h dln.h 
enum.o : enum.c ruby.h defines.h 
error.o : error.c ruby.h defines.h env.h 
etc.o : etc.c ruby.h defines.h 
eval.o : eval.c ruby.h defines.h env.h node.h ident.h st.h 
file.o : file.c ruby.h defines.h io.h 
gc.o : gc.c ruby.h defines.h env.h st.h 
inits.o : inits.c 
io.o : io.c ruby.h defines.h io.h 
math.o : math.c ruby.h defines.h 
methods.o : methods.c ruby.h defines.h env.h node.h 
missing.o : missing.c ruby.h defines.h missing/memmove.c missing/strerror.c \
  missing/strtoul.c missing/strftime.c missing/strstr.c missing/getopt.h missing/getopt.c \
  missing/getopt1.c missing/mkdir.c 
numeric.o : numeric.c ruby.h defines.h env.h 
object.o : object.c ruby.h defines.h env.h node.h st.h 
pack.o : pack.c ruby.h defines.h 
process.o : process.c ruby.h defines.h st.h 
random.o : random.c ruby.h defines.h 
range.o : range.c ruby.h defines.h 
re.o : re.c ruby.h defines.h re.h regex.h 
regex.o : regex.c regex.h 
ruby.o : ruby.c ruby.h defines.h re.h regex.h missing/getopt.h 
socket.o : socket.c ruby.h defines.h 
sprintf.o : sprintf.c ruby.h defines.h 
st.o : st.c st.h 
string.o : string.c ruby.h defines.h re.h regex.h 
struct.o : struct.c ruby.h defines.h env.h 
time.o : time.c ruby.h defines.h 
variable.o : variable.c ruby.h defines.h env.h node.h ident.h st.h 
version.o : version.c ruby.h defines.h version.h 
