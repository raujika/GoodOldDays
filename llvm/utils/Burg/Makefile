##===- utils/Burg/Makefile ------------------------------*- Makefile -*-===##
# 
#                     The LLVM Compiler Infrastructure
#
# This file was developed by the LLVM research group and is distributed under
# the University of Illinois Open Source License. See LICENSE.TXT for details.
# 
##===----------------------------------------------------------------------===##
LEVEL = ../..
TOOLNAME = burg
ExtraSource = gram.tab.c

include $(LEVEL)/Makefile.common

gram.tab.c gram.tab.h:: gram.yc
	$(VERB) $(BISON) -o gram.tab.c -d $<

$(SourceDir)/lex.c: gram.tab.h

clean::
	rm -rf gram.tab.h gram.tab.c core* *.aux *.log *.dvi sample sample.c tmp

#$(BUILD_OBJ_DIR)/Release/lex.o $(BUILD_OBJ_DIR)/Profile/lex.o $(BUILD_OBJ_DIR)/Debug/lex.o: gram.tab.h

doc.dvi: doc.tex
	latex doc; latex doc


test:: $(TOOLEXENAME_G) sample.gr
	$(TOOLEXENAME_G) -I     <sample.gr   >sample.c && $(CC) $(CFLAGS) -o sample sample.c && ./sample
	$(TOOLEXENAME_G) -I      sample.gr   >tmp && cmp tmp sample.c
	$(TOOLEXENAME_G) -I     <sample.gr -o tmp && cmp tmp sample.c
	$(TOOLEXENAME_G) -I      sample.gr -o tmp && cmp tmp sample.c
	$(TOOLEXENAME_G) -I -O0 <sample.gr   >tmp && cmp tmp sample.c
	$(TOOLEXENAME_G) -I -=  <sample.gr   >tmp && cmp tmp sample.c
	$(RM) -f tmp sample.c
