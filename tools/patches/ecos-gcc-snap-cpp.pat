--- gcc/cppexp.c~	Mon Mar 13 22:01:06 2000
+++ gcc/cppexp.c	Thu Mar 23 20:21:56 2000
@@ -717,7 +717,7 @@
 	case 0:
 	  lprio = 0;  goto maybe_reduce;
 	case '+':  case '-':
-	  if (top->flags & HAVE_VALUE)
+	  if ((top->flags & HAVE_VALUE) || top->op == ')')
 	    {
 	      lprio = PLUS_PRIO;
 	      goto binop;
