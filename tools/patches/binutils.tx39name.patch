--- config.sub~	Thu Feb 24 21:20:57 2000
+++ config.sub	Tue Mar 14 04:31:28 2000
@@ -69,6 +69,16 @@
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
