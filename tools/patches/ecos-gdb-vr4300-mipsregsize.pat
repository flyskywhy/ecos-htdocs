Index: gdb/mips-tdep.c
===================================================================
RCS file: /cvs/src/src/gdb/mips-tdep.c,v
retrieving revision 1.2
retrieving revision 1.3
diff -u -5 -p -r1.2 -r1.3
--- gdb/mips-tdep.c	2000/02/22 19:17:27	1.2
+++ gdb/mips-tdep.c	2000/04/09 14:35:35	1.3
@@ -43,10 +43,26 @@ struct frame_extra_info
   {
     mips_extra_func_info_t proc_desc;
     int num_args;
   };
 
+/* We allow the user to override MIPS_SAVED_REGSIZE, so define
+   the subcommand enum settings allowed. */
+static char saved_gpreg_size_auto[] = "auto";
+static char saved_gpreg_size_32[] = "32";
+static char saved_gpreg_size_64[] = "64";
+
+static char *saved_gpreg_size_enums[] = {
+  saved_gpreg_size_auto,
+  saved_gpreg_size_32,
+  saved_gpreg_size_64,
+  0
+};
+
+/* The current (string) value of saved_gpreg_size. */
+static char *mips_saved_regsize_string = saved_gpreg_size_auto;
+
 /* Some MIPS boards don't support floating point while others only
    support single-precision floating-point operations.  See also
    FP_REGISTER_DOUBLE. */
 
 enum mips_fpu_type
@@ -61,14 +77,16 @@ enum mips_fpu_type
 #endif
 static int mips_fpu_type_auto = 1;
 static enum mips_fpu_type mips_fpu_type = MIPS_DEFAULT_FPU_TYPE;
 #define MIPS_FPU_TYPE mips_fpu_type
 
-#ifndef MIPS_SAVED_REGSIZE
-#define MIPS_SAVED_REGSIZE MIPS_REGSIZE
+#ifndef MIPS_DEFAULT_SAVED_REGSIZE
+#define MIPS_DEFAULT_SAVED_REGSIZE MIPS_REGSIZE
 #endif
 
+#define MIPS_SAVED_REGSIZE (mips_saved_regsize())
+
 /* Do not use "TARGET_IS_MIPS64" to test the size of floating point registers */
 #ifndef FP_REGISTER_DOUBLE
 #define FP_REGISTER_DOUBLE (REGISTER_VIRTUAL_SIZE(FP0_REGNUM) == 8)
 #endif
 
@@ -81,11 +99,11 @@ struct gdbarch_tdep
     /* mips options */
     int mips_eabi;
     enum mips_fpu_type mips_fpu_type;
     int mips_last_arg_regnum;
     int mips_last_fp_arg_regnum;
-    int mips_saved_regsize;
+    int mips_default_saved_regsize;
     int mips_fp_register_double;
   };
 
 #if GDB_MULTI_ARCH
 #undef MIPS_EABI
@@ -106,12 +124,12 @@ struct gdbarch_tdep
 #undef MIPS_FPU_TYPE
 #define MIPS_FPU_TYPE (gdbarch_tdep (current_gdbarch)->mips_fpu_type)
 #endif
 
 #if GDB_MULTI_ARCH
-#undef MIPS_SAVED_REGSIZE
-#define MIPS_SAVED_REGSIZE (gdbarch_tdep (current_gdbarch)->mips_saved_regsize)
+#undef MIPS_DEFAULT_SAVED_REGSIZE
+#define MIPS_DEFAULT_SAVED_REGSIZE (gdbarch_tdep (current_gdbarch)->mips_default_saved_regsize)
 #endif
 
 /* Indicate that the ABI makes use of double-precision registers
    provided by the FPU (rather than combining pairs of registers to
    form double-precision values).  Do not use "TARGET_IS_MIPS64" to
@@ -164,10 +182,14 @@ char *tmp_mips_processor_type;
    registers from a specific set.  */
 
 char *mips_generic_reg_names[] = MIPS_REGISTER_NAMES;
 char **mips_processor_reg_names = mips_generic_reg_names;
 
+/* The list of available "set mips " and "show mips " commands */
+static struct cmd_list_element *setmipscmdlist = NULL;
+static struct cmd_list_element *showmipscmdlist = NULL;
+
 char *
 mips_register_name (i)
      int i;
 {
   return mips_processor_reg_names[i];
@@ -301,10 +323,23 @@ mips_print_extra_frame_info (fi)
     printf_filtered (" frame pointer is at %s+%s\n",
 		     REGISTER_NAME (fi->extra_info->proc_desc->pdr.framereg),
 		     paddr_d (fi->extra_info->proc_desc->pdr.frameoffset));
 }
 
+/* Return the currently configured (or set) saved register size */
+
+static unsigned int
+mips_saved_regsize ()
+{
+  if (mips_saved_regsize_string == saved_gpreg_size_auto)
+    return MIPS_DEFAULT_SAVED_REGSIZE;
+  else if (mips_saved_regsize_string == saved_gpreg_size_64)
+    return 8;
+  else /* if (mips_saved_regsize_string == saved_gpreg_size_32) */
+    return 4;
+}
+
 /* Convert between RAW and VIRTUAL registers.  The RAW register size
    defines the remote-gdb packet. */
 
 static int mips64_transfers_32bit_regs_p = 0;
 
@@ -3142,10 +3177,32 @@ in_sigtramp (pc, ignore)
   if (sigtramp_address == 0)
     fixup_sigtramp ();
   return (pc >= sigtramp_address && pc < sigtramp_end);
 }
 
+/* Root of all "set mips "/"show mips " commands. This will eventually be
+   used for all MIPS-specific commands.  */
+
+static void show_mips_command PARAMS ((char *, int));
+static void
+show_mips_command (args, from_tty)
+     char *args;
+     int from_tty;
+{
+  help_list (showmipscmdlist, "show mips ", all_commands, gdb_stdout);
+}
+
+static void set_mips_command PARAMS ((char *, int));
+static void
+set_mips_command (args, from_tty)
+     char *args;
+     int from_tty;
+{
+  printf_unfiltered ("\"set mips\" must be followed by an appropriate subcommand.\n");
+  help_list (setmipscmdlist, "set mips ", all_commands, gdb_stdout);
+}
+
 /* Commands to show/set the MIPS FPU type.  */
 
 static void show_mipsfpu_command PARAMS ((char *, int));
 static void
 show_mipsfpu_command (args, from_tty)
@@ -3706,54 +3763,75 @@ mips_gdbarch_init (info, arches)
   switch ((elf_flags & EF_MIPS_ABI))
     {
     case E_MIPS_ABI_O32:
       ef_mips_abi = "o32";
       tdep->mips_eabi = 0;
-      tdep->mips_saved_regsize = 4;
+      tdep->mips_default_saved_regsize = 4;
       tdep->mips_fp_register_double = 0;
       set_gdbarch_long_bit (gdbarch, 32);
       set_gdbarch_ptr_bit (gdbarch, 32);
       set_gdbarch_long_long_bit (gdbarch, 64);
       break;
     case E_MIPS_ABI_O64:
       ef_mips_abi = "o64";
       tdep->mips_eabi = 0;
-      tdep->mips_saved_regsize = 8;
+      tdep->mips_default_saved_regsize = 8;
       tdep->mips_fp_register_double = 1;
       set_gdbarch_long_bit (gdbarch, 32);
       set_gdbarch_ptr_bit (gdbarch, 32);
       set_gdbarch_long_long_bit (gdbarch, 64);
       break;
     case E_MIPS_ABI_EABI32:
       ef_mips_abi = "eabi32";
       tdep->mips_eabi = 1;
-      tdep->mips_saved_regsize = 4;
+      tdep->mips_default_saved_regsize = 4;
       tdep->mips_fp_register_double = 0;
       set_gdbarch_long_bit (gdbarch, 32);
       set_gdbarch_ptr_bit (gdbarch, 32);
       set_gdbarch_long_long_bit (gdbarch, 64);
       break;
     case E_MIPS_ABI_EABI64:
       ef_mips_abi = "eabi64";
       tdep->mips_eabi = 1;
-      tdep->mips_saved_regsize = 8;
+      tdep->mips_default_saved_regsize = 8;
       tdep->mips_fp_register_double = 1;
       set_gdbarch_long_bit (gdbarch, 64);
       set_gdbarch_ptr_bit (gdbarch, 64);
       set_gdbarch_long_long_bit (gdbarch, 64);
       break;
     default:
       ef_mips_abi = "default";
       tdep->mips_eabi = 0;
-      tdep->mips_saved_regsize = MIPS_REGSIZE;
+      tdep->mips_default_saved_regsize = MIPS_REGSIZE;
       tdep->mips_fp_register_double = (REGISTER_VIRTUAL_SIZE (FP0_REGNUM) == 8);
       set_gdbarch_long_bit (gdbarch, 32);
       set_gdbarch_ptr_bit (gdbarch, 32);
       set_gdbarch_long_long_bit (gdbarch, 64);
       break;
     }
 
+  /* FIXME: jlarmour/2000-04-07: There *is* a flag EF_MIPS_32BIT_MODE
+     that could indicate -gp32 BUT gas/config/tc-mips.c contains the
+     comment:
+
+     ``We deliberately don't allow "-gp32" to set the MIPS_32BITMODE
+     flag in object files because to do so would make it impossible to
+     link with libraries compiled without "-gp32". This is
+     unnecessarily restrictive.
+ 
+     We could solve this problem by adding "-gp32" multilibs to gcc,
+     but to set this flag before gcc is built with such multilibs will
+     break too many systems.''
+
+     But even more unhelpfully, the default linker output target for
+     mips64-elf is elf32-bigmips, and has EF_MIPS_32BIT_MODE set, even
+     for 64-bit programs - you need to change the ABI to change this,
+     and not all gcc targets support that currently. Therefore using
+     this flag to detect 32-bit mode would do the wrong thing given
+     the current gcc - it would make GDB treat these 64-bit programs
+     as 32-bit programs by default. */
+
   /* determine the ISA */
   switch (elf_flags & EF_MIPS_ARCH)
     {
     case E_MIPS_ARCH_1:
       ef_mips_arch = 1;
@@ -3888,12 +3966,12 @@ mips_gdbarch_init (info, arches)
 			  (tdep->mips_fpu_type == MIPS_FPU_NONE ? "none"
 			 : tdep->mips_fpu_type == MIPS_FPU_SINGLE ? "single"
 			 : tdep->mips_fpu_type == MIPS_FPU_DOUBLE ? "double"
 			   : "???"));
       fprintf_unfiltered (gdb_stderr,
-		       "mips_gdbarch_init: tdep->mips_saved_regsize = %d\n",
-			  tdep->mips_saved_regsize);
+		       "mips_gdbarch_init: tdep->mips_default_saved_regsize = %d\n",
+			  tdep->mips_default_saved_regsize);
       fprintf_unfiltered (gdb_stderr,
 	     "mips_gdbarch_init: tdep->mips_fp_register_double = %d (%s)\n",
 			  tdep->mips_fp_register_double,
 			(tdep->mips_fp_register_double ? "true" : "false"));
     }
@@ -3910,10 +3988,34 @@ _initialize_mips_tdep ()
 
   if (GDB_MULTI_ARCH)
     register_gdbarch_init (bfd_arch_mips, mips_gdbarch_init);
   if (!tm_print_insn)		/* Someone may have already set it */
     tm_print_insn = gdb_print_insn_mips;
+
+  /* Add root prefix command for all "set mips"/"show mips" commands */
+  add_prefix_cmd ("mips", no_class, set_mips_command,
+		  "Various MIPS specific commands.",
+		  &setmipscmdlist, "set mips ", 0, &setlist);
+
+  add_prefix_cmd ("mips", no_class, show_mips_command,
+		  "Various MIPS specific commands.",
+		  &showmipscmdlist, "show mips ", 0, &showlist);
+
+  /* Allow the user to override the saved register size. */
+  add_show_from_set (add_set_enum_cmd ("saved-gpreg-size",
+				  class_obscure,
+			          saved_gpreg_size_enums,
+				  (char *) &mips_saved_regsize_string, "\
+Set size of general purpose registers saved on the stack.\n\
+This option can be set to one of:\n\
+  32    - Force GDB to treat saved GP registers as 32-bit\n\
+  64    - Force GDB to treat saved GP registers as 64-bit\n\
+  auto  - Allow GDB to use the target's default setting or autodetect the\n\
+          saved GP register size from information contained in the executable.\n\
+          (default: auto)",
+				  &setmipscmdlist),
+		     &showmipscmdlist);
 
   /* Let the user turn off floating point and set the fence post for
      heuristic_proc_start.  */
 
   add_prefix_cmd ("mipsfpu", class_support, set_mipsfpu_command,
