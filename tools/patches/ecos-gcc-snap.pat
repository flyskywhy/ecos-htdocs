Index: config.sub
===================================================================
RCS file: /cvs/gcc/egcs/config.sub,v
retrieving revision 1.30.4.1
diff -u -5 -p -r1.30.4.1 config.sub
--- config.sub	1999/08/04 08:09:26	1.30.4.1
+++ config.sub	2000/03/16 14:42:49
@@ -67,10 +67,20 @@ case $1 in
 		;;
 	*)
 	;;
 esac
 
+# Here we handle any "marketing" names - translating them to
+#  standard triplets
+case $1 in
+        mips-tx39-elf)
+                set mipstx39-unknown-elf
+                ;;
+        *)
+                ;;
+esac
+
 # Separate what the user gave into CPU-COMPANY and OS or KERNEL-OS (if any).
 # Here we must recognize all the valid KERNEL-OS combinations.
 maybe_os=`echo $1 | sed 's/^\(.*\)-\([^-]*-[^-]*\)$/\2/'`
 case $maybe_os in
   linux-gnu*)
--- gcc/configure.in.jif	Mon Mar 20 08:02:13 2000
+++ gcc/configure.in	Mon Mar 20 08:06:26 2000
@@ -2859,6 +2859,10 @@
 		tm_file="mips/elforion.h mips/elf64.h mips/rtems64.h"
 		tmake_file="mips/t-elf t-rtems"
 		;;
+        mips64vr4300-*-elf*)
+                tm_file="mips/elfb4300.h"
+                tmake_file=mips/t-vr4300
+                ;;
 	mipstx39el-*-elf*)
 		tm_file="mips/r3900.h mips/elfl.h mips/abi64.h"
 		tmake_file=mips/t-r3900
--- gcc/configure.jif	Mon Mar 20 08:02:17 2000
+++ gcc/configure	Mon Mar 20 08:06:59 2000
@@ -5475,6 +5475,10 @@
 		tm_file="mips/elforion.h mips/elf64.h mips/rtems64.h"
 		tmake_file="mips/t-elf t-rtems"
 		;;
+        mips64vr4300-*-elf*)
+                tm_file="mips/elfb4300.h"
+                tmake_file=mips/t-vr4300
+                ;;
 	mipstx39el-*-elf*)
 		tm_file="mips/r3900.h mips/elfl.h mips/abi64.h"
 		tmake_file=mips/t-r3900
--- /dev/null	Tue May  5 21:32:27 1998
+++ gcc/config/mips/t-vr4300	Mon Mar 20 08:09:00 2000
@@ -0,0 +1,75 @@
+CONFIG2_H	= $(srcdir)/config/mips/elf.h
+
+# Suppress building libgcc1.a, since the MIPS compiler port is complete
+# and does not need anything from libgcc1.a.
+LIBGCC1 =
+CROSS_LIBGCC1 =
+
+# We must build libgcc2.a with -G 0, in case the user wants to link
+# without the $gp register.
+TARGET_LIBGCC2_CFLAGS = -G 0
+
+# These are really part of libgcc1, but this will cause them to be
+# built correctly, so... [taken from t-sparclite]
+LIB2FUNCS_EXTRA = fp-bit.c dp-bit.c $(srcdir)/config/mips/mips16.S
+
+dp-bit.c: $(srcdir)/config/fp-bit.c
+	echo '#ifdef __MIPSEL__' > dp-bit.c
+	echo '#define FLOAT_BIT_ORDER_MISMATCH' >> dp-bit.c
+	echo '#endif' >> dp-bit.c
+	echo '#define US_SOFTWARE_GOFAST' >> dp-bit.c
+	cat $(srcdir)/config/fp-bit.c >> dp-bit.c
+
+fp-bit.c: $(srcdir)/config/fp-bit.c
+	echo '#define FLOAT' > fp-bit.c
+	echo '#ifdef __MIPSEL__' >> fp-bit.c
+	echo '#define FLOAT_BIT_ORDER_MISMATCH' >> fp-bit.c
+	echo '#endif' >> fp-bit.c
+	echo '#define US_SOFTWARE_GOFAST' >> fp-bit.c
+	cat $(srcdir)/config/fp-bit.c >> fp-bit.c
+
+# Build the libraries for hard floating point only
+
+MULTILIB_OPTIONS = EL/EB mgp32
+MULTILIB_DIRNAMES = el eb mgp32
+MULTILIB_MATCHES = EL=mel EB=meb
+
+EXTRA_MULTILIB_PARTS = crtbegin.o crtend.o
+# Don't let CTOR_LIST end up in sdata section.
+CRTSTUFF_T_CFLAGS = -G 0
+
+LIBGCC = stmp-multilib
+INSTALL_LIBGCC = install-multilib
+
+# Add additional dependencies to recompile selected modules whenever the
+# tm.h file changes.  The files compiled are:
+#
+#	gcc.c		(*_SPEC changes)
+#	toplev.c	(new switches + assembly output changes)
+#	sdbout.c	(debug format changes)
+#	dbxout.c	(debug format changes)
+#	dwarfout.c	(debug format changes)
+#	final.c		(assembly output changes)
+#	varasm.c	(assembly output changes)
+#	cse.c		(cost functions)
+#	insn-output.c	(possible ifdef changes in tm.h)
+#	regclass.c	(fixed/call used register changes)
+#	cccp.c		(new preprocessor macros, -v version #)
+#	explow.c	(GO_IF_LEGITIMATE_ADDRESS)
+#	recog.c		(GO_IF_LEGITIMATE_ADDRESS)
+#	reload.c	(GO_IF_LEGITIMATE_ADDRESS)
+
+gcc.o: $(CONFIG2_H)
+toplev.o: $(CONFIG2_H)
+sdbout.o: $(CONFIG2_H)
+dbxout.o: $(CONFIG2_H)
+dwarfout.o: $(CONFIG2_H)
+final.o: $(CONFIG2_H)
+varasm.o: $(CONFIG2_H)
+cse.o: $(CONFIG2_H)
+insn-output.o: $(CONFIG2_H)
+regclass.o: $(CONFIG2_H)
+cccp.o: $(CONFIG2_H)
+explow.o: $(CONFIG2_H)
+recog.o: $(CONFIG2_H)
+reload.o: $(CONFIG2_H)
--- /dev/null	Tue May  5 21:32:27 1998
+++ gcc/config/mips/elfb4300.h	Mon Mar 20 08:10:45 2000
@@ -0,0 +1,41 @@
+/* Definitions of target machine for GNU compiler.
+   NEC VR4300 version.
+   Copyright (c) 1995 Cygnus Support Inc.
+
+This file is part of GNU CC.
+
+GNU CC is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 2, or (at your option)
+any later version.
+
+GNU CC is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with GNU CC; see the file COPYING.  If not, write to
+the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */
+
+#define MIPS_CPU_STRING_DEFAULT "VR4300"
+
+#define DWARF2_DEBUGGING_INFO
+#define PREFERRED_DEBUGGING_TYPE DWARF2_DEBUG
+
+#define SUBTARGET_ASM_DEBUGGING_SPEC "\
+%{!mmips-as: \
+  %{g:-g0} %{g0:-g0} %{g1:-g0} %{g2:-g0} %{g3:-g0} \
+  %{ggdb:-g0} %{ggdb0:-g0} %{ggdb1:-g0} %{ggdb2:-g0} %{ggdb3:-g0} \
+  %{gdwarf-2*:-g0}} \
+%{gstabs:-g} %{gstabs0:-g0} %{gstabs1:-g1} %{gstabs2:-g2} %{gstabs3:-g3} \
+%{gstabs+:-g} %{gstabs+0:-g0} %{gstabs+1:-g1} %{gstabs+2:-g2} %{gstabs+3:-g3} \
+%{gcoff:-g} %{gcoff0:-g0} %{gcoff1:-g1} %{gcoff2:-g2} %{gcoff3:-g3}"
+
+#include "mips/elf64.h"
+
+#undef MULTILIB_DEFAULTS
+#define MULTILIB_DEFAULTS { "EB" }
+
+#undef CPP_PREDEFINES
+#define CPP_PREDEFINES "-Dmips -DMIPSEB -DR4300 -D_mips -D_MIPSEB -D_R4300"