Index: gcc/function.c
===================================================================
RCS file: /cvs/gcc/egcs/gcc/function.c,v
retrieving revision 1.173
diff -u -p -r1.173 function.c
--- gcc/function.c	2000/03/09 19:01:47	1.173
+++ gcc/function.c	2000/03/14 17:36:33
@@ -5751,9 +5751,11 @@ prepare_function_start ()
   cfun->original_decl_initial = 0;
   cfun->original_arg_vector = 0;  
 
-  cfun->stack_alignment_needed = 0;
 #ifdef STACK_BOUNDARY
+  cfun->stack_alignment_needed = STACK_BOUNDARY;
   cfun->preferred_stack_boundary = STACK_BOUNDARY;
+#else
+  cfun->stack_alignment_needed = 0;
 #endif
 
   /* Set if a call to setjmp is seen.  */

