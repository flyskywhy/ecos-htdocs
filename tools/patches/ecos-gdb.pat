Index: gdb/remote.c
===================================================================
RCS file: /cvs/src/src/gdb/remote.c,v
retrieving revision 1.5
diff -c -r1.5 remote.c
*** gdb/remote.c	2000/02/18 17:00:18	1.5
--- gdb/remote.c	2000/03/20 23:01:30
***************
*** 699,704 ****
--- 699,715 ----
  
  static struct packet_config remote_protocol_binary_download;
  
+ /* Should we try the 'ThreadInfo' query packet?
+ 
+    This variable (NOT available to the user: auto-detect only!)
+    determines whether GDB will use the new, simpler "ThreadInfo"
+    query or the older, more complex syntax for thread queries.
+    This is an auto-detect variable (set to true at each connect, 
+    and set to false when the target fails to recognize it).  */
+ 
+ static int use_threadinfo_query;
+ static int use_threadextra_query;
+ 
  static void
  set_remote_protocol_binary_download_cmd (char *args,
  					 int from_tty,
***************
*** 828,834 ****
  
  typedef int gdb_threadref;	/* internal GDB thread reference */
  
! /*  gdb_ext_thread_info is an internal GDB data structure which is
     equivalint to the reply of the remote threadinfo packet */
  
  struct gdb_ext_thread_info
--- 839,845 ----
  
  typedef int gdb_threadref;	/* internal GDB thread reference */
  
! /* gdb_ext_thread_info is an internal GDB data structure which is
     equivalint to the reply of the remote threadinfo packet */
  
  struct gdb_ext_thread_info
***************
*** 1558,1564 ****
      return oldpid;
  }
  
! /* Find new threads for info threads command.  */
  
  static void
  remote_find_new_threads ()
--- 1569,1577 ----
      return oldpid;
  }
  
! /* Find new threads for info threads command.  
!  * Original version, using John Metzler's thread protocol.  
!  */
  
  static void
  remote_find_new_threads ()
***************
*** 1569,1574 ****
--- 1582,1594 ----
      inferior_pid = remote_current_thread (inferior_pid);
  }
  
+ /*
+  * Find all threads for info threads command.
+  * Uses new thread protocol contributed by Cisco.
+  * Falls back and attempts to use the older method (above)
+  * if the target doesn't respond to the new method.
+  */
+ 
  static void
  remote_threads_info (void)
  {
***************
*** 1579,1607 ****
    if (remote_desc == 0)		/* paranoia */
      error ("Command can only be used when connected to the remote target.");
  
!   putpkt ("qfThreadInfo");
!   bufp = buf;
!   getpkt (bufp, PBUFSIZ, 0);
!   if (bufp[0] == '\0')		/* q packet not recognized! */
!     {				/* try old jmetzler method  */
!       remote_find_new_threads ();
!       return;
      }
!   else				/* try new 'q' method */
!     while (*bufp++ == 'm')	/* reply contains one or more TID */
        {
! 	do
  	  {
! 	    tid = strtol (bufp, &bufp, 16);
! 	    if (tid != 0 && !in_thread_list (tid))
! 	      add_thread (tid);
  	  }
- 	while (*bufp++ == ',');	/* comma-separated list */
- 	putpkt ("qsThreadInfo");
- 	bufp = buf;
- 	getpkt (bufp, PBUFSIZ, 0);
        }
  }
  
  
  /*  Restart the remote side; this is an extended protocol operation.  */
--- 1599,1706 ----
    if (remote_desc == 0)		/* paranoia */
      error ("Command can only be used when connected to the remote target.");
  
!   if (use_threadinfo_query)
!     {
!       putpkt ("qfThreadInfo");
!       bufp = buf;
!       getpkt (bufp, PBUFSIZ, 0);
!       if (bufp[0] != '\0')		/* q packet recognized */
! 	{	
! 	  while (*bufp++ == 'm')	/* reply contains one or more TID */
! 	    {
! 	      do
! 		{
! 		  tid = strtol (bufp, &bufp, 16);
! 		  if (tid != 0 && !in_thread_list (tid))
! 		    add_thread (tid);
! 		}
! 	      while (*bufp++ == ',');	/* comma-separated list */
! 	      putpkt ("qsThreadInfo");
! 	      bufp = buf;
! 	      getpkt (bufp, PBUFSIZ, 0);
! 	    }
! 	  return;	/* done */
! 	}
      }
! 
!   /* Else fall back to old method based on jmetzler protocol. */
!   use_threadinfo_query = 0;
!   remote_find_new_threads ();
!   return;
! }
! 
! /* 
!  * Collect a descriptive string about the given thread.
!  * The target may say anything it wants to about the thread
!  * (typically info about its blocked / runnable state, name, etc.).
!  * This string will appear in the info threads display.
!  * 
!  * Optional: targets are not required to implement this function.
!  */
! 
! static char *
! remote_threads_extra_info (struct thread_info *tp)
! {
!   int result;
!   int set;
!   threadref id;
!   struct gdb_ext_thread_info threadinfo;
!   static char display_buf[100];	/* arbitrary... */
!   char *bufp = alloca (PBUFSIZ);
!   int n = 0;                    /* position in display_buf */
! 
!   if (remote_desc == 0)		/* paranoia */
!     internal_error ("remote_threads_extra_info");
! 
!   if (use_threadextra_query)
!     {
!       sprintf (bufp, "qThreadExtraInfo,%x", tp->pid);
!       putpkt (bufp);
!       getpkt (bufp, PBUFSIZ, 0);
!       if (bufp[0] != 0)
! 	{
! 	  char *p;
! 
! 	  for (p = display_buf; 
! 	       p < display_buf + sizeof(display_buf) - 1 &&
! 		 bufp[0] != 0 &&
! 		 bufp[1] != 0;
! 	       p++, bufp+=2)
! 	    {
! 	      *p = fromhex (bufp[0]) * 16 + fromhex (bufp[1]);
! 	    }
! 	  *p = 0;
! 	  return display_buf;
! 	}
!     }
! 
!   /* If the above query fails, fall back to the old method.  */
!   use_threadextra_query = 0;
!   set = TAG_THREADID | TAG_EXISTS | TAG_THREADNAME
!     | TAG_MOREDISPLAY | TAG_DISPLAY;
!   int_to_threadref (&id, tp->pid);
!   if (remote_get_threadinfo (&id, set, &threadinfo))
!     if (threadinfo.active)
        {
! 	if (*threadinfo.shortname)
! 	  n += sprintf(&display_buf[0], " Name: %s,", threadinfo.shortname);
! 	if (*threadinfo.display)
! 	  n += sprintf(&display_buf[n], " State: %s,", threadinfo.display);
! 	if (*threadinfo.more_display)
! 	  n += sprintf(&display_buf[n], " Priority: %s",
! 		       threadinfo.more_display);
! 
! 	if (n > 0)
  	  {
! 	    /* for purely cosmetic reasons, clear up trailing commas */
! 	    if (',' == display_buf[n-1])
! 	      display_buf[n-1] = ' ';
! 	    return display_buf;
  	  }
        }
+   return NULL;
  }
+ 
  
  
  /*  Restart the remote side; this is an extended protocol operation.  */
***************
*** 1967,1972 ****
--- 2066,2075 ----
       binary downloading. */
    init_packet_config (&remote_protocol_binary_download);
  
+   /* Probe for ability to use "ThreadInfo" query, as required.  */
+   use_threadinfo_query = 1;
+   use_threadextra_query = 1;
+ 
    /* Without this, some commands which require an active target (such
       as kill) won't work.  This variable serves (at least) double duty
       as both the pid of the target process (if it has such), and as a
***************
*** 2052,2057 ****
--- 2155,2164 ----
       binary downloading. */
    init_packet_config (&remote_protocol_binary_download);
  
+   /* Probe for ability to use "ThreadInfo" query, as required.  */
+   use_threadinfo_query = 1;
+   use_threadextra_query = 1;
+ 
    /* Without this, some commands which require an active target (such
       as kill) won't work.  This variable serves (at least) double duty
       as both the pid of the target process (if it has such), and as a
***************
*** 4898,4903 ****
--- 5005,5011 ----
    remote_ops.to_mourn_inferior = remote_mourn;
    remote_ops.to_thread_alive = remote_thread_alive;
    remote_ops.to_find_new_threads = remote_threads_info;
+   remote_ops.to_extra_thread_info = remote_threads_extra_info;
    remote_ops.to_stop = remote_stop;
    remote_ops.to_query = remote_query;
    remote_ops.to_rcmd = remote_rcmd;
***************
*** 5034,5039 ****
--- 5142,5151 ----
       binary downloading. */
    init_packet_config (&remote_protocol_binary_download);
  
+   /* Probe for ability to use "ThreadInfo" query, as required.  */
+   use_threadinfo_query = 1;
+   use_threadextra_query = 1;
+   
    /* Without this, some commands which require an active target (such
       as kill) won't work.  This variable serves (at least) double duty
       as both the pid of the target process (if it has such), and as a
***************
*** 5309,5314 ****
--- 5421,5427 ----
    remote_cisco_ops.to_mourn_inferior = remote_cisco_mourn;
    remote_cisco_ops.to_thread_alive = remote_thread_alive;
    remote_cisco_ops.to_find_new_threads = remote_threads_info;
+   remote_ops.to_extra_thread_info = remote_threads_extra_info;
    remote_cisco_ops.to_stratum = process_stratum;
    remote_cisco_ops.to_has_all_memory = 1;
    remote_cisco_ops.to_has_memory = 1;
***************
*** 5397,5402 ****
--- 5510,5516 ----
    remote_async_ops.to_mourn_inferior = remote_async_mourn;
    remote_async_ops.to_thread_alive = remote_thread_alive;
    remote_async_ops.to_find_new_threads = remote_threads_info;
+   remote_ops.to_extra_thread_info = remote_threads_extra_info;
    remote_async_ops.to_stop = remote_stop;
    remote_async_ops.to_query = remote_query;
    remote_async_ops.to_rcmd = remote_rcmd;


Index: gdb/arm-tdep.c
===================================================================
RCS file: /cvs/src/src/gdb/arm-tdep.c,v
retrieving revision 1.4
diff -u -5 -p -r1.4 arm-tdep.c
--- gdb/arm-tdep.c	2000/02/29 07:23:02	1.4
+++ gdb/arm-tdep.c	2000/03/18 22:15:48
@@ -326,20 +326,20 @@ arm_frameless_function_invocation (struc
    When we have found at least one of each class we are done with the prolog.
    Note that the "sub sp, #NN" before the push does not count.
    */
 
 static CORE_ADDR
-thumb_skip_prologue (CORE_ADDR pc)
+thumb_skip_prologue (CORE_ADDR pc, CORE_ADDR func_end)
 {
   CORE_ADDR current_pc;
   int findmask = 0;  	/* findmask:
       			   bit 0 - push { rlist }
 			   bit 1 - mov r7, sp  OR  add r7, sp, #imm  (setting of r7)
       			   bit 2 - sub sp, #simm  OR  add sp, #simm  (adjusting of sp)
 			*/
 
-  for (current_pc = pc; current_pc < pc + 40; current_pc += 2)
+  for (current_pc = pc; current_pc + 2 < func_end && current_pc < pc + 40; current_pc += 2)
     {
       unsigned short insn = read_memory_unsigned_integer (current_pc, 2);
 
       if ((insn & 0xfe00) == 0xb400)	/* push { rlist } */
 	{
@@ -397,11 +397,11 @@ arm_skip_prologue (CORE_ADDR pc)
 	return sal.end;
     }
 
   /* Check if this is Thumb code.  */
   if (arm_pc_is_thumb (pc))
-    return thumb_skip_prologue (pc);
+    return thumb_skip_prologue (pc, func_end);
 
   /* Can't find the prologue end in the symbol table, try it the hard way
      by disassembling the instructions. */
   skip_pc = pc;
   inst = read_memory_integer (skip_pc, 4);