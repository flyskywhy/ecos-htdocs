Index: gcc/cp/tinfo2.cc
===================================================================
RCS file: /cvs/gcc/egcs/gcc/cp/tinfo2.cc,v
retrieving revision 1.25
diff -u -5 -p -r1.25 tinfo2.cc
--- gcc/cp/tinfo2.cc	2000/05/30 15:44:20	1.25
+++ gcc/cp/tinfo2.cc	2000/06/01 17:05:42
@@ -26,11 +26,15 @@
 // the GNU General Public License.  This exception does not however
 // invalidate any other reasons why the executable file might be covered by
 // the GNU General Public License.
 
 #include <stddef.h>
+#ifndef inhibit_libc
 #include <stdlib.h>		// for abort
+#else
+extern void abort(void);
+#endif
 #include "tinfo.h"
 #include "new"			// for placement new
 
 using std::type_info;
 
