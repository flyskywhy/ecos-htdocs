Index: tcl/generic/tclFileName.c
===================================================================
RCS file: /cvs/src/src/tcl/generic/tclFileName.c,v
retrieving revision 1.1.1.1
diff -u -p -r1.1.1.1 tclFileName.c
--- tcl/generic/tclFileName.c	1999/11/09 01:28:43	1.1.1.1
+++ tcl/generic/tclFileName.c	2000/06/05 22:51:59
@@ -963,6 +963,8 @@ Tcl_TranslateFileName(interp, name, buff
      * some system interfaces don't accept forward slashes.
      */
 
+#ifndef __CYGWIN__
+    cygwin_conv_to_win32_path (Tcl_DStringValue(bufferPtr)
     if (tclPlatform == TCL_PLATFORM_WINDOWS) {
 	for (p = Tcl_DStringValue(bufferPtr); *p != '\0'; p++) {
 	    if (*p == '/') {
@@ -970,6 +972,7 @@ Tcl_TranslateFileName(interp, name, buff
 	    }
 	}
     }
+#endif
     return Tcl_DStringValue(bufferPtr);
 }
 
@@ -1568,6 +1571,7 @@ TclDoGlob(interp, separators, headPtr, t
 	    break;
 	case TCL_PLATFORM_WINDOWS: {
 	    int exists;
+#ifndef __CYGWIN__
 	    /*
 	     * We need to convert slashes to backslashes before checking
 	     * for the existence of the file.  Once we are done, we need
@@ -1588,6 +1592,7 @@ TclDoGlob(interp, separators, headPtr, t
 		    }
 		}
 	    }
+#endif
 	    name = Tcl_DStringValue(headPtr);
 	    exists = (TclAccess(name, F_OK) == 0);
 	    for (p = name; *p != '\0'; p++) {
Index: tcl/generic/tclInitScript.h
===================================================================
RCS file: /cvs/src/src/tcl/generic/tclInitScript.h,v
retrieving revision 1.2
diff -u -p -r1.2 tclInitScript.h
--- tcl/generic/tclInitScript.h	2000/04/03 19:34:38	1.2
+++ tcl/generic/tclInitScript.h	2000/06/05 22:51:59
@@ -92,6 +92,7 @@ static char initScript[] = "if {[info pr
         }\n\
 	set parentDir [file dirname [file dirname $execName]]\n\
         lappend dirs [file join $parentDir share tcl$tcl_version]\n\
+        lappend dirs [file join $parentDir \"usr\" share tcl$tcl_version]\n\
 	lappend dirs [file join [file dirname $parentDir] share tcl$tcl_version]\n\
         # NOW, let's try to find it in the build tree...\n\
         # Rather than play all the games Scriptics does, if we are in the build\n\
Index: tcl/win/tclWinFile.c
===================================================================
RCS file: /cvs/src/src/tcl/win/tclWinFile.c,v
retrieving revision 1.1.1.1
diff -u -p -r1.1.1.1 tclWinFile.c
--- tcl/win/tclWinFile.c	1999/11/09 01:28:44	1.1.1.1
+++ tcl/win/tclWinFile.c	2000/06/05 22:51:59
@@ -130,11 +130,13 @@ TclMatchFiles(interp, separators, dirPtr
 	Tcl_DStringAppend(&buffer, Tcl_DStringValue(dirPtr),
 		Tcl_DStringLength(dirPtr));
     }
+#ifndef __CYGWIN__
     for (p = Tcl_DStringValue(&buffer); *p != '\0'; p++) {
 	if (*p == '/') {
 	    *p = '\\';
 	}
     }
+#endif
     p--;
     if (*p != '\\' && *p != ':') {
 	Tcl_DStringAppend(&buffer, "\\", 1);


