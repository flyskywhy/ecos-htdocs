Index: gcc/Makefile.in
===================================================================
RCS file: /cvs/gcc/egcs/gcc/Makefile.in,v
retrieving revision 1.264.4.6
diff -u -5 -p -r1.264.4.6 Makefile.in
--- gcc/Makefile.in	1999/08/13 07:46:55	1.264.4.6
+++ gcc/Makefile.in	2000/03/02 23:22:53
@@ -350,18 +350,25 @@ LIBGCC2 = libgcc2.a
 # -g1 causes output of debug info only for file-scope entities.
 # we use this here because that should be enough, and also
 # so that -g1 will be tested.
 #
 LIBGCC2_DEBUG_CFLAGS = -g1
-LIBGCC2_CFLAGS = -O2 $(LIBGCC2_INCLUDES) $(GCC_CFLAGS) $(TARGET_LIBGCC2_CFLAGS) $(LIBGCC2_DEBUG_CFLAGS) $(GTHREAD_FLAGS) -DIN_LIBGCC2 -D__GCC_FLOAT_NOT_NEEDED @inhibit_libc@ 
+LIBGCC2_CFLAGS = -O2 $(LIBGCC2_INCLUDES) $(GCC_CFLAGS) $(TARGET_LIBGCC2_CFLAGS) $(EXTRA_TARGET_LIBGCC2_CFLAGS) $(LIBGCC2_DEBUG_CFLAGS) $(GTHREAD_FLAGS) -DIN_LIBGCC2 -D__GCC_FLOAT_NOT_NEEDED @inhibit_libc@ $(USER_TARGET_LIBGCC2_CFLAGS)
 
 # Additional options to use when compiling libgcc2.a.
 # Some targets override this to -Iinclude
 LIBGCC2_INCLUDES =
 
 # Additional target-dependent options for compiling libgcc2.a.
 TARGET_LIBGCC2_CFLAGS = 
+
+# Other target-dependent options that are supplied by configure
+EXTRA_TARGET_LIBGCC2_CFLAGS=@extra_target_libgcc2_cflags@
+
+# This hook allows the user to override flags or supply extra flags on the
+# command-line
+USER_TARGET_LIBGCC2_CFLAGS=
 
 # Things which must be built before building libgcc2.a.
 # Some targets override this to stmp-int-hdrs
 LIBGCC2_DEPS =
 
Index: gcc/configure.in
===================================================================
RCS file: /cvs/gcc/egcs/gcc/configure.in,v
retrieving revision 1.246.4.12
diff -u -5 -p -r1.246.4.12 configure.in
--- gcc/configure.in	1999/10/13 07:58:02	1.246.4.12
+++ gcc/configure.in	2000/03/02 23:23:05
@@ -1020,10 +1020,18 @@ changequote([,])dnl
 		use_collect2=yes
 		;;
 	i370-*-mvs*)
 		;;
 changequote(,)dnl
+	i[34567]86-*-elf*)
+changequote([,])dnl
+		xm_file="${xm_file} xm-svr4.h i386/xm-sysv4.h"
+		tm_file=i386/i386elf.h
+		tmake_file=i386/t-i386elf
+		xmake_file=x-svr4
+		;;
+changequote(,)dnl
 	i[34567]86-ibm-aix*)		# IBM PS/2 running AIX
 changequote([,])dnl
                 if test x$gas = xyes
 		then
 			tm_file=i386/aix386.h
@@ -3197,10 +3205,24 @@ changequote([,])dnl
 		;;
 	sparclite-*-aout*)
 		tm_file="sparc/lite.h aoutos.h libgloss.h"
 		tmake_file=sparc/t-sparclite
 		;;
+	sparclite-*-elf*)
+		tm_file="sparc/liteelf.h"
+		tmake_file=sparc/t-sparclite
+                extra_parts="crtbegin.o crtend.o"
+		;;
+	sparc86x-*-aout*)
+		tm_file="sparc/sp86x-aout.h aoutos.h libgloss.h"
+		tmake_file=sparc/t-sp86x
+		;;
+	sparc86x-*-elf*)	
+		tm_file="sparc/sp86x-elf.h"
+		tmake_file=sparc/t-sp86x
+                extra_parts="crtbegin.o crtend.o"
+		;;
 	sparc64-*-aout*)
 		tmake_file=sparc/t-sp64
 		tm_file=sparc/sp64-aout.h
 		;;
 	sparc64-*-elf*)
@@ -3323,10 +3345,11 @@ changequote([,])dnl
 
 	# Distinguish i[34567]86
 	# Also, do not run mips-tfile on MIPS if using gas.
 	# Process --with-cpu= for PowerPC/rs6000
 	target_cpu_default2=
+        extra_target_libgcc2_cflags=
 	case $machine in
 	i486-*-*)
 		target_cpu_default2=1
 		;;
 	i586-*-*)
@@ -3375,15 +3398,19 @@ changequote([,])dnl
 				target_cpu_default2="TARGET_CPU_generic"
 				;;
 
 			# Distinguish cores, and major variants
 			# arm7m doesn't exist, but D & I don't affect code
+
+changequote(,)dnl
 			xarm[23678] | xarm250 | xarm[67][01]0 \
 			| xarm7m | xarm7dm | xarm7dmi | xarm7tdmi \
 			| xarm7100 | xarm7500 | xarm7500fe | xarm810 \
 			| xstrongarm | xstrongarm110 | xstrongarm1100)
+changequote([,])dnl
 				target_cpu_default2="TARGET_CPU_$with_cpu"
+                                extra_target_libgcc2_cflags="-mcpu=$with_cpu"
 				;;
 
 			xyes | xno)
 				echo "--with-cpu must be passed a value" 1>&2
 				exit 1
@@ -4375,10 +4402,11 @@ AC_SUBST(extra_cxx_objs)
 AC_SUBST(extra_headers_list)
 AC_SUBST(extra_objs)
 AC_SUBST(extra_parts)
 AC_SUBST(extra_passes)
 AC_SUBST(extra_programs)
+AC_SUBST(extra_target_libgcc2_cflags)
 AC_SUBST(fixinc_defs)
 AC_SUBST(float_h_file)
 AC_SUBST(gcc_gxx_include_dir)
 AC_SUBST(gcc_version)
 AC_SUBST(gcc_version_trigger)
Index: gcc/configure
===================================================================
RCS file: /cvs/gcc/egcs/gcc/configure,v
retrieving revision 1.242.4.12
diff -u -5 -p -r1.242.4.12 configure
--- gcc/configure	1999/10/13 07:58:02	1.242.4.12
+++ gcc/configure	2000/03/02 23:23:02
@@ -3442,10 +3442,16 @@ for machine in $build $host $target; do
 		target_cpu_default="MASK_PA_11"
 		use_collect2=yes
 		;;
 	i370-*-mvs*)
 		;;
+	i[34567]86-*-elf*)
+		xm_file="${xm_file} xm-svr4.h i386/xm-sysv4.h"
+		tm_file=i386/i386elf.h
+		tmake_file=i386/t-i386elf
+		xmake_file=x-svr4
+		;;
 	i[34567]86-ibm-aix*)		# IBM PS/2 running AIX
                 if test x$gas = xyes
 		then
 			tm_file=i386/aix386.h
 			extra_parts="crtbegin.o crtend.o"
@@ -5413,11 +5419,11 @@ for machine in $build $host $target; do
                 tm_file="sparc/sol2.h sparc/hal.h"
                 tmake_file="sparc/t-halos sparc/t-sol2"
                 xmake_file=sparc/x-sysv4
                 extra_parts="crt1.o crti.o crtn.o gmon.o crtbegin.o crtend.o"
                 case $machine in
-                *-*-solaris2.[0-4])
+                *-*-solaris2.0-4)
                         float_format=i128
                 ;;
                 *)
                         float_format=none
                         ;;
@@ -5500,10 +5506,24 @@ for machine in $build $host $target; do
 		;;
 	sparclite-*-aout*)
 		tm_file="sparc/lite.h aoutos.h libgloss.h"
 		tmake_file=sparc/t-sparclite
 		;;
+	sparclite-*-elf*)
+		tm_file="sparc/liteelf.h"
+		tmake_file=sparc/t-sparclite
+                extra_parts="crtbegin.o crtend.o"
+		;;
+	sparc86x-*-aout*)
+		tm_file="sparc/sp86x-aout.h aoutos.h libgloss.h"
+		tmake_file=sparc/t-sp86x
+		;;
+	sparc86x-*-elf*)	
+		tm_file="sparc/sp86x-elf.h"
+		tmake_file=sparc/t-sp86x
+                extra_parts="crtbegin.o crtend.o"
+		;;
 	sparc64-*-aout*)
 		tmake_file=sparc/t-sp64
 		tm_file=sparc/sp64-aout.h
 		;;
 	sparc64-*-elf*)
@@ -5626,10 +5646,11 @@ for machine in $build $host $target; do
 
 	# Distinguish i[34567]86
 	# Also, do not run mips-tfile on MIPS if using gas.
 	# Process --with-cpu= for PowerPC/rs6000
 	target_cpu_default2=
+        extra_target_libgcc2_cflags=
 	case $machine in
 	i486-*-*)
 		target_cpu_default2=1
 		;;
 	i586-*-*)
@@ -5678,15 +5699,17 @@ for machine in $build $host $target; do
 				target_cpu_default2="TARGET_CPU_generic"
 				;;
 
 			# Distinguish cores, and major variants
 			# arm7m doesn't exist, but D & I don't affect code
-			xarm23678 | xarm250 | xarm67010 \
+
+			xarm[23678] | xarm250 | xarm[67][01]0 \
 			| xarm7m | xarm7dm | xarm7dmi | xarm7tdmi \
 			| xarm7100 | xarm7500 | xarm7500fe | xarm810 \
 			| xstrongarm | xstrongarm110 | xstrongarm1100)
 				target_cpu_default2="TARGET_CPU_$with_cpu"
+                                extra_target_libgcc2_cflags="-mcpu=$with_cpu"
 				;;
 
 			xyes | xno)
 				echo "--with-cpu must be passed a value" 1>&2
 				exit 1
@@ -6047,30 +6070,30 @@ else
 fi
 
 
 
         echo $ac_n "checking for strerror in -lcposix""... $ac_c" 1>&6
-echo "configure:6044: checking for strerror in -lcposix" >&5
+echo "configure:6076: checking for strerror in -lcposix" >&5
 ac_lib_var=`echo cposix'_'strerror | sed 'y%./+-%__p_%'`
 if eval "test \"`echo '$''{'ac_cv_lib_$ac_lib_var'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   ac_save_LIBS="$LIBS"
 LIBS="-lcposix  $LIBS"
 cat > conftest.$ac_ext <<EOF
-#line 6052 "configure"
+#line 6084 "configure"
 #include "confdefs.h"
 /* Override any gcc2 internal prototype to avoid an error.  */
 /* We use char because int might match the return type of a gcc2
     builtin and then its argument prototype would still apply.  */
 char strerror();
 
 int main() {
 strerror()
 ; return 0; }
 EOF
-if { (eval echo configure:6063: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:6095: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   eval "ac_cv_lib_$ac_lib_var=yes"
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6089,16 +6112,16 @@ else
 fi
 
   
 
 echo $ac_n "checking for working const""... $ac_c" 1>&6
-echo "configure:6086: checking for working const" >&5
+echo "configure:6118: checking for working const" >&5
 if eval "test \"`echo '$''{'ac_cv_c_const'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6091 "configure"
+#line 6123 "configure"
 #include "confdefs.h"
 
 int main() {
 
 /* Ultrix mips cc rejects this.  */
@@ -6143,11 +6166,11 @@ ccp = (char const *const *) p;
   const int foo = 10;
 }
 
 ; return 0; }
 EOF
-if { (eval echo configure:6140: \"$ac_compile\") 1>&5; (eval $ac_compile) 2>&5; }; then
+if { (eval echo configure:6172: \"$ac_compile\") 1>&5; (eval $ac_compile) 2>&5; }; then
   rm -rf conftest*
   ac_cv_c_const=yes
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6164,25 +6187,25 @@ if test $ac_cv_c_const = no; then
 EOF
 
 fi
 
 echo $ac_n "checking for inline""... $ac_c" 1>&6
-echo "configure:6161: checking for inline" >&5
+echo "configure:6193: checking for inline" >&5
 if eval "test \"`echo '$''{'ac_cv_c_inline'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   ac_cv_c_inline=no
 for ac_kw in inline __inline__ __inline; do
   cat > conftest.$ac_ext <<EOF
-#line 6168 "configure"
+#line 6200 "configure"
 #include "confdefs.h"
 
 int main() {
 } $ac_kw foo() {
 ; return 0; }
 EOF
-if { (eval echo configure:6175: \"$ac_compile\") 1>&5; (eval $ac_compile) 2>&5; }; then
+if { (eval echo configure:6207: \"$ac_compile\") 1>&5; (eval $ac_compile) 2>&5; }; then
   rm -rf conftest*
   ac_cv_c_inline=$ac_kw; break
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6204,16 +6227,16 @@ EOF
 EOF
  ;;
 esac
 
 echo $ac_n "checking for off_t""... $ac_c" 1>&6
-echo "configure:6201: checking for off_t" >&5
+echo "configure:6233: checking for off_t" >&5
 if eval "test \"`echo '$''{'ac_cv_type_off_t'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6206 "configure"
+#line 6238 "configure"
 #include "confdefs.h"
 #include <sys/types.h>
 #if STDC_HEADERS
 #include <stdlib.h>
 #include <stddef.h>
@@ -6237,16 +6260,16 @@ if test $ac_cv_type_off_t = no; then
 EOF
 
 fi
 
 echo $ac_n "checking for size_t""... $ac_c" 1>&6
-echo "configure:6234: checking for size_t" >&5
+echo "configure:6266: checking for size_t" >&5
 if eval "test \"`echo '$''{'ac_cv_type_size_t'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6239 "configure"
+#line 6271 "configure"
 #include "confdefs.h"
 #include <sys/types.h>
 #if STDC_HEADERS
 #include <stdlib.h>
 #include <stddef.h>
@@ -6272,23 +6295,23 @@ EOF
 fi
 
 # The Ultrix 4.2 mips builtin alloca declared by alloca.h only works
 # for constant arguments.  Useless!
 echo $ac_n "checking for working alloca.h""... $ac_c" 1>&6
-echo "configure:6269: checking for working alloca.h" >&5
+echo "configure:6301: checking for working alloca.h" >&5
 if eval "test \"`echo '$''{'ac_cv_header_alloca_h'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6274 "configure"
+#line 6306 "configure"
 #include "confdefs.h"
 #include <alloca.h>
 int main() {
 char *p = alloca(2 * sizeof(int));
 ; return 0; }
 EOF
-if { (eval echo configure:6281: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:6313: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   ac_cv_header_alloca_h=yes
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6305,16 +6328,16 @@ if test $ac_cv_header_alloca_h = yes; th
 EOF
 
 fi
 
 echo $ac_n "checking for alloca""... $ac_c" 1>&6
-echo "configure:6302: checking for alloca" >&5
+echo "configure:6334: checking for alloca" >&5
 if eval "test \"`echo '$''{'ac_cv_func_alloca_works'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6307 "configure"
+#line 6339 "configure"
 #include "confdefs.h"
 
 #ifdef __GNUC__
 # define alloca __builtin_alloca
 #else
@@ -6338,11 +6361,11 @@ char *alloca ();
 
 int main() {
 char *p = (char *) alloca(1);
 ; return 0; }
 EOF
-if { (eval echo configure:6335: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:6367: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   ac_cv_func_alloca_works=yes
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6370,16 +6393,16 @@ if test $ac_cv_func_alloca_works = no; t
 #define C_ALLOCA 1
 EOF
 
 
 echo $ac_n "checking whether alloca needs Cray hooks""... $ac_c" 1>&6
-echo "configure:6367: checking whether alloca needs Cray hooks" >&5
+echo "configure:6399: checking whether alloca needs Cray hooks" >&5
 if eval "test \"`echo '$''{'ac_cv_os_cray'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6372 "configure"
+#line 6404 "configure"
 #include "confdefs.h"
 #if defined(CRAY) && ! defined(CRAY2)
 webecray
 #else
 wenotbecray
@@ -6400,16 +6423,16 @@ fi
 
 echo "$ac_t""$ac_cv_os_cray" 1>&6
 if test $ac_cv_os_cray = yes; then
 for ac_func in _getb67 GETB67 getb67; do
   echo $ac_n "checking for $ac_func""... $ac_c" 1>&6
-echo "configure:6397: checking for $ac_func" >&5
+echo "configure:6429: checking for $ac_func" >&5
 if eval "test \"`echo '$''{'ac_cv_func_$ac_func'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6402 "configure"
+#line 6434 "configure"
 #include "confdefs.h"
 /* System header to define __stub macros and hopefully few prototypes,
     which can conflict with char $ac_func(); below.  */
 #include <assert.h>
 /* Override any gcc2 internal prototype to avoid an error.  */
@@ -6428,11 +6451,11 @@ choke me
 $ac_func();
 #endif
 
 ; return 0; }
 EOF
-if { (eval echo configure:6425: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:6457: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   eval "ac_cv_func_$ac_func=yes"
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6455,19 +6478,19 @@ fi
 
 done
 fi
 
 echo $ac_n "checking stack direction for C alloca""... $ac_c" 1>&6
-echo "configure:6452: checking stack direction for C alloca" >&5
+echo "configure:6484: checking stack direction for C alloca" >&5
 if eval "test \"`echo '$''{'ac_cv_c_stack_direction'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   if test "$cross_compiling" = yes; then
   ac_cv_c_stack_direction=0
 else
   cat > conftest.$ac_ext <<EOF
-#line 6460 "configure"
+#line 6492 "configure"
 #include "confdefs.h"
 find_stack_direction ()
 {
   static char *addr = 0;
   auto char dummy;
@@ -6482,11 +6505,11 @@ find_stack_direction ()
 main ()
 {
   exit (find_stack_direction() < 0);
 }
 EOF
-if { (eval echo configure:6479: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext} && (./conftest; exit) 2>/dev/null
+if { (eval echo configure:6511: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext} && (./conftest; exit) 2>/dev/null
 then
   ac_cv_c_stack_direction=1
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6507,21 +6530,21 @@ fi
 
 for ac_hdr in unistd.h
 do
 ac_safe=`echo "$ac_hdr" | sed 'y%./+-%__p_%'`
 echo $ac_n "checking for $ac_hdr""... $ac_c" 1>&6
-echo "configure:6504: checking for $ac_hdr" >&5
+echo "configure:6536: checking for $ac_hdr" >&5
 if eval "test \"`echo '$''{'ac_cv_header_$ac_safe'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6509 "configure"
+#line 6541 "configure"
 #include "confdefs.h"
 #include <$ac_hdr>
 EOF
 ac_try="$ac_cpp conftest.$ac_ext >/dev/null 2>conftest.out"
-{ (eval echo configure:6514: \"$ac_try\") 1>&5; (eval $ac_try) 2>&5; }
+{ (eval echo configure:6546: \"$ac_try\") 1>&5; (eval $ac_try) 2>&5; }
 ac_err=`grep -v '^ *+' conftest.out | grep -v "^conftest.${ac_ext}\$"`
 if test -z "$ac_err"; then
   rm -rf conftest*
   eval "ac_cv_header_$ac_safe=yes"
 else
@@ -6546,16 +6569,16 @@ fi
 done
 
 for ac_func in getpagesize
 do
 echo $ac_n "checking for $ac_func""... $ac_c" 1>&6
-echo "configure:6543: checking for $ac_func" >&5
+echo "configure:6575: checking for $ac_func" >&5
 if eval "test \"`echo '$''{'ac_cv_func_$ac_func'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6548 "configure"
+#line 6580 "configure"
 #include "confdefs.h"
 /* System header to define __stub macros and hopefully few prototypes,
     which can conflict with char $ac_func(); below.  */
 #include <assert.h>
 /* Override any gcc2 internal prototype to avoid an error.  */
@@ -6574,11 +6597,11 @@ choke me
 $ac_func();
 #endif
 
 ; return 0; }
 EOF
-if { (eval echo configure:6571: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:6603: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   eval "ac_cv_func_$ac_func=yes"
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6599,19 +6622,19 @@ else
   echo "$ac_t""no" 1>&6
 fi
 done
 
 echo $ac_n "checking for working mmap""... $ac_c" 1>&6
-echo "configure:6596: checking for working mmap" >&5
+echo "configure:6628: checking for working mmap" >&5
 if eval "test \"`echo '$''{'ac_cv_func_mmap_fixed_mapped'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   if test "$cross_compiling" = yes; then
   ac_cv_func_mmap_fixed_mapped=no
 else
   cat > conftest.$ac_ext <<EOF
-#line 6604 "configure"
+#line 6636 "configure"
 #include "confdefs.h"
 
 /* Thanks to Mike Haertel and Jim Avera for this test.
    Here is a matrix of mmap possibilities:
 	mmap private not fixed
@@ -6747,11 +6770,11 @@ main()
 	unlink("conftestmmap");
 	exit(0);
 }
 
 EOF
-if { (eval echo configure:6744: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext} && (./conftest; exit) 2>/dev/null
+if { (eval echo configure:6776: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext} && (./conftest; exit) 2>/dev/null
 then
   ac_cv_func_mmap_fixed_mapped=yes
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6775,21 +6798,21 @@ fi
    for ac_hdr in argz.h limits.h locale.h nl_types.h malloc.h string.h \
 unistd.h sys/param.h
 do
 ac_safe=`echo "$ac_hdr" | sed 'y%./+-%__p_%'`
 echo $ac_n "checking for $ac_hdr""... $ac_c" 1>&6
-echo "configure:6772: checking for $ac_hdr" >&5
+echo "configure:6804: checking for $ac_hdr" >&5
 if eval "test \"`echo '$''{'ac_cv_header_$ac_safe'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6777 "configure"
+#line 6809 "configure"
 #include "confdefs.h"
 #include <$ac_hdr>
 EOF
 ac_try="$ac_cpp conftest.$ac_ext >/dev/null 2>conftest.out"
-{ (eval echo configure:6782: \"$ac_try\") 1>&5; (eval $ac_try) 2>&5; }
+{ (eval echo configure:6814: \"$ac_try\") 1>&5; (eval $ac_try) 2>&5; }
 ac_err=`grep -v '^ *+' conftest.out | grep -v "^conftest.${ac_ext}\$"`
 if test -z "$ac_err"; then
   rm -rf conftest*
   eval "ac_cv_header_$ac_safe=yes"
 else
@@ -6815,16 +6838,16 @@ done
 
    for ac_func in getcwd munmap putenv setenv setlocale strchr strcasecmp \
 strdup __argz_count __argz_stringify __argz_next
 do
 echo $ac_n "checking for $ac_func""... $ac_c" 1>&6
-echo "configure:6812: checking for $ac_func" >&5
+echo "configure:6844: checking for $ac_func" >&5
 if eval "test \"`echo '$''{'ac_cv_func_$ac_func'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6817 "configure"
+#line 6849 "configure"
 #include "confdefs.h"
 /* System header to define __stub macros and hopefully few prototypes,
     which can conflict with char $ac_func(); below.  */
 #include <assert.h>
 /* Override any gcc2 internal prototype to avoid an error.  */
@@ -6843,11 +6866,11 @@ choke me
 $ac_func();
 #endif
 
 ; return 0; }
 EOF
-if { (eval echo configure:6840: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:6872: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   eval "ac_cv_func_$ac_func=yes"
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6872,16 +6895,16 @@ done
 
    if test "${ac_cv_func_stpcpy+set}" != "set"; then
      for ac_func in stpcpy
 do
 echo $ac_n "checking for $ac_func""... $ac_c" 1>&6
-echo "configure:6869: checking for $ac_func" >&5
+echo "configure:6901: checking for $ac_func" >&5
 if eval "test \"`echo '$''{'ac_cv_func_$ac_func'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6874 "configure"
+#line 6906 "configure"
 #include "confdefs.h"
 /* System header to define __stub macros and hopefully few prototypes,
     which can conflict with char $ac_func(); below.  */
 #include <assert.h>
 /* Override any gcc2 internal prototype to avoid an error.  */
@@ -6900,11 +6923,11 @@ choke me
 $ac_func();
 #endif
 
 ; return 0; }
 EOF
-if { (eval echo configure:6897: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:6929: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   eval "ac_cv_func_$ac_func=yes"
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6934,23 +6957,23 @@ EOF
 
    fi
 
    if test $ac_cv_header_locale_h = yes; then
     echo $ac_n "checking for LC_MESSAGES""... $ac_c" 1>&6
-echo "configure:6931: checking for LC_MESSAGES" >&5
+echo "configure:6963: checking for LC_MESSAGES" >&5
 if eval "test \"`echo '$''{'am_cv_val_LC_MESSAGES'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 6936 "configure"
+#line 6968 "configure"
 #include "confdefs.h"
 #include <locale.h>
 int main() {
 return LC_MESSAGES
 ; return 0; }
 EOF
-if { (eval echo configure:6943: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:6975: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   am_cv_val_LC_MESSAGES=yes
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -6967,11 +6990,11 @@ echo "$ac_t""$am_cv_val_LC_MESSAGES" 1>&
 EOF
 
     fi
   fi
    echo $ac_n "checking whether NLS is requested""... $ac_c" 1>&6
-echo "configure:6964: checking whether NLS is requested" >&5
+echo "configure:6996: checking whether NLS is requested" >&5
         # Check whether --enable-nls or --disable-nls was given.
 if test "${enable_nls+set}" = set; then
   enableval="$enable_nls"
   USE_NLS=$enableval
 else
@@ -6987,11 +7010,11 @@ fi
       cat >> confdefs.h <<\EOF
 #define ENABLE_NLS 1
 EOF
 
       echo $ac_n "checking whether included gettext is requested""... $ac_c" 1>&6
-echo "configure:6984: checking whether included gettext is requested" >&5
+echo "configure:7016: checking whether included gettext is requested" >&5
       # Check whether --with-included-gettext or --without-included-gettext was given.
 if test "${with_included_gettext+set}" = set; then
   withval="$with_included_gettext"
   nls_cv_force_use_gnu_gettext=$withval
 else
@@ -7006,21 +7029,21 @@ fi
 	nls_cv_header_libgt=
 	CATOBJEXT=NONE
 
 	ac_safe=`echo "libintl.h" | sed 'y%./+-%__p_%'`
 echo $ac_n "checking for libintl.h""... $ac_c" 1>&6
-echo "configure:7003: checking for libintl.h" >&5
+echo "configure:7035: checking for libintl.h" >&5
 if eval "test \"`echo '$''{'ac_cv_header_$ac_safe'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 7008 "configure"
+#line 7040 "configure"
 #include "confdefs.h"
 #include <libintl.h>
 EOF
 ac_try="$ac_cpp conftest.$ac_ext >/dev/null 2>conftest.out"
-{ (eval echo configure:7013: \"$ac_try\") 1>&5; (eval $ac_try) 2>&5; }
+{ (eval echo configure:7045: \"$ac_try\") 1>&5; (eval $ac_try) 2>&5; }
 ac_err=`grep -v '^ *+' conftest.out | grep -v "^conftest.${ac_ext}\$"`
 if test -z "$ac_err"; then
   rm -rf conftest*
   eval "ac_cv_header_$ac_safe=yes"
 else
@@ -7033,23 +7056,23 @@ fi
 rm -f conftest*
 fi
 if eval "test \"`echo '$ac_cv_header_'$ac_safe`\" = yes"; then
   echo "$ac_t""yes" 1>&6
   echo $ac_n "checking for gettext in libc""... $ac_c" 1>&6
-echo "configure:7030: checking for gettext in libc" >&5
+echo "configure:7062: checking for gettext in libc" >&5
 if eval "test \"`echo '$''{'gt_cv_func_gettext_libc'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 7035 "configure"
+#line 7067 "configure"
 #include "confdefs.h"
 #include <libintl.h>
 int main() {
 return (int) gettext ("")
 ; return 0; }
 EOF
-if { (eval echo configure:7042: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:7074: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   gt_cv_func_gettext_libc=yes
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -7061,30 +7084,30 @@ fi
 
 echo "$ac_t""$gt_cv_func_gettext_libc" 1>&6
 
 	   if test "$gt_cv_func_gettext_libc" != "yes"; then
 	     echo $ac_n "checking for bindtextdomain in -lintl""... $ac_c" 1>&6
-echo "configure:7058: checking for bindtextdomain in -lintl" >&5
+echo "configure:7090: checking for bindtextdomain in -lintl" >&5
 ac_lib_var=`echo intl'_'bindtextdomain | sed 'y%./+-%__p_%'`
 if eval "test \"`echo '$''{'ac_cv_lib_$ac_lib_var'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   ac_save_LIBS="$LIBS"
 LIBS="-lintl  $LIBS"
 cat > conftest.$ac_ext <<EOF
-#line 7066 "configure"
+#line 7098 "configure"
 #include "confdefs.h"
 /* Override any gcc2 internal prototype to avoid an error.  */
 /* We use char because int might match the return type of a gcc2
     builtin and then its argument prototype would still apply.  */
 char bindtextdomain();
 
 int main() {
 bindtextdomain()
 ; return 0; }
 EOF
-if { (eval echo configure:7077: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:7109: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   eval "ac_cv_lib_$ac_lib_var=yes"
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -7096,35 +7119,35 @@ LIBS="$ac_save_LIBS"
 
 fi
 if eval "test \"`echo '$ac_cv_lib_'$ac_lib_var`\" = yes"; then
   echo "$ac_t""yes" 1>&6
   echo $ac_n "checking for gettext in libintl""... $ac_c" 1>&6
-echo "configure:7093: checking for gettext in libintl" >&5
+echo "configure:7125: checking for gettext in libintl" >&5
 if eval "test \"`echo '$''{'gt_cv_func_gettext_libintl'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   echo $ac_n "checking for gettext in -lintl""... $ac_c" 1>&6
-echo "configure:7098: checking for gettext in -lintl" >&5
+echo "configure:7130: checking for gettext in -lintl" >&5
 ac_lib_var=`echo intl'_'gettext | sed 'y%./+-%__p_%'`
 if eval "test \"`echo '$''{'ac_cv_lib_$ac_lib_var'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   ac_save_LIBS="$LIBS"
 LIBS="-lintl  $LIBS"
 cat > conftest.$ac_ext <<EOF
-#line 7106 "configure"
+#line 7138 "configure"
 #include "confdefs.h"
 /* Override any gcc2 internal prototype to avoid an error.  */
 /* We use char because int might match the return type of a gcc2
     builtin and then its argument prototype would still apply.  */
 char gettext();
 
 int main() {
 gettext()
 ; return 0; }
 EOF
-if { (eval echo configure:7117: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:7149: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   eval "ac_cv_lib_$ac_lib_var=yes"
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -7159,11 +7182,11 @@ fi
 EOF
 
 	      # Extract the first word of "msgfmt", so it can be a program name with args.
 set dummy msgfmt; ac_word=$2
 echo $ac_n "checking for $ac_word""... $ac_c" 1>&6
-echo "configure:7156: checking for $ac_word" >&5
+echo "configure:7188: checking for $ac_word" >&5
 if eval "test \"`echo '$''{'ac_cv_path_MSGFMT'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   case "$MSGFMT" in
   /*)
@@ -7193,16 +7216,16 @@ else
 fi
 	      if test "$MSGFMT" != "no"; then
 		for ac_func in dcgettext
 do
 echo $ac_n "checking for $ac_func""... $ac_c" 1>&6
-echo "configure:7190: checking for $ac_func" >&5
+echo "configure:7222: checking for $ac_func" >&5
 if eval "test \"`echo '$''{'ac_cv_func_$ac_func'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 7195 "configure"
+#line 7227 "configure"
 #include "confdefs.h"
 /* System header to define __stub macros and hopefully few prototypes,
     which can conflict with char $ac_func(); below.  */
 #include <assert.h>
 /* Override any gcc2 internal prototype to avoid an error.  */
@@ -7221,11 +7244,11 @@ choke me
 $ac_func();
 #endif
 
 ; return 0; }
 EOF
-if { (eval echo configure:7218: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:7250: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   eval "ac_cv_func_$ac_func=yes"
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -7248,11 +7271,11 @@ fi
 done
 
 		# Extract the first word of "gmsgfmt", so it can be a program name with args.
 set dummy gmsgfmt; ac_word=$2
 echo $ac_n "checking for $ac_word""... $ac_c" 1>&6
-echo "configure:7245: checking for $ac_word" >&5
+echo "configure:7277: checking for $ac_word" >&5
 if eval "test \"`echo '$''{'ac_cv_path_GMSGFMT'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   case "$GMSGFMT" in
   /*)
@@ -7284,11 +7307,11 @@ else
 fi
 
 		# Extract the first word of "xgettext", so it can be a program name with args.
 set dummy xgettext; ac_word=$2
 echo $ac_n "checking for $ac_word""... $ac_c" 1>&6
-echo "configure:7281: checking for $ac_word" >&5
+echo "configure:7313: checking for $ac_word" >&5
 if eval "test \"`echo '$''{'ac_cv_path_XGETTEXT'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   case "$XGETTEXT" in
   /*)
@@ -7316,19 +7339,19 @@ if test -n "$XGETTEXT"; then
 else
   echo "$ac_t""no" 1>&6
 fi
 
 		cat > conftest.$ac_ext <<EOF
-#line 7313 "configure"
+#line 7345 "configure"
 #include "confdefs.h"
 
 int main() {
 extern int _nl_msg_cat_cntr;
 			       return _nl_msg_cat_cntr
 ; return 0; }
 EOF
-if { (eval echo configure:7321: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:7353: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   CATOBJEXT=.gmo
 		   DATADIRNAME=share
 else
   echo "configure: failed program was:" >&5
@@ -7347,11 +7370,11 @@ else
 fi
 
 
         if test "$CATOBJEXT" = "NONE"; then
 	  echo $ac_n "checking whether catgets can be used""... $ac_c" 1>&6
-echo "configure:7344: checking whether catgets can be used" >&5
+echo "configure:7376: checking whether catgets can be used" >&5
 	  # Check whether --with-catgets or --without-catgets was given.
 if test "${with_catgets+set}" = set; then
   withval="$with_catgets"
   nls_cv_use_catgets=$withval
 else
@@ -7360,26 +7383,26 @@ fi
 
 	  echo "$ac_t""$nls_cv_use_catgets" 1>&6
 
 	  if test "$nls_cv_use_catgets" = "yes"; then
 	    	    echo $ac_n "checking for main in -li""... $ac_c" 1>&6
-echo "configure:7357: checking for main in -li" >&5
+echo "configure:7389: checking for main in -li" >&5
 ac_lib_var=`echo i'_'main | sed 'y%./+-%__p_%'`
 if eval "test \"`echo '$''{'ac_cv_lib_$ac_lib_var'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   ac_save_LIBS="$LIBS"
 LIBS="-li  $LIBS"
 cat > conftest.$ac_ext <<EOF
-#line 7365 "configure"
+#line 7397 "configure"
 #include "confdefs.h"
 
 int main() {
 main()
 ; return 0; }
 EOF
-if { (eval echo configure:7372: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:7404: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   eval "ac_cv_lib_$ac_lib_var=yes"
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -7403,16 +7426,16 @@ EOF
 else
   echo "$ac_t""no" 1>&6
 fi
 
 	    echo $ac_n "checking for catgets""... $ac_c" 1>&6
-echo "configure:7400: checking for catgets" >&5
+echo "configure:7432: checking for catgets" >&5
 if eval "test \"`echo '$''{'ac_cv_func_catgets'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 7405 "configure"
+#line 7437 "configure"
 #include "confdefs.h"
 /* System header to define __stub macros and hopefully few prototypes,
     which can conflict with char catgets(); below.  */
 #include <assert.h>
 /* Override any gcc2 internal prototype to avoid an error.  */
@@ -7431,11 +7454,11 @@ choke me
 catgets();
 #endif
 
 ; return 0; }
 EOF
-if { (eval echo configure:7428: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
+if { (eval echo configure:7460: \"$ac_link\") 1>&5; (eval $ac_link) 2>&5; } && test -s conftest${ac_exeext}; then
   rm -rf conftest*
   eval "ac_cv_func_catgets=yes"
 else
   echo "configure: failed program was:" >&5
   cat conftest.$ac_ext >&5
@@ -7453,11 +7476,11 @@ EOF
 
 	       INTLOBJS="\$(CATOBJS)"
 	       # Extract the first word of "gencat", so it can be a program name with args.
 set dummy gencat; ac_word=$2
 echo $ac_n "checking for $ac_word""... $ac_c" 1>&6
-echo "configure:7450: checking for $ac_word" >&5
+echo "configure:7482: checking for $ac_word" >&5
 if eval "test \"`echo '$''{'ac_cv_path_GENCAT'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   case "$GENCAT" in
   /*)
@@ -7489,11 +7512,11 @@ else
 fi
 	       if test "$GENCAT" != "no"; then
 		 # Extract the first word of "gmsgfmt", so it can be a program name with args.
 set dummy gmsgfmt; ac_word=$2
 echo $ac_n "checking for $ac_word""... $ac_c" 1>&6
-echo "configure:7486: checking for $ac_word" >&5
+echo "configure:7518: checking for $ac_word" >&5
 if eval "test \"`echo '$''{'ac_cv_path_GMSGFMT'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   case "$GMSGFMT" in
   /*)
@@ -7526,11 +7549,11 @@ fi
 
 		 if test "$GMSGFMT" = "no"; then
 		   # Extract the first word of "msgfmt", so it can be a program name with args.
 set dummy msgfmt; ac_word=$2
 echo $ac_n "checking for $ac_word""... $ac_c" 1>&6
-echo "configure:7523: checking for $ac_word" >&5
+echo "configure:7555: checking for $ac_word" >&5
 if eval "test \"`echo '$''{'ac_cv_path_GMSGFMT'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   case "$GMSGFMT" in
   /*)
@@ -7561,11 +7584,11 @@ fi
 
 		 fi
 		 # Extract the first word of "xgettext", so it can be a program name with args.
 set dummy xgettext; ac_word=$2
 echo $ac_n "checking for $ac_word""... $ac_c" 1>&6
-echo "configure:7558: checking for $ac_word" >&5
+echo "configure:7590: checking for $ac_word" >&5
 if eval "test \"`echo '$''{'ac_cv_path_XGETTEXT'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   case "$XGETTEXT" in
   /*)
@@ -7619,11 +7642,11 @@ fi
       if test "$nls_cv_use_gnu_gettext" = "yes"; then
                 INTLOBJS="\$(GETTOBJS)"
         # Extract the first word of "msgfmt", so it can be a program name with args.
 set dummy msgfmt; ac_word=$2
 echo $ac_n "checking for $ac_word""... $ac_c" 1>&6
-echo "configure:7616: checking for $ac_word" >&5
+echo "configure:7648: checking for $ac_word" >&5
 if eval "test \"`echo '$''{'ac_cv_path_MSGFMT'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   case "$MSGFMT" in
   /*)
@@ -7653,11 +7676,11 @@ else
 fi
 
         # Extract the first word of "gmsgfmt", so it can be a program name with args.
 set dummy gmsgfmt; ac_word=$2
 echo $ac_n "checking for $ac_word""... $ac_c" 1>&6
-echo "configure:7650: checking for $ac_word" >&5
+echo "configure:7682: checking for $ac_word" >&5
 if eval "test \"`echo '$''{'ac_cv_path_GMSGFMT'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   case "$GMSGFMT" in
   /*)
@@ -7689,11 +7712,11 @@ else
 fi
 
         # Extract the first word of "xgettext", so it can be a program name with args.
 set dummy xgettext; ac_word=$2
 echo $ac_n "checking for $ac_word""... $ac_c" 1>&6
-echo "configure:7686: checking for $ac_word" >&5
+echo "configure:7718: checking for $ac_word" >&5
 if eval "test \"`echo '$''{'ac_cv_path_XGETTEXT'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   case "$XGETTEXT" in
   /*)
@@ -7782,11 +7805,11 @@ fi
    if test "x$CATOBJEXT" != "x"; then
      if test "x$ALL_LINGUAS" = "x"; then
        LINGUAS=
      else
        echo $ac_n "checking for catalogs to be installed""... $ac_c" 1>&6
-echo "configure:7779: checking for catalogs to be installed" >&5
+echo "configure:7811: checking for catalogs to be installed" >&5
        NEW_LINGUAS=
        for lang in ${LINGUAS=$ALL_LINGUAS}; do
          case "$ALL_LINGUAS" in
           *$lang*) NEW_LINGUAS="$NEW_LINGUAS $lang" ;;
          esac
@@ -7810,21 +7833,21 @@ echo "configure:7779: checking for catal
 
             test -d intl || mkdir intl
    if test "$CATOBJEXT" = ".cat"; then
      ac_safe=`echo "linux/version.h" | sed 'y%./+-%__p_%'`
 echo $ac_n "checking for linux/version.h""... $ac_c" 1>&6
-echo "configure:7807: checking for linux/version.h" >&5
+echo "configure:7839: checking for linux/version.h" >&5
 if eval "test \"`echo '$''{'ac_cv_header_$ac_safe'+set}'`\" = set"; then
   echo $ac_n "(cached) $ac_c" 1>&6
 else
   cat > conftest.$ac_ext <<EOF
-#line 7812 "configure"
+#line 7844 "configure"
 #include "confdefs.h"
 #include <linux/version.h>
 EOF
 ac_try="$ac_cpp conftest.$ac_ext >/dev/null 2>conftest.out"
-{ (eval echo configure:7817: \"$ac_try\") 1>&5; (eval $ac_try) 2>&5; }
+{ (eval echo configure:7849: \"$ac_try\") 1>&5; (eval $ac_try) 2>&5; }
 ac_err=`grep -v '^ *+' conftest.out | grep -v "^conftest.${ac_ext}\$"`
 if test -z "$ac_err"; then
   rm -rf conftest*
   eval "ac_cv_header_$ac_safe=yes"
 else
@@ -8054,11 +8077,11 @@ if test -f ../ld/Makefile; then
 #	fi
 fi
 
 # Figure out what assembler alignment features are present.
 echo $ac_n "checking assembler alignment features""... $ac_c" 1>&6
-echo "configure:8051: checking assembler alignment features" >&5
+echo "configure:8083: checking assembler alignment features" >&5
 gcc_cv_as=
 gcc_cv_as_alignment_features=
 gcc_cv_as_gas_srcdir=`echo $srcdir | sed -e 's,/gcc$,,'`/gas
 if test -x "$DEFAULT_ASSEMBLER"; then
 	gcc_cv_as="$DEFAULT_ASSEMBLER"
@@ -8175,11 +8198,11 @@ EOF
 	rm -f conftest.s conftest.o
 fi
 echo "$ac_t""$gcc_cv_as_alignment_features" 1>&6
 
 echo $ac_n "checking assembler subsection support""... $ac_c" 1>&6
-echo "configure:8172: checking assembler subsection support" >&5
+echo "configure:8204: checking assembler subsection support" >&5
 gcc_cv_as_subsections=
 if test x$gcc_cv_as != x; then
 	# Check if we have .subsection
 	echo ".subsection 1" > conftest.s
 	if $gcc_cv_as -o conftest.o conftest.s > /dev/null 2>&1; then
@@ -8215,11 +8238,11 @@ EOF
 	rm -f conftest.s conftest.o conftest.nm1 conftest.nm2
 fi
 echo "$ac_t""$gcc_cv_as_subsections" 1>&6
 
 echo $ac_n "checking assembler instructions""... $ac_c" 1>&6
-echo "configure:8212: checking assembler instructions" >&5
+echo "configure:8244: checking assembler instructions" >&5
 gcc_cv_as_instructions=
 if test x$gcc_cv_as != x; then
 	set "filds fists" "filds mem; fists mem"
 	while test $# -gt 0
   	do
@@ -8572,10 +8595,11 @@ ${CONFIG_SHELL-/bin/sh} $srcdir/configur
 
 
 
 
 
+
 # Echo that links are built
 if test x$host = x$target
 then
 	str1="native "
 else
@@ -8835,10 +8859,11 @@ s%@extra_cxx_objs@%$extra_cxx_objs%g
 s%@extra_headers_list@%$extra_headers_list%g
 s%@extra_objs@%$extra_objs%g
 s%@extra_parts@%$extra_parts%g
 s%@extra_passes@%$extra_passes%g
 s%@extra_programs@%$extra_programs%g
+s%@extra_target_libgcc2_cflags@%$extra_target_libgcc2_cflags%g
 s%@fixinc_defs@%$fixinc_defs%g
 s%@float_h_file@%$float_h_file%g
 s%@gcc_gxx_include_dir@%$gcc_gxx_include_dir%g
 s%@gcc_version@%$gcc_version%g
 s%@gcc_version_trigger@%$gcc_version_trigger%g
Index: gcc/reload1.c
===================================================================
RCS file: /cvs/gcc/egcs/gcc/reload1.c,v
retrieving revision 1.145.4.1
diff -u -5 -p -r1.145.4.1 reload1.c
--- gcc/reload1.c	1999/07/07 01:05:39	1.145.4.1
+++ gcc/reload1.c	2000/03/02 23:23:17
@@ -6266,25 +6266,41 @@ choose_reload_regs (chain)
     {
       for (j = 0; j < n_reloads; j++)
 	{
 	  register int r = reload_order[j];
 	  rtx check_reg;
+	  int check_regnum, nr, cant_inherit;
+
 	  if (reload_inherited[r] && reload_reg_rtx[r])
 	    check_reg = reload_reg_rtx[r];
 	  else if (reload_override_in[r]
 		   && (GET_CODE (reload_override_in[r]) == REG
 	    		     || GET_CODE (reload_override_in[r]) == SUBREG))
 	    check_reg = reload_override_in[r];
 	  else
 	    continue;
-	  if (! reload_reg_free_for_value_p (true_regnum (check_reg),
-	    				     reload_opnum[r],
-	    				     reload_when_needed[r],
-	    				     reload_in[r],
-	    				     (reload_inherited[r]
-					      ? reload_out[r] : const0_rtx),
-					     r, 1))
+
+	  /* ??? reload_reg_free_for_value_p does not correctly handle
+	     multi-word hard registers, so we loop and call it for each
+	     individual hard register.  All other places in reload that
+	     call this function will also have to be fixed.  */
+	  check_regnum = true_regnum (check_reg);
+	  nr = HARD_REGNO_NREGS (check_regnum, reload_mode[r]);
+	  cant_inherit = 0;
+	  for (i = check_regnum + nr - 1; i >= check_regnum; i--)
+	    if (! reload_reg_free_for_value_p (i, reload_opnum[r],
+					       reload_when_needed[r],
+					       reload_in[r],
+					       (reload_inherited[r]
+						? reload_out[r] : const0_rtx),
+					       r, 1))
+	      {
+		cant_inherit = 1;
+		break;
+	      }
+
+	  if (cant_inherit)
 	    {
 	      if (pass)
 		continue;
 	      reload_inherited[r] = 0;
 	      reload_override_in[r] = 0;
--- /dev/null	Tue May  5 21:32:27 1998
+++ gcc/config/i386/i386elf.h	Wed Mar  1 22:53:54 2000
@@ -0,0 +1,296 @@
+/* Target definitions for GNU compiler for Intel 80386 using ELF
+   Copyright (C) 1988, 1991, 1995 Free Software Foundation, Inc.
+
+   Derived from sysv4.h written by Ron Guilmette (rfg@netcom.com).
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
+/* Use stabs instead of DWARF debug format.  */
+#define PREFERRED_DEBUGGING_TYPE DBX_DEBUG
+
+#include "i386/i386.h"
+#include "i386/att.h"
+#include "elfos.h"
+
+#undef TARGET_VERSION
+#define TARGET_VERSION fprintf (stderr, " (i386 bare ELF target)");
+
+/* By default, target has a 80387, uses IEEE compatible arithmetic,
+   and returns float values in the 387, ie,
+   (TARGET_80387 | TARGET_IEEE_FP | TARGET_FLOAT_RETURNS_IN_80387) */
+
+#define TARGET_DEFAULT 0301
+
+/* The svr4 ABI for the i386 says that records and unions are returned
+   in memory.  */
+
+#undef RETURN_IN_MEMORY
+#define RETURN_IN_MEMORY(TYPE) \
+  (TYPE_MODE (TYPE) == BLKmode)
+
+/* Define which macros to predefine.  __svr4__ is our extension.  */
+/* This used to define X86, but james@bigtex.cactus.org says that
+   is supposed to be defined optionally by user programs--not by default.  */
+#define CPP_PREDEFINES \
+  "-D__i386__ -Acpu(i386) -Amachine(i386)"
+
+#undef CPP_SPEC
+#define CPP_SPEC "%(cpp_cpu)"
+
+/* This is how to output assembly code to define a `float' constant.
+   We always have to use a .long pseudo-op to do this because the native
+   SVR4 ELF assembler is buggy and it generates incorrect values when we
+   try to use the .float pseudo-op instead.  */
+
+#undef ASM_OUTPUT_FLOAT
+#define ASM_OUTPUT_FLOAT(FILE,VALUE)					\
+do { long value;							\
+     REAL_VALUE_TO_TARGET_SINGLE ((VALUE), value);			\
+     if (sizeof (int) == sizeof (long))					\
+         fprintf((FILE), "%s\t0x%x\n", ASM_LONG, value);		\
+     else								\
+         fprintf((FILE), "%s\t0x%lx\n", ASM_LONG, value);		\
+   } while (0)
+
+/* This is how to output assembly code to define a `double' constant.
+   We always have to use a pair of .long pseudo-ops to do this because
+   the native SVR4 ELF assembler is buggy and it generates incorrect
+   values when we try to use the the .double pseudo-op instead.  */
+
+#undef ASM_OUTPUT_DOUBLE
+#define ASM_OUTPUT_DOUBLE(FILE,VALUE)					\
+do { long value[2];							\
+     REAL_VALUE_TO_TARGET_DOUBLE ((VALUE), value);			\
+     if (sizeof (int) == sizeof (long))					\
+       {								\
+         fprintf((FILE), "%s\t0x%x\n", ASM_LONG, value[0]);		\
+         fprintf((FILE), "%s\t0x%x\n", ASM_LONG, value[1]);		\
+       }								\
+     else								\
+       {								\
+         fprintf((FILE), "%s\t0x%lx\n", ASM_LONG, value[0]);		\
+         fprintf((FILE), "%s\t0x%lx\n", ASM_LONG, value[1]);		\
+       }								\
+   } while (0)
+
+
+#undef ASM_OUTPUT_LONG_DOUBLE
+#define ASM_OUTPUT_LONG_DOUBLE(FILE,VALUE)				\
+do { long value[3];							\
+     REAL_VALUE_TO_TARGET_LONG_DOUBLE ((VALUE), value);			\
+     if (sizeof (int) == sizeof (long))					\
+       {								\
+         fprintf((FILE), "%s\t0x%x\n", ASM_LONG, value[0]);		\
+         fprintf((FILE), "%s\t0x%x\n", ASM_LONG, value[1]);		\
+         fprintf((FILE), "%s\t0x%x\n", ASM_LONG, value[2]);		\
+       }								\
+     else								\
+       {								\
+         fprintf((FILE), "%s\t0x%lx\n", ASM_LONG, value[0]);		\
+         fprintf((FILE), "%s\t0x%lx\n", ASM_LONG, value[1]);		\
+         fprintf((FILE), "%s\t0x%lx\n", ASM_LONG, value[2]);		\
+       }								\
+   } while (0)
+
+/* Output at beginning of assembler file.  */
+/* The .file command should always begin the output.  */
+
+#undef ASM_FILE_START
+#define ASM_FILE_START(FILE)						\
+  do {									\
+	output_file_directive (FILE, main_input_filename);		\
+	fprintf (FILE, "\t.version\t\"01.01\"\n");			\
+  } while (0)
+
+/* Define the register numbers to be used in Dwarf debugging information.
+   The SVR4 reference port C compiler uses the following register numbers
+   in its Dwarf output code:
+
+	0 for %eax (gnu regno = 0)
+	1 for %ecx (gnu regno = 2)
+	2 for %edx (gnu regno = 1)
+	3 for %ebx (gnu regno = 3)
+	4 for %esp (gnu regno = 7)
+	5 for %ebp (gnu regno = 6)
+	6 for %esi (gnu regno = 4)
+	7 for %edi (gnu regno = 5)
+
+   The following three DWARF register numbers are never generated by
+   the SVR4 C compiler or by the GNU compilers, but SDB on x86/svr4
+   believes these numbers have these meanings.
+
+	8  for %eip    (no gnu equivalent)
+	9  for %eflags (no gnu equivalent)
+	10 for %trapno (no gnu equivalent)
+
+   It is not at all clear how we should number the FP stack registers
+   for the x86 architecture.  If the version of SDB on x86/svr4 were
+   a bit less brain dead with respect to floating-point then we would
+   have a precedent to follow with respect to DWARF register numbers
+   for x86 FP registers, but the SDB on x86/svr4 is so completely
+   broken with respect to FP registers that it is hardly worth thinking
+   of it as something to strive for compatibility with.
+
+   The verison of x86/svr4 SDB I have at the moment does (partially)
+   seem to believe that DWARF register number 11 is associated with
+   the x86 register %st(0), but that's about all.  Higher DWARF
+   register numbers don't seem to be associated with anything in
+   particular, and even for DWARF regno 11, SDB only seems to under-
+   stand that it should say that a variable lives in %st(0) (when
+   asked via an `=' command) if we said it was in DWARF regno 11,
+   but SDB still prints garbage when asked for the value of the
+   variable in question (via a `/' command).
+
+   (Also note that the labels SDB prints for various FP stack regs
+   when doing an `x' command are all wrong.)
+
+   Note that these problems generally don't affect the native SVR4
+   C compiler because it doesn't allow the use of -O with -g and
+   because when it is *not* optimizing, it allocates a memory
+   location for each floating-point variable, and the memory
+   location is what gets described in the DWARF AT_location
+   attribute for the variable in question.
+
+   Regardless of the severe mental illness of the x86/svr4 SDB, we
+   do something sensible here and we use the following DWARF
+   register numbers.  Note that these are all stack-top-relative
+   numbers.
+
+	11 for %st(0) (gnu regno = 8)
+	12 for %st(1) (gnu regno = 9)
+	13 for %st(2) (gnu regno = 10)
+	14 for %st(3) (gnu regno = 11)
+	15 for %st(4) (gnu regno = 12)
+	16 for %st(5) (gnu regno = 13)
+	17 for %st(6) (gnu regno = 14)
+	18 for %st(7) (gnu regno = 15)
+*/
+
+#undef DBX_REGISTER_NUMBER
+#define DBX_REGISTER_NUMBER(n) \
+((n) == 0 ? 0 \
+ : (n) == 1 ? 2 \
+ : (n) == 2 ? 1 \
+ : (n) == 3 ? 3 \
+ : (n) == 4 ? 6 \
+ : (n) == 5 ? 7 \
+ : (n) == 6 ? 5 \
+ : (n) == 7 ? 4 \
+ : ((n) >= FIRST_STACK_REG && (n) <= LAST_STACK_REG) ? (n)+3 \
+ : (-1))
+
+/* The routine used to output sequences of byte values.  We use a special
+   version of this for most svr4 targets because doing so makes the
+   generated assembly code more compact (and thus faster to assemble)
+   as well as more readable.  Note that if we find subparts of the
+   character sequence which end with NUL (and which are shorter than
+   STRING_LIMIT) we output those using ASM_OUTPUT_LIMITED_STRING.  */
+
+#undef ASM_OUTPUT_ASCII
+#define ASM_OUTPUT_ASCII(FILE, STR, LENGTH)				\
+  do									\
+    {									\
+      register unsigned char *_ascii_bytes = (unsigned char *) (STR);	\
+      register unsigned char *limit = _ascii_bytes + (LENGTH);		\
+      register unsigned bytes_in_chunk = 0;				\
+      for (; _ascii_bytes < limit; _ascii_bytes++)			\
+        {								\
+	  register unsigned char *p;					\
+	  if (bytes_in_chunk >= 64)					\
+	    {								\
+	      fputc ('\n', (FILE));					\
+	      bytes_in_chunk = 0;					\
+	    }								\
+	  for (p = _ascii_bytes; p < limit && *p != '\0'; p++)		\
+	    continue;							\
+	  if (p < limit && (p - _ascii_bytes) <= STRING_LIMIT)		\
+	    {								\
+	      if (bytes_in_chunk > 0)					\
+		{							\
+		  fputc ('\n', (FILE));					\
+		  bytes_in_chunk = 0;					\
+		}							\
+	      ASM_OUTPUT_LIMITED_STRING ((FILE), _ascii_bytes);		\
+	      _ascii_bytes = p;						\
+	    }								\
+	  else								\
+	    {								\
+	      if (bytes_in_chunk == 0)					\
+		fprintf ((FILE), "\t.byte\t");				\
+	      else							\
+		fputc (',', (FILE));					\
+	      fprintf ((FILE), "0x%02x", *_ascii_bytes);		\
+	      bytes_in_chunk += 5;					\
+	    }								\
+	}								\
+      if (bytes_in_chunk > 0)						\
+        fprintf ((FILE), "\n");						\
+    }									\
+  while (0)
+
+/* This is how to output an element of a case-vector that is relative.
+   This is only used for PIC code.  See comments by the `casesi' insn in
+   i386.md for an explanation of the expression this outputs. */
+
+#undef ASM_OUTPUT_ADDR_DIFF_ELT
+#define ASM_OUTPUT_ADDR_DIFF_ELT(FILE, BODY, VALUE, REL) \
+  fprintf (FILE, "\t.long _GLOBAL_OFFSET_TABLE_+[.-%s%d]\n", LPREFIX, VALUE)
+
+/* Indicate that jump tables go in the text section.  This is
+   necessary when compiling PIC code.  */
+
+#define JUMP_TABLES_IN_TEXT_SECTION 1
+
+#define LOCAL_LABEL_PREFIX	"."
+
+/* A C statement to output something to the assembler file to switch to section
+   NAME for object DECL which is either a FUNCTION_DECL, a VAR_DECL or
+   NULL_TREE.  Some target formats do not support arbitrary sections.  Do not
+   define this macro in such cases.  */
+
+#undef  ASM_OUTPUT_SECTION_NAME
+#define ASM_OUTPUT_SECTION_NAME(FILE, DECL, NAME, RELOC) \
+do {									\
+  if ((DECL) && TREE_CODE (DECL) == FUNCTION_DECL)			\
+    fprintf (FILE, ".section\t%s,\"ax\"\n", (NAME));			\
+  else if ((DECL) && DECL_READONLY_SECTION (DECL, RELOC))		\
+    fprintf (FILE, ".section\t%s,\"a\"\n", (NAME));			\
+  else									\
+    fprintf (FILE, ".section\t%s,\"aw\"\n", (NAME));			\
+} while (0)
+
+/* If defined, a C expression whose value is a string containing the
+   assembler operation to identify the following data as
+   uninitialized global data.  If not defined, and neither
+   `ASM_OUTPUT_BSS' nor `ASM_OUTPUT_ALIGNED_BSS' are defined,
+   uninitialized global data will be output in the data section if
+   `-fno-common' is passed, otherwise `ASM_OUTPUT_COMMON' will be
+   used.  */
+#undef BSS_SECTION_ASM_OP
+#define BSS_SECTION_ASM_OP ".section\t.bss"
+
+/* Like `ASM_OUTPUT_BSS' except takes the required alignment as a
+   separate, explicit argument.  If you define this macro, it is used
+   in place of `ASM_OUTPUT_BSS', and gives you more flexibility in
+   handling the required alignment of the variable.  The alignment is
+   specified as the number of bits.
+
+   Try to use function `asm_output_aligned_bss' defined in file
+   `varasm.c' when defining this macro. */
+#undef ASM_OUTPUT_ALIGNED_BSS
+#define ASM_OUTPUT_ALIGNED_BSS(FILE, DECL, NAME, SIZE, ALIGN) \
+  asm_output_aligned_bss (FILE, DECL, NAME, SIZE, ALIGN)
--- /dev/null	Tue May  5 21:32:27 1998
+++ gcc/config/i386/t-i386elf	Wed Mar  1 22:53:54 2000
@@ -0,0 +1,7 @@
+LIBGCC1 = libgcc1.null
+CROSS_LIBGCC1 = libgcc1.null
+
+# For svr4 we build crtbegin.o and crtend.o which serve to add begin and
+# end labels to the .ctors and .dtors section when we link using gcc.
+
+EXTRA_PARTS=crtbegin.o crtend.o
--- /dev/null	Tue May  5 21:32:27 1998
+++ gcc/config/sparc/liteelf.h	Thu Mar  2 20:50:50 2000
@@ -0,0 +1,53 @@
+/* Definitions of target machine for GNU compiler, for SPARClite w/o FPU.
+   Copyright (C) 1998, 1999 Free Software Foundation, Inc.
+   Contributed by Stan Cox (scox@cygnus.com).
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
+the Free Software Foundation, 59 Temple Place - Suite 330,
+Boston, MA 02111-1307, USA.  */
+
+#include "sparc/elf.h"
+
+#undef CPP_PREDEFINES
+#define CPP_PREDEFINES "-D__sparc__ -D__sparclite__ -Acpu(sparc) -Amachine(sparc)"
+
+/* Default to dwarf2 in ELF.  */
+
+#define DWARF_DEBUGGING_INFO
+#define DWARF2_DEBUGGING_INFO
+
+#undef PREFERRED_DEBUGGING_TYPE
+#define PREFERRED_DEBUGGING_TYPE DWARF2_DEBUG
+
+#undef TARGET_VERSION
+#define TARGET_VERSION fprintf (stderr, " (sparclite)");
+
+/* Enable app-regs and epilogue options.  Do not enable the fpu.  */
+
+#undef TARGET_DEFAULT
+#define TARGET_DEFAULT (MASK_APP_REGS + MASK_EPILOGUE)
+
+/* US Software GOFAST library support.  */
+#include "gofast.h"
+#undef INIT_SUBTARGET_OPTABS
+#define INIT_SUBTARGET_OPTABS INIT_GOFAST_OPTABS      
+
+#undef STARTFILE_SPEC
+#define STARTFILE_SPEC "crti.o%s crtbegin.o%s"
+
+/* Use __main method of constructor invocation.  */
+#undef INIT_SECTION_ASM_OP
+#undef FINI_SECTION_ASM_OP
--- /dev/null	Tue May  5 21:32:27 1998
+++ gcc/config/sparc/sp86x-aout.h	Thu Mar  2 20:50:54 2000
@@ -0,0 +1,60 @@
+/* Definitions of target machine for GNU compiler, for sparclite 86x w/o FPU.
+   Copyright (C) 1998, 1999 Free Software Foundation, Inc.
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
+the Free Software Foundation, 59 Temple Place - Suite 330,
+Boston, MA 02111-1307, USA.  */
+
+#include "sparc/sparc.h"
+
+#define HAVE_ATEXIT
+
+#undef CPP_PREDEFINES
+#define CPP_PREDEFINES "-D__sparc__ -D__sparclite86x__ -Acpu(sparc) -Amachine(sparc)"
+
+#undef TARGET_VERSION
+#define TARGET_VERSION fprintf (stderr, " (sparclite 86x)");
+
+/* Enable app-regs and epilogue options.  Do not enable the fpu.  */
+
+#undef TARGET_DEFAULT
+#define TARGET_DEFAULT (MASK_APP_REGS + MASK_EPILOGUE)
+
+#undef SUBTARGET_SWITCHES
+#define SUBTARGET_SWITCHES \
+{"big-endian", -MASK_LITTLE_ENDIAN},		\
+{"little-endian", MASK_LITTLE_ENDIAN},		
+
+#undef ASM_SPEC
+#define ASM_SPEC "%{v:-v} %{mlittle-endian-data:--little-endian-data} %(asm_cpu)"
+
+/* US Software GOFAST library support.  */
+#include "gofast.h"
+#undef INIT_SUBTARGET_OPTABS
+#define INIT_SUBTARGET_OPTABS INIT_GOFAST_OPTABS
+
+#undef LINK_SPEC
+#define LINK_SPEC "%{v:-V}"
+
+#undef BYTES_BIG_ENDIAN
+#define BYTES_BIG_ENDIAN (! TARGET_LITTLE_ENDIAN_DATA)
+#undef WORDS_BIG_ENDIAN
+#define WORDS_BIG_ENDIAN (! TARGET_LITTLE_ENDIAN_DATA)
+
+#define TARGET_LITTLE_ENDIAN_DATA (target_flags & MASK_LITTLE_ENDIAN)
+#undef  SUBTARGET_SWITCHES
+#define SUBTARGET_SWITCHES \
+    { "little-endian-data",              MASK_LITTLE_ENDIAN },     
--- /dev/null	Tue May  5 21:32:27 1998
+++ gcc/config/sparc/t-sp86x	Thu Mar  2 20:51:01 2000
@@ -0,0 +1,24 @@
+CROSS_LIBGCC1 = libgcc1-asm.a
+LIB1ASMSRC = sparc/lb1spc.asm
+LIB1ASMFUNCS = _divsi3 _modsi3
+
+# We want fine grained libraries, so use the new code to build the
+# floating point emulation libraries.
+FPBIT = fp-bit.c
+DPBIT = dp-bit.c
+
+dp-bit.c: $(srcdir)/config/fp-bit.c
+	echo '#define US_SOFTWARE_GOFAST' > dp-bit.c
+	cat $(srcdir)/config/fp-bit.c >> dp-bit.c
+
+fp-bit.c: $(srcdir)/config/fp-bit.c
+	echo '#define FLOAT' > fp-bit.c
+	echo '#define US_SOFTWARE_GOFAST' >> fp-bit.c
+	cat $(srcdir)/config/fp-bit.c >> fp-bit.c
+
+MULTILIB_OPTIONS = mlittle-endian-data
+MULTILIB_DIRNAMES = little
+
+LIBGCC = stmp-multilib
+INSTALL_LIBGCC = install-multilib
+
--- /dev/null	Tue May  5 21:32:27 1998
+++ gcc/config/sparc/sp86x-elf.h	Thu Mar  2 20:51:06 2000
@@ -0,0 +1,73 @@
+/* Definitions of target machine for GNU compiler, for sparclite 86x w/o FPU.
+   Copyright (C) 1998, 1999 Free Software Foundation, Inc.
+   Contributed by Stan Cox (scox@cygnus.com).
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
+the Free Software Foundation, 59 Temple Place - Suite 330,
+Boston, MA 02111-1307, USA.  */
+
+#include "sparc/elf.h"
+
+#undef CPP_PREDEFINES
+#define CPP_PREDEFINES "-D__sparc__ -D__sparclite86x__ -Acpu(sparc) -Amachine(sparc)"
+
+/* Default to dwarf2 in ELF.  */
+
+#define DWARF_DEBUGGING_INFO
+#define DWARF2_DEBUGGING_INFO
+
+#undef PREFERRED_DEBUGGING_TYPE
+#define PREFERRED_DEBUGGING_TYPE DWARF2_DEBUG
+
+#undef TARGET_VERSION
+#define TARGET_VERSION fprintf (stderr, " (sparclite 86x)");
+
+/* Enable app-regs and epilogue options.  Do not enable the fpu.  */
+
+#undef TARGET_DEFAULT
+#define TARGET_DEFAULT (MASK_APP_REGS + MASK_EPILOGUE)
+
+#undef SUBTARGET_SWITCHES
+#define SUBTARGET_SWITCHES \
+{"big-endian", -MASK_LITTLE_ENDIAN},		\
+{"little-endian", MASK_LITTLE_ENDIAN},		
+
+#undef ASM_SPEC
+#define ASM_SPEC "%{v:-V} %{mlittle-endian-data:--little-endian-data} %(asm_cpu)"
+
+/* US Software GOFAST library support.  */
+#include "gofast.h"
+#undef INIT_SUBTARGET_OPTABS
+#define INIT_SUBTARGET_OPTABS INIT_GOFAST_OPTABS      
+
+#undef STARTFILE_SPEC
+#define STARTFILE_SPEC "crti.o%s crtbegin.o%s"
+
+#undef LINK_SPEC
+#define LINK_SPEC "%{v:-V} %{mlittle-endian-data:-EL}"
+
+#undef BYTES_BIG_ENDIAN
+#define BYTES_BIG_ENDIAN (! TARGET_LITTLE_ENDIAN_DATA)
+#undef WORDS_BIG_ENDIAN
+#define WORDS_BIG_ENDIAN (! TARGET_LITTLE_ENDIAN_DATA)
+
+/* Use __main method of constructor invocation */
+#undef INIT_SECTION_ASM_OP
+
+#define TARGET_LITTLE_ENDIAN_DATA (target_flags & MASK_LITTLE_ENDIAN)
+#undef  SUBTARGET_SWITCHES
+#define SUBTARGET_SWITCHES \
+    { "little-endian-data",              MASK_LITTLE_ENDIAN,	"Use little-endian byte order"},
Index: gcc/config/arm/arm.h
===================================================================
RCS file: /cvs/gcc/egcs/gcc/config/arm/arm.h,v
retrieving revision 1.34.4.3
diff -u -5 -p -r1.34.4.3 arm.h
--- gcc/config/arm/arm.h	1999/06/19 05:37:07	1.34.4.3
+++ gcc/config/arm/arm.h	2000/03/03 09:38:18
@@ -2146,11 +2146,10 @@ struct rtx_def;
 #endif
 
 #ifndef HOST_WIDE_INT
 #include "hwint.h"
 #endif
-#define Hint HOST_WIDE_INT
 
 #ifndef HAVE_MACHINE_MODES
 #include "machmode.h"
 #endif
 #define Mmode enum machine_mode
@@ -2162,12 +2161,12 @@ struct rtx_def;
 #endif
 #define Rcode enum rtx_code
 
 void   arm_override_options PROTO ((void));
 int    use_return_insn PROTO ((int));
-int    const_ok_for_arm PROTO ((Hint));
-int    arm_split_constant RTX_CODE_PROTO ((Rcode, Mmode, Hint, Rtx, Rtx, int));
+int    const_ok_for_arm PROTO ((HOST_WIDE_INT));
+int    arm_split_constant RTX_CODE_PROTO ((Rcode, Mmode, HOST_WIDE_INT, Rtx, Rtx, int));
 Rcode  arm_canonicalize_comparison RTX_CODE_PROTO ((Rcode,  Rtx *));
 int    arm_return_in_memory PROTO ((Tree));
 int    legitimate_pic_operand_p PROTO ((Rtx));
 Rtx    legitimize_pic_address PROTO ((Rtx, Mmode, Rtx));
 int    is_pic PROTO ((Rtx));
@@ -2204,13 +2203,13 @@ int    symbol_mentioned_p PROTO ((Rtx));
 int    label_mentioned_p PROTO ((Rtx));
 Rcode  minmax_code PROTO ((Rtx));
 int    adjacent_mem_locations PROTO ((Rtx, Rtx));
 int    load_multiple_operation PROTO ((Rtx, Mmode));
 int    store_multiple_operation PROTO ((Rtx, Mmode));
-int    load_multiple_sequence PROTO ((Rtx *, int, int *, int *, Hint *));
+int    load_multiple_sequence PROTO ((Rtx *, int, int *, int *, HOST_WIDE_INT *));
 char * emit_ldm_seq PROTO ((Rtx *, int));
-int    store_multiple_sequence PROTO ((Rtx *, int, int *, int *, Hint *));
+int    store_multiple_sequence PROTO ((Rtx *, int, int *, int *, HOST_WIDE_INT *));
 char * emit_stm_seq PROTO ((Rtx *, int));
 int    arm_valid_machine_decl_attribute PROTO ((Tree, Tree, Tree));
 Rtx    arm_gen_load_multiple PROTO ((int, int, Rtx, int, int, int, int, int));
 Rtx    arm_gen_store_multiple PROTO ((int, int, Rtx, int, int, int, int, int));
 int    arm_gen_movstrqi PROTO ((Rtx *));
Index: gcc/config/arm/t-arm-elf
===================================================================
RCS file: /cvs/gcc/egcs/gcc/config/arm/t-arm-elf,v
retrieving revision 1.8
diff -u -5 -p -r1.8 t-arm-elf
--- gcc/config/arm/t-arm-elf	1999/03/26 14:43:15	1.8
+++ gcc/config/arm/t-arm-elf	2000/03/22 21:09:06
@@ -21,15 +21,17 @@ dp-bit.c: $(srcdir)/config/fp-bit.c
 	echo '#endif' >> dp-bit.c
 	cat $(srcdir)/config/fp-bit.c >> dp-bit.c
 
 # MULTILIB_OPTIONS  = mlittle-endian/mbig-endian mhard-float/msoft-float mapcs-32/mapcs-26 fno-leading-underscore/fleading-underscore
 # MULTILIB_DIRNAMES = le be fpu soft 32bit 26bit elf under
-# MULTILIB_EXCEPTIONS = 
-# MULTILIB_MATCHES  = 
-# EXTRA_MULTILIB_PARTS = crtbegin.o crtend.o
-# LIBGCC = stmp-multilib
-# INSTALL_LIBGCC = install-multilib
+MULTILIB_OPTIONS  = mlittle-endian/mbig-endian mcpu=arm7
+MULTILIB_DIRNAMES = le be nofmult
+MULTILIB_EXCEPTIONS = 
+MULTILIB_MATCHES  = mbig-endian=mbe mlittle-endian=mle mcpu?arm7=mcpu?arm7d mcpu?arm7=mcpu?arm7di mcpu?arm7=mcpu?arm70 mcpu?arm7=mcpu?arm700 mcpu?arm7=mcpu?arm700i mcpu?arm7=mcpu?arm710 mcpu?arm7=mcpu?arm710c mcpu?arm7=mcpu?arm7100 mcpu?arm7=mcpu?arm7500 mcpu?arm7=mcpu?arm7500fe mcpu?arm7=mcpu?arm6 mcpu?arm7=mcpu?arm60 mcpu?arm7=mcpu?arm600 mcpu?arm7=mcpu?arm610 mcpu?arm7=mcpu?arm620
+EXTRA_MULTILIB_PARTS = crtbegin.o crtend.o
+LIBGCC = stmp-multilib
+INSTALL_LIBGCC = install-multilib
 
 # If EXTRA_MULTILIB_PARTS is not defined above then define EXTRA_PARTS here
-EXTRA_PARTS = crtbegin.o crtend.o
+# EXTRA_PARTS = crtbegin.o crtend.o
 
 TARGET_LIBGCC2_CFLAGS = -Dinhibit_libc
Index: config.sub
===================================================================
RCS file: /cvs/gcc/egcs/config.sub,v
retrieving revision 1.30.4.1
diff -u -5 -p -r1.30.4.1 config.sub
--- config.sub	1999/08/04 08:09:26	1.30.4.1
+++ config.sub	2000/03/22 11:38:53
@@ -62,10 +62,20 @@ case $1 in
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
Index: gcc/config/mips/elf.h
===================================================================
RCS file: /cvs/gcc/egcs/gcc/config/mips/elf.h,v
retrieving revision 1.11
diff -u -5 -p -r1.11 elf.h
--- gcc/config/mips/elf.h	1999/05/10 20:35:32	1.11
+++ gcc/config/mips/elf.h	2000/04/26 19:20:09
@@ -252,10 +252,15 @@ do {									   \
    via the SHF_WRITE attribute.)  */
 
 #define CTORS_SECTION_ASM_OP    "\t.section\t.ctors,\"aw\""
 #define DTORS_SECTION_ASM_OP    "\t.section\t.dtors,\"aw\""
  
+/* There's no point providing a default definition of __CTOR_LIST__
+   since people are expected either to use crtbegin.o, or an equivalent,
+   or provide their own definition.  */
+#define CTOR_LISTS_DEFINED_EXTERNALLY
+
 /* A list of other sections which the compiler might be "in" at any
    given time.  */
 #undef EXTRA_SECTIONS
 #define EXTRA_SECTIONS in_sdata, in_rdata, in_ctors, in_dtors
  