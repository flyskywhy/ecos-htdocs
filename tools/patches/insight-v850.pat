diff -ru ../insight-5.0-standardpatched/gdb/config/v850/tm-v850.h ./gdb/config/v850/tm-v850.h
--- ../insight-5.0-standardpatched/gdb/config/v850/tm-v850.h	Tue Dec 14 01:05:42 1999
+++ ./gdb/config/v850/tm-v850.h	Tue Mar 27 06:58:01 2001
@@ -82,7 +82,7 @@
 
 #define MAX_REGISTER_VIRTUAL_SIZE 4
 
-#define BREAKPOINT {0x40, 0xF8}	/* little-ended */
+#define BREAKPOINT {0x85, 0x05}	/* little-ended */
 
 #define FUNCTION_START_OFFSET 0
 
