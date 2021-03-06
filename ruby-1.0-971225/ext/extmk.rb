#! /usr/local/bin/ruby

if ARGV[0] == 'static'
  $force_static = TRUE
  ARGV.shift
elsif ARGV[0] == 'install'
  $install = TRUE
  ARGV.shift
elsif ARGV[0] == 'clean'
  $clean = TRUE
  ARGV.shift
end

$extlist = []

$cache_mod = FALSE;
$lib_cache = {}
$func_cache = {}
$hdr_cache = {}
$topdir = ".."
if $topdir !~ "^/"
  # get absolute path
  save = Dir.pwd
  Dir.chdir ".."
  $topdir = Dir.pwd
  Dir.chdir save
end

if File.exist?("config.cache") then
  f = open("config.cache", "r")
  while f.gets
    case $_
    when /^lib: ([\w_]+) (yes|no)/
      $lib_cache[$1] = $2
    when /^func: ([\w_]+) (yes|no)/
      $func_cache[$1] = $2
    when /^hdr: (.+) (yes|no)/
      $hdr_cache[$1] = $2
    end
  end
  f.close
end

def older(file1, file2)
  if !File.exist?(file1) then
    return TRUE
  end
  if !File.exist?(file2) then
    return FALSE
  end
  if File.mtime(file1) < File.mtime(file2)
    return TRUE
  end
  return FALSE
end

if PLATFORM == "m68k-human"
CFLAGS = "-g -O2".gsub(/-c..-stack=[0-9]+ */, '')
LINK = "gcc -o conftest -I#{$topdir} " + CFLAGS + " %s -rdynamic %s conftest.c -ldl -lcrypt -lm  %s > nul 2>&1"
CPP = "gcc -E  -I#{$topdir} " + CFLAGS + " %s conftest.c > nul 2>&1"
else
CFLAGS = "-g -O2"
LINK = "gcc -o conftest -I#{$topdir} " + CFLAGS + " %s -rdynamic %s conftest.c %s > /dev/null 2>&1"
CPP = "gcc -E  -I#{$topdir} " + CFLAGS + " %s conftest.c > /dev/null 2>&1"
end

def try_link(libs)
  system(format(LINK, $CFLAGS, $LDFLAGS, libs))
end

def try_cpp
  system(format(CPP, $CFLAGS))
end

def have_library(lib, func)
  if $lib_cache[lib]
    if $lib_cache[lib] == "yes"
      if $libs
        $libs = "-l" + lib + " " + $libs 
      else
	$libs = "-l" + lib
      end
      return TRUE
    else
      return FALSE
    end
  end

  cfile = open("conftest.c", "w")
  cfile.printf "\
int main() { return 0; }
int t() { %s(); return 0; }
", func
  cfile.close

  begin
    if $libs
      libs = "-l" + lib + " " + $libs 
    else
      libs = "-l" + lib
    end
    unless try_link(libs)
      $lib_cache[lib] = 'no'
      $cache_mod = TRUE
      return FALSE
    end
  ensure
    system "rm -f conftest*"
  end

  $libs = libs
  $lib_cache[lib] = 'yes'
  $cache_mod = TRUE
  return TRUE
end

def have_func(func)
  if $func_cache[func]
    if $func_cache[func] == "yes"
      $defs.push(format("-DHAVE_%s", func.upcase))
      return TRUE
    else
      return FALSE
    end
  end

  cfile = open("conftest.c", "w")
  cfile.printf "\
char %s();
int main() { return 0; }
int t() { %s(); return 0; }
", func, func
  cfile.close

  libs = $libs
  libs = "" if libs == nil

  begin
    unless try_link(libs)
      $func_cache[func] = 'no'
      $cache_mod = TRUE
      return FALSE
    end
  ensure
    system "rm -f conftest*"
  end
  $defs.push(format("-DHAVE_%s", func.upcase))
  $func_cache[func] = 'yes'
  $cache_mod = TRUE
  return TRUE
end

def have_header(header)
  if $hdr_cache[header]
    if $hdr_cache[header] == "yes"
      header.tr!("a-z./\055", "A-Z___")
      $defs.push(format("-DHAVE_%s", header))
      return TRUE
    else
      return FALSE
    end
  end

  cfile = open("conftest.c", "w")
  cfile.printf "\
#include <%s>
", header
  cfile.close

  begin
    unless try_cpp
      $hdr_cache[header] = 'no'
      $cache_mod = TRUE
      return FALSE
    end
  ensure
    system "rm -f conftest*"
  end
  $hdr_cache[header] = 'yes'
  header.tr!("a-z./\055", "A-Z___")
  $defs.push(format("-DHAVE_%s", header))
  $cache_mod = TRUE
  return TRUE
end

def create_header()
  if $defs.length > 0
    hfile = open("extconf.h", "w")
    for line in $defs
      line =~ /^-D(.*)/
      hfile.printf "#define %s 1\n", $1
    end
    hfile.close
  end
end

def create_makefile(target)

  if $libs and "so" == "o"
    libs = $libs.split
    for lib in libs
      lib.sub!(/-l(.*)/, '"lib\1.a"')
    end
    $defs.push(format("-DEXTLIB='%s'", libs.join(",")))
  end
  $libs = "" unless $libs

  $srcdir = $topdir + "/ext/" + target
  mfile = open("Makefile", "w")
  mfile.printf "\
SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = #{$srcdir}

CC = gcc

CFLAGS   = %s -I#{$topdir} %s #$CFLAGS %s
DLDFLAGS =  #$LDFLAGS
LDSHARED = gcc -shared
", if $static then "" else "-fpic" end, CFLAGS, $defs.join(" ")

  mfile.printf "\

program_transform_name = -e s,x,x,
RUBY_INSTALL_NAME = `t='$(program_transform_name)'; echo ruby | sed $$t`

prefix = /usr/local
exec_prefix = ${prefix}
libdir = ${exec_prefix}/lib/$(RUBY_INSTALL_NAME)/i686-linux


#### End of system configuration section. ####
"
  mfile.printf "LOCAL_LIBS = %s\n", $local_libs if $local_libs
  mfile.printf "LIBS = %s\n", $libs
  mfile.printf "OBJS = "
  if !$objs then
    $objs = Dir["#{$topdir}/ext/#{target}/*.c"]
    for f in $objs
      f.sub!(/\.c$/, ".o")
    end
  end
  mfile.printf $objs.join(" ")
  mfile.printf "\n"

  dots = if "/usr/bin/install -c" =~ /^\// then "" else "#{$topdir}/ext/" end
  mfile.printf "\
TARGET = %s.%s

INSTALL = %s/usr/bin/install -c

binsuffix = 

all:		$(TARGET)

clean:;		@rm -f *.o *.so *.sl
		@rm -f Makefile extconf.h conftest.*
		@rm -f core ruby$(binsuffix) *~

realclean:	clean
", target,
    if $static then "o" else "so" end, dots

  if !$static
    mfile.printf "\

install:
	@test -d $(libdir) || mkdir $(libdir)
	$(INSTALL) $(TARGET) $(libdir)/$(TARGET)
"
  else
    mfile.printf "\

install:;
"
  end

  if !$static && "so" != "o"
    mfile.printf "\
$(TARGET): $(OBJS)
	$(LDSHARED) $(DLDFLAGS) -o $(TARGET) $(OBJS) $(LOCAL_LIBS) $(LIBS)
"
  elsif not File.exist?(target + ".c")
    if PLATFORM == "m68k-human"
      mfile.printf "\
$(TARGET): $(OBJS)
	ar cru $(TARGET) $(OBJS)
"
    elsif PLATFORM =~ "-nextstep"
      mfile.printf "\
$(TARGET): $(OBJS)
	cc -r $(CFLAGS) -o $(TARGET) $(OBJS)
"
    elsif $static
      mfile.printf "\
$(TARGET): $(OBJS)
	ld -r -o $(TARGET) $(OBJS)
"
    else
      mfile.printf "\
$(TARGET): $(OBJS)
	ld $(DLDFLAGS) -r -o $(TARGET) $(OBJS)
"
    end
  end

  if File.exist?("depend")
    dfile = open("depend", "r")
    mfile.printf "###\n"
    while line = dfile.gets()
      mfile.printf "%s", line
    end
    dfile.close
  end
  mfile.close
  if $static
    $extlist.push [$static,target]
  end
end

def extmake(target)
  if $force_static or $static_ext[target]
    $static = target
  else
    $static = FALSE
  end

  return if $nodynamic and not $static

  $local_libs = nil
  $libs = nil
  $objs = nil
  $CFLAGS = nil
  $LDFLAGS = nil

  begin
    system "mkdir " + target unless File.directory?(target)
    Dir.chdir target
    if $static_ext.size > 0 ||
      !File.exist?("./Makefile") ||
      older("./Makefile", "#{$topdir}/ext/Setup") ||
      older("./Makefile", "../extmk.rb") ||
      older("./Makefile", "./extconf.rb")
    then
      $defs = []
      if File.exist?("extconf.rb")
	load "extconf.rb"
      else
	create_makefile(target);
      end
    end
    if File.exist?("./Makefile")
      if $install
	system "make install"
      elsif $clean
	system "make clean"
      else
	system "make all"
      end
    end
    if $static
      $extlibs += " " + $LDFLAGS if $LDFLAGS
      $extlibs += " " + $local_libs if $local_libs
      $extlibs += " " + $libs if $libs
    end
  ensure
    Dir.chdir ".."
  end
end

# get static-link modules
$static_ext = {}
if File.file? "#{$topdir}/ext/Setup"
  f = open("#{$topdir}/ext/Setup") 
  while f.gets()
    $_.chop!
    sub!(/#.*$/, '')
    next if /^\s*$/
    if /^option +nodynamic/
      $nodynamic = TRUE
      next
    end
    $static_ext[$_.split[0]] = TRUE
  end
  f.close
end

for d in Dir["#{$topdir}/ext/*"]
  File.directory?(d) || next
  File.file?(d + "/MANIFEST") || next
  
  d = File.basename(d)
  if $install
    print "installing ", d, "\n"
  elsif $clean
    print "cleaning ", d, "\n"
  else
    print "compiling ", d, "\n"
  end
  extmake(d)
end

if $cache_mod
  f = open("config.cache", "w")
  for k,v in $lib_cache
    f.printf "lib: %s %s\n", k, v
  end
  for k,v in $func_cache
    f.printf "func: %s %s\n", k, v
  end
  for k,v in $hdr_cache
    f.printf "hdr: %s %s\n", k, v
  end
  f.close
end

exit if $install or $clean
if $extlist.size > 0
  for s,t in $extlist
    f = format("%s/%s.o", s, t)
    if File.exist?(f)
      $extinit += format("\
\tInit_%s();\n\
\trb_provide(\"%s.o\");\n\
", t, t)
      $extobjs += "ext/"
      $extobjs += f
      $extobjs += " "
    else
      FALSE
    end
  end

  if older("extinit.c", "#{$topdir}/ext/Setup")
    f = open("extinit.c", "w")
    f.printf "void Init_ext() {\n"
    f.printf $extinit
    f.printf "}\n"
    f.close
  end
  if older("extinit.o", "extinit.c")
    cmd = "gcc " + CFLAGS + " -c extinit.c"
    print cmd, "\n"
    system cmd or exit 1
  end

  Dir.chdir ".."

  if older("ruby", "#{$topdir}/ext/Setup") or older("ruby", "miniruby")
    `rm -f ruby`
  end

  $extobjs = "ext/extinit.o " + $extobjs
  system format('make ruby EXTOBJS="%s" EXTLIBS="%s"', $extobjs, $extlibs)
else
  Dir.chdir ".."
  if older("ruby", "miniruby")
    `rm -f ruby`
    `cp miniruby ruby`
  end
end

#Local variables:
# mode: ruby
#end:
