Index: sim/mn10300/Makefile.in
===================================================================
RCS file: /cvs/src/src/sim/mn10300/Makefile.in,v
retrieving revision 1.2
diff -u -5 -p -r1.2 Makefile.in
--- sim/mn10300/Makefile.in	2000/03/03 23:25:10	1.2
+++ sim/mn10300/Makefile.in	2000/03/14 21:32:31
@@ -153,7 +153,10 @@ tmp-igen: $(IGEN_INSN) $(IGEN_DC) ../ige
 
 interp.o: interp.c $(MN10300_INTERP_DEP) $(INCLUDE)
 simops.o: simops.c $(INCLUDE)
 table.o: table.c
 
+semantics.o: semantics.c
+	$(CC) -c $(ALL_CFLAGS) -O1 semantics.c
+
 clean-extra: clean-igen
 	rm -f table.c simops.h gencode
