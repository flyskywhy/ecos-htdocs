#!/bin/ash

outputfunc()
{
cat <<EOF >$1
<HTML>

<!--
*********************************************************

WARNING - this is a generated file - do not edit directly

*********************************************************
-->

<HEAD>
<TITLE>Building the $TARGETNAME development tools for $HOST</TITLE>
</HEAD>

<!--#include virtual="../include/header.html"-->


<H2>Building the $TARGETNAME development tools for $HOST</H2>
<HR SIZE=3>
<h3>Introduction</h3>

eCos requires $TOOLPREFIX development tools to develop programs for $TARGETNAME targets.

The development tools come in three parts: the GNU compiler collection
(GCC), the GNU Debugger (GDB) and the GNU binary utilities,
which include the GNU assembler and linker.

This page details the steps required to download and build these development tools.

<h3>Downloading the tool sources</h3>
<h4>GNU Binary Utilities</h4>

${BINUSNAP-
<p>It is recommended that eCos is used with the most recent official
release of the GNU Binary Utilities (binutils), currently version 2.10.1.
This is available from the binutils area of the
<a href="http://www.gnu.org/order/ftp.html">main GNU software download site</a>
or any of its mirror sites. It is also available at any of the
<a href="http://sources.redhat.com/mirrors.html">
mirror sites for sources.redhat.com</a>. Download sizes are in the
region of 5.5MB for .bz2 format archives, or 7MB for .gz format archives.<p>

Weekly and daily snapshots from the CVS repository are also available
from the <a href="http://sources.redhat.com/binutils/"> main binutils
development site</a>, but these have not been verified
for use with eCos.<p>
}

${BINUSNAP+
<p>Unfortunately, the most recent official release of the GNU Binary Utilities (binutils),
currently 2.10.1, is not capable of supporting eCos for $TARGETNAME. Instead the devlopment
tools must be built using a snapshot release of binutils.
This is available from the <a href="http://sources.redhat.com/binutils/"> main binutils
development site</a>. It is also available at any of the
<a href="http://sources.redhat.com/mirrors.html">
mirror sites for sources.redhat.com</a>. Download sizes are in the
region of 7.5MB for .bz2 format archives, or 10MB for .gz format archives.<p>
}

If you already have binutils sources available but are unsure
of their version, you can search the file <tt>gas/configure</tt> for the string
"VERSION" and examine its value.

<h4>GNU Compiler Collection</h4>

The <a href="http://gcc.gnu.org/">GNU Compiler Collection web site</a> contains plenty of
information about installing and using GCC.

${GCCSNAP-
A <a href="ftp://gcc.gnu.org/pub/gcc/snapshots/index.html">snapshot of the
GCC development sources</a> may be used to obtain the most up-to-date compiler
with new features and bug fixes. 

However, it is recommended that the most recent
official release (GCC 2.95.2) is used, as it is likely to be more stable.<p>

GCC 2.95.2 sources can be downloaded from the 
<a href="ftp://gcc.gnu.org/pub/gcc/releases/index.html">releases page</a>. Both the core
distribution and the C++ distribution files are required for eCos. Alternatively, click
on the appropriate following links to download the files directly:

<ul>
${WINDOWS-
<li>
<a href="ftp://gcc.gnu.org/pub/gcc/releases/gcc-2.95.2/gcc-core-2.95.2.tar.gz">
  GCC 2.95.2 core compiler distribution</a> (gcc-core-2.95.2.tar.gz - 8.7MB)
}
<li>
<a href="ftp://gcc.gnu.org/pub/gcc/releases/gcc-2.95.2/gcc-core-2.95.2.tar.bz2">
  GCC 2.95.2 core compiler distribution</a> (gcc-core-2.95.2.tar.bz2 - 6.6MB)

${WINDOWS-
<li>
<a href="ftp://gcc.gnu.org/pub/gcc/releases/gcc-2.95.2/gcc-g++-2.95.2.tar.gz">
  GCC 2.95.2 C++ distribution</a> (gcc-g++-2.95.2.tar.gz - 1.6MB)
}
<li>
<a href="ftp://gcc.gnu.org/pub/gcc/releases/gcc-2.95.2/gcc-g++-2.95.2.tar.bz2">
  GCC 2.95.2 C++ distribution</a> (gcc-g++-2.95.2.tar.bz2 - 1.2MB)

</ul>

}

${GCCSNAP+

Unfortunately the most recent official release (GCC 2.95.2) is not capable of
supporting eCos for $TARGETNAME. A <a href="ftp://gcc.gnu.org/pub/gcc/snapshots/index.html">snapshot of the
GCC development sources</a> should be used to obtain the most up-to-date compiler
with new features and bug fixes.<p>

${USENEWSNAPSHOT-
eCos has been tested with the 2000-03-13 snapshot, but it is likely that later
snapshots will fix bugs that have not yet been discovered. If you have compiler
problems you may wish to consider updating to a more recent snapshot, or
reverting to an older one.
}

When downloading a snapshot from the <a href="ftp://gcc.gnu.org/pub/gcc/snapshots/">
GCC snapshot download area</a> note that only the core compiler and C++
distributions are required (prefix <tt>gcc-core-</tt> and <tt>gcc-g++-</tt>).<p>

}

Note that the instructions for building GCC here are only intended for use
with eCos. In any other environment, the tools may not function correctly.
Refer to the <a href="http://www.objsw.com/CrossGCC/">CrossGCC FAQ</a>
for details about building a standalone version of GCC.<p>

It is strongly recommended you use a <a href="http://gcc.gnu.org/mirrors.html">mirror site</a>
close to you, which will result in a faster download, reduced internet congestion, and
reduced load on the central server.<p>

<h4>GNU Debugger</h4>

<p>Instructions for downloading the GNU Debugger (GDB) are provided
on the <a href="http://sources.redhat.com/gdb/">
GDB home page</a>. 

However, Red Hat has also released an open source graphical front-end to GDB based on
Tcl/Tk called <i>Insight</i>, which has a separate <a href="http://sources.redhat.com/insight/">
home page</a>.<p>

The Insight sources are a superset of the standard GDB sources. It is also
still possible to run GDB in command-line mode by using the <tt>-nw</tt>
command-line option when invoking GDB, so there is nothing to lose by using the Insight
sources.<p>

The latest release (version 5.0) is recommended and may be downloaded via the GDB home page.
Alternatively, click on on one of following links to download the files directly:

<ul>
<li><a href="ftp://sources.redhat.com/pub/gdb/releases/insight-5.0.tar.bz2">
  Insight 5.0 distribution</a> (insight-5.0.tar.bz2 - 14MB)
<li><a href="ftp://sources.redhat.com/pub/gdb/releases/gdb-5.0.tar.bz2">
  GDB 5.0 distribution</a> (gdb-5.0.tar.bz2 - 9.1MB)
</ul>

<p>
<h3>Preparing the sources for building</h3>

Once the tools sources have been downloaded, they must be prepared before
building. These instructions assume that the tool sources will be extracted in the <tt>/src</tt> directory hierarchy.
Other locations may be substituted throughout. Similarly placeholders of the form <tt><i>YYYYMMDD</i></tt> and
<tt><i>YYMMDD</i></tt> should be replaced with the actual date of the downloaded files. Ensure that the file system used 
has sufficient free space available. The contents of each archive will expand
to occupy approximately 6 times the space required by the compressed archive itself.

${WINDOWS-
To extract the downloaded sources, you will need to have either the
<a href="../../bzip2/">bzip2</a> or <a href="http://www.gzip.org/">gzip</a>
compression utilities, depending on your choice of download format.
A <i>patch</i> utility (preferably <a href="http://www.gnu.org/software/patch/patch.html">GNU patch</a>) is also required.<p>
The following steps should be followed at a <i>sh</i>, <i>ksh</i> or <i>bash</i> prompt. Users of
the <i>csh</i> and <i>tcsh</i> shells should replace "<tt>2&gt;&amp;1</tt>" with "<tt>|&amp;</tt>" throughout:
}

${WINDOWS+
The following steps should be followed at the Cygwin <i>bash</i> prompt:
}

<ol>
<li>Create a directory for each set of tool sources, avoiding directory names containing spaces as these can confuse the
build system:

<pre>
    mkdir -p /src/binutils /src/gcc /src/gdb
</pre>

<li>Extract the sources for each tool directory in turn. For <i>bzip2</i> archives:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/binutils<br>
${BINUSNAP-
&nbsp;&nbsp;&nbsp;&nbsp;bunzip2 &lt; binutils-2.10.1.tar.bz2 | tar xvf -<br>
}
${BINUSNAP+
&nbsp;&nbsp;&nbsp;&nbsp;bunzip2 &lt; binutils-<i>YYMMDD</i>.tar.bz2 | tar xvf -<br>
}
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gcc<br>
${GCCSNAP-
&nbsp;&nbsp;&nbsp;&nbsp;bunzip2 &lt; gcc-core-2.95.2.tar.bz2 | tar xvf -<br>
&nbsp;&nbsp;&nbsp;&nbsp;bunzip2 &lt; gcc-g++-2.95.2.tar.bz2 | tar xvf -<br>
}
${GCCSNAP+
&nbsp;&nbsp;&nbsp;&nbsp;bunzip2 &lt; gcc-core-<i>YYYYMMDD</i>.tar.bz2 | tar xvf -<br>
&nbsp;&nbsp;&nbsp;&nbsp;bunzip2 &lt; gcc-g++-<i>YYYYMMDD</i>.tar.bz2 | tar xvf -<br>
}
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gdb<br>
&nbsp;&nbsp;&nbsp;&nbsp;bunzip2 &lt; insight-5.0.tar.bz2 | tar xvf -
</tt></nobr>

${GZIP+
<p>For <i>gzip</i> archives:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/binutils<br>
${BINUSNAP-
&nbsp;&nbsp;&nbsp;&nbsp;gunzip &lt; binutils-2.10.1.tar.gz | tar xvf -<br>
}
${BINUSNAP+
&nbsp;&nbsp;&nbsp;&nbsp;gunzip &lt; binutils-<i>YYMMDD</i>.tar.gz | tar xvf -<br>
}
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gcc<br>
${GCCSNAP-
&nbsp;&nbsp;&nbsp;&nbsp;gunzip &lt; gcc-core-2.95.2.tar.gz | tar xvf -<br>
&nbsp;&nbsp;&nbsp;&nbsp;gunzip &lt; gcc-g++-2.95.2.tar.gz | tar xvf -<br>
}
${GCCSNAP+
&nbsp;&nbsp;&nbsp;&nbsp;gunzip &lt; gcc-core-<i>YYYYMMDD</i>.tar.gz | tar xvf -<br>
&nbsp;&nbsp;&nbsp;&nbsp;gunzip &lt; gcc-g++-<i>YYYYMMDD</i>.tar.gz | tar xvf -<br>
}
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gdb<br>
&nbsp;&nbsp;&nbsp;&nbsp;gunzip &lt; insight-5.0.tar.gz | tar xvf -
</tt></nobr>
}
<p>
The following directories should be generated and populated during the extraction process:<p>
<nobr><tt>
${BINUSNAP-
&nbsp;&nbsp;&nbsp;&nbsp;/src/binutils/binutils-2.10.1<br>
}
${BINUSNAP+
&nbsp;&nbsp;&nbsp;&nbsp;/src/binutils/binutils-<i>YYMMDD</i><br>
}
${GCCSNAP-
&nbsp;&nbsp;&nbsp;&nbsp;/src/gcc/gcc-2.95.2<br>
}
${GCCSNAP+
&nbsp;&nbsp;&nbsp;&nbsp;/src/gcc/gcc-<i>YYYYMMDD</i><br>
}
&nbsp;&nbsp;&nbsp;&nbsp;/src/gdb/insight-5.0
</tt></nobr>
<p>
If the standard GDB source distribution was downloaded rather than Insight,
then the GDB tools source directory will be <nobr><tt>/src/gdb/gdb-5.0</tt></nobr> rather than
<nobr><tt>/src/gdb/insight-5.0</tt></nobr>.<p>

<li>You may now need to apply a small number of source patches that are
required to fix outstanding problems and add eCos support to the tools.
Patches may be downloaded using most browsers by either shift-clicking
or right-clicking on the link to the patch. You must not view the link
and cut-and-paste because white space must be preserved exactly.<p>
${WINDOWS+
<b>Warning:</b> Users of Cygwin v1.1.1 will not be able to apply
these patches successfully as described due to a bug present in that
version of the Cygwin DLL. You may determine the version of the installed Cygwin
DLL by executing the command "<tt>uname&nbsp;-r</tt>" at the Cygwin bash prompt.
If the version installed is v1.1.1, please read <a href="../faq.html#newcygwindll">
this FAQ entry</a> to resolve the problem.
<p>
<b>All</b> users of Cygwin should verify that their <tt>/tmp</tt> directory (or
the directory specified by the <tt>TMPDIR</tt>, <tt>TMP</tt> or <tt>TEMP</tt>
environment variables) is mounted in binary mode. If this is not the case
the patches will apply, but the build will later fail. You may verify this
using the Cygwin <tt>mount</tt> command. If /tmp is not explicitly listed,
the entry for / will be used. If it says "<tt>textmode</tt>" for this entry,
use the following command from a Cygwin bash prompt:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;mount -f -b c:/cygwin/tmp /tmp
</tt></nobr>
<p>
You may need to substitute another path for <tt>c:/cygwin</tt> if Cygwin
was installed to another directory.
<p>
}

${WINDOWS+
If Insight 5.0 is being used, rather than the standard GDB source
distribution, then you must download the <a href="patches/insight-tcl.pat">
insight-tcl.pat</a> patch to a file and apply it:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gdb/insight-5.0<br>
&nbsp;&nbsp;&nbsp;&nbsp;tr -d '\r' &lt; insight-tcl.pat | patch -p0
</tt></nobr>
<p>
}
${GCCSNAP-
Download the <a href="patches/ecos-gcc-2952.pat">
ecos-gcc-2952.pat</a> patch to a file and apply it:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gcc/gcc-2.95.2<br>
${WINDOWS+
&nbsp;&nbsp;&nbsp;&nbsp;tr -d '\r' &lt; ecos-gcc-2952.pat | patch -p0
}
${WINDOWS-
&nbsp;&nbsp;&nbsp;&nbsp;patch -p0 &lt; ecos-gcc-2952.pat
}
</tt></nobr>
<p>

You must then reset the source file timestamps to ensure that makefile dependencies
are handled correctly:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;contrib/egcs_update --touch
</tt></nobr>
}
${GCCSNAP+
${USENEWSNAPSHOT-
If you are using a GCC snapshot dated 2000-03-20 or earlier, download
the <a href="patches/ecos-gcc-snap-cpp.pat">ecos-gcc-snap-cpp.pat</a>
patch to a file and apply it:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gcc/gcc-<i>YYYYMMDD</i><br>
${WINDOWS+
&nbsp;&nbsp;&nbsp;&nbsp;tr -d '\r' &lt; ecos-gcc-snap-cpp.pat | patch -p0
}
${WINDOWS-
&nbsp;&nbsp;&nbsp;&nbsp;patch -p0 &lt; ecos-gcc-snap-cpp.pat
}
</tt></nobr>
<p>
}
$EXTRASNAPPATCH

You must then reset the source file timestamps to ensure that makefile dependencies
are handled correctly:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;contrib/gcc_update --touch
</tt></nobr>
}
<p>

$EXTRAPATCH

If any of the patches fail to apply you should see if there is some
obvious problem by attempting to apply the patch manually. If this is not
possible, report the problem to the <a href="../intouch.html">
ecos-discuss</a> mailing list.<p>

If the <i>patch</i> utility reports the following message:<p>
<nobr><tt>&nbsp;&nbsp;&nbsp;&nbsp;Reversed (or previously applied) patch detected!  Assume -R? [n]</tt></nobr><p>
then type <i>n</i> because this indicates the patch has already been applied
in the master sources.
</ol>

<h3>Building the tools</h3>

Before attempting to build the tools, ensure that the GNU native compiler tools directory is on the
PATH and precedes the current directory. The
following build procedures will fail if <tt>.</tt> is ahead of the native tools in the PATH.<p>

${WINDOWS+
Avoid using spaces in build and install directory paths. Building on an NTFS file system is
strongly recommended due to the large number of small files involved in the build process.

Cygwin users must set the <tt>MAKE_MODE</tt> environment variable as follows:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;export MAKE_MODE=UNIX
</tt></nobr>
<p>
}

Approximate disk space requirements for building the development tools are as follows:<p>

<center><table BORDER=0 CELLSPACING=2 CELLPADDING=7>
<tr bgcolor=#999999>
  <td><b>Tool</b></td><td align=right><b>Build</b></td><td align=right><b>Install</b></td>
</tr>
<tr bgcolor=#dddddd>
  <td>Binary Utilities</td><td align=right>$BINUTILSBLDDSK</td><td align=right>$BINUTILSINSTDSK</td>
</tr>
<tr bgcolor=#dddddd>
  <td>GCC</td><td align=right>$GCCBLDDSK</td><td align=right>$GCCINSTDSK</td>
</tr>
<tr bgcolor=#dddddd>
  <td>Insight</td><td align=right>$INSIGHTBLDDSK</td><td align=right>$INSIGHTINSTDSK</td>
</tr>
<tr bgcolor=#dddddd>
  <td>TOTAL</td><td align=right>$TOTBLDDSK</td><td align=right>$TOTINSTDSK</td>
</tr>
</table></center>

<p>
Following successful building and installation of each set of tools, the associated build
tree may be deleted to save space if necessary. These instructions assume that the tools
will be built in the <tt>/tmp/build</tt> directory hierarchy and
installed to <tt>/tools</tt>. Other locations may be substituted throughout:

<ol>
<li>Configure the GNU Binary Utilities:<p>

<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;mkdir -p /tmp/build/binutils<br>
&nbsp;&nbsp;&nbsp;&nbsp;cd /tmp/build/binutils<br>
${BINUSNAP-
&nbsp;&nbsp;&nbsp;&nbsp;/src/binutils/binutils-2.10.1/configure --target=$TOOLPREFIX \\<br>
}
${BINUSNAP+
&nbsp;&nbsp;&nbsp;&nbsp;/src/binutils/binutils-<i>YYMMDD</i>/configure --target=$TOOLPREFIX \\<br>
}
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--prefix=/tools \\<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--exec-prefix=/tools/H-$HOSTPREFIX \\<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-v 2&gt;&amp;1 | tee configure.out
</tt></nobr><p>

If there are any problems configuring the tools, you can refer to the file
<tt>configure.out</tt> as a permanent record of what happened.<p>

<li>Build and install the GNU Binary Utilities:<p>

<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;make -w all install 2&gt;&1 | tee make.out
</tt></nobr>
<p>

If there are any problems building the tools, you can use the file
<tt>make.out</tt> as a permanent record of what happened.<p>

<li>Configure GCC, ensuring that the GNU Binary Utilities are at the head of the PATH:<p>

<nobr>
<tt>&nbsp;&nbsp;&nbsp;&nbsp;PATH=/tools/H-$HOSTPREFIX/bin:\$PATH ; export PATH&nbsp;&nbsp;&nbsp;&nbsp;</tt>(for <i>sh</i>, <i>ksh</i> and <i>bash</i> users)<br><tt>
&nbsp;&nbsp;&nbsp;&nbsp;set path = ( /tools/H-$HOSTPREFIX/bin \$path )&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt>(for <i>csh</i> and <i>tcsh</i> users)<br><tt>
&nbsp;&nbsp;&nbsp;&nbsp;mkdir -p /tmp/build/gcc<br>
&nbsp;&nbsp;&nbsp;&nbsp;cd /tmp/build/gcc<br>
${GCCSNAP-
&nbsp;&nbsp;&nbsp;&nbsp;/src/gcc/gcc-2.95.2/configure --target=$TOOLPREFIX \\<br>
}
${GCCSNAP+
<br>&nbsp;&nbsp;&nbsp;&nbsp;/src/gcc/gcc-<i>YYYYMMDD</i>/configure --target=$TOOLPREFIX \\<br>
}
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--prefix=/tools \\<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--exec-prefix=/tools/H-$HOSTPREFIX \\<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--with-gnu-as --with-gnu-ld --with-newlib \\<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-v 2&gt;&amp;1 | tee configure.out
</tt></nobr>
<p>

<li>Build and install GCC:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;make -w all-gcc install-gcc \\
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LANGUAGES="c c++" 2&gt;&1 | tee make.out
</tt></nobr>
<p>

<li>Configure Insight:<p>

<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;mkdir -p /tmp/build/gdb<br>
&nbsp;&nbsp;&nbsp;&nbsp;cd /tmp/build/gdb<br>
&nbsp;&nbsp;&nbsp;&nbsp;/src/gdb/insight-5.0/configure --target=$TOOLPREFIX \\<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--prefix=/tools \\<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--exec-prefix=/tools/H-$HOSTPREFIX \\<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-v 2&gt;&amp;1 | tee configure.out
</tt></nobr>
<p>

<li>Build and install Insight:<p>

<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;make -w all install 2&gt;&1 | tee make.out
</tt></nobr>
<p>
</ol>

On completion, the $TARGETNAME development tool executable files will be located at <tt>/tools/H-$HOSTPREFIX/bin</tt>.
This directory should be added to the head of your PATH.
${WINDOWS+
The eCos Configuration Tool also allows you to set the build tools path.
}

<h3>Troubleshooting</h3>

If you encounter difficulties in building or using the development tools, first check
the <a href="../faq.html#problems_toolchain">eCos FAQ</a> and the
<a href="../../ml/ecos-discuss">ecos-discuss mailing list archive</a> to see
if the topic has come up before. Initial queries
may be directed to the <a href="../intouch.html">ecos-discuss</a> list. However,
there are other mailing lists which may be more appropriate if a problem is clearly
related to a particular tool:
<ul>
<li><a href="http://sources.redhat.com/ml/binutils/">Binutils mailing list</a>
<li><a href="http://sources.redhat.com/ml/gdb/">GDB mailing list</a>
<li><a href="http://sources.redhat.com/ml/crossgcc/">CrossGCC mailing list</a> (for problems specific to GCC cross-compilation)
<li><a href="http://gcc.gnu.org/lists.html">GCC mailing list</a> (for more general GCC problems)
</ul>

Before sending messages to the mailing lists, you would also be advised to
consult the various web sites associated with each list, to see if there is
any relevant documentation or FAQs:
<ul>
<li><a href="http://sources.redhat.com/binutils/">Binutils home page</a>
<li><a href="http://sources.redhat.com/gdb/">GDB home page</a>
<li><a href="http://sources.redhat.com/insight/">Insight home page</a>
<li><a href="http://gcc.gnu.org/">GCC web site</a>
<li><a href="http://www.objsw.com/CrossGCC/">CrossGCC FAQ</a>
</ul>
 
It is also worth noting that all these mailing lists have searchable archives.

<!--#include virtual="../include/footer.html"-->
EOF

}


############
# ARM

TOOLPREFIX=arm-elf
TARGETNAME=ARM

###################
# Windows ARM

HOST=Windows
WINDOWS=
unset GZIP
unset LINUX
HOSTPREFIX=i686-pc-cygwin
BINUTILSBLDDSK=35MB
BINUTILSINSTDSK=25MB
GCCBLDDSK=40MB
GCCINSTDSK=20MB
INSIGHTBLDDSK=110MB
INSIGHTINSTDSK=35MB
TOTBLDDSK=180MB
TOTINSTDSK=75MB

outputfunc win-arm-elf.html

###################
# Linux ARM


HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=30MB
BINUTILSINSTDSK=15MB
GCCBLDDSK=35MB
GCCINSTDSK=15MB
INSIGHTBLDDSK=115MB
INSIGHTINSTDSK=70MB
TOTBLDDSK=185MB
TOTINSTDSK=95MB


outputfunc linux-arm-elf.html

ARMSPECIAL1=
ARMSPECIAL2=


##################
# PPC

TOOLPREFIX=powerpc-eabi
TARGETNAME=PowerPC


###################
# Windows PPC

HOST=Windows
WINDOWS=
unset GZIP
unset LINUX
HOSTPREFIX=i686-pc-cygwin
BINUTILSBLDDSK=40MB
BINUTILSINSTDSK=25MB
GCCBLDDSK=45MB
GCCINSTDSK=25MB
INSIGHTBLDDSK=150MB
INSIGHTINSTDSK=45MB
TOTBLDDSK=230MB
TOTINSTDSK=90MB

outputfunc win-powerpc-eabi.html

###################
# Linux PPC


HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=35MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=40MB
GCCINSTDSK=20MB
INSIGHTBLDDSK=155MB
INSIGHTINSTDSK=80MB
TOTBLDDSK=225MB
TOTINSTDSK=115MB

outputfunc linux-powerpc-eabi.html

##################
# i386

TOOLPREFIX=i386-elf
TARGETNAME="Intel x86"


###################
# Windows i386

HOST=Windows
WINDOWS=
unset GZIP
unset LINUX
HOSTPREFIX=i686-pc-cygwin
BINUTILSBLDDSK=35MB
BINUTILSINSTDSK=25MB
GCCBLDDSK=40MB
GCCINSTDSK=20MB
INSIGHTBLDDSK=105MB
INSIGHTINSTDSK=30MB
TOTBLDDSK=175MB
TOTINSTDSK=70MB

outputfunc win-i386-elf.html

###################
# Linux i386


HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=30MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=30MB
GCCINSTDSK=15MB
INSIGHTBLDDSK=110MB
INSIGHTINSTDSK=65MB
TOTBLDDSK=165MB
TOTINSTDSK=95MB

outputfunc linux-i386-elf.html

##################
# i686 linux

TOOLPREFIX=i686-pc-linux-gnu
TARGETNAME="Intel x86 Linux"


###################
# Linux i686 linux (erm...)

HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=35MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=30MB
GCCINSTDSK=15MB
INSIGHTBLDDSK=115MB
INSIGHTINSTDSK=65MB
TOTBLDDSK=175MB
TOTINSTDSK=95MB

outputfunc linux-i686-linux.html

##################
# tx39

TOOLPREFIX=mips-tx39-elf
TARGETNAME="MIPS TX39"


###################
# Windows tx39

HOST=Windows
WINDOWS=
unset GZIP
unset LINUX
HOSTPREFIX=i686-pc-cygwin
BINUTILSBLDDSK=40MB
BINUTILSINSTDSK=25MB
GCCBLDDSK=40MB
GCCINSTDSK=20MB
INSIGHTBLDDSK=120MB
INSIGHTINSTDSK=45MB
TOTBLDDSK=195MB
TOTINSTDSK=85MB
EXTRAPATCH='
Download the <a href="patches/ecos-binutils-tx39name.pat">ecos-binutils-tx39name.pat</a> patch
to a file and apply it:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/binutils/binutils-2.10.1<br>
&nbsp;&nbsp;&nbsp;&nbsp;tr -d '\'\\r\'' &lt; ecos-binutils-tx39name.pat | patch -p0
</tt></nobr><p>
'

outputfunc win-mips-tx39-elf.html

###################
# Linux tx39


HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=35MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=35MB
GCCINSTDSK=15MB
INSIGHTBLDDSK=125MB
INSIGHTINSTDSK=80MB
TOTBLDDSK=190MB
TOTINSTDSK=110MB
EXTRAPATCH='
Download the <a href="patches/ecos-binutils-tx39name.pat">ecos-binutils-tx39name.pat</a> patch
to a file and apply it:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/binutils/binutils-2.10.1</i><br>
&nbsp;&nbsp;&nbsp;&nbsp;patch -p0 &lt; ecos-binutils-tx39name.pat
</tt></nobr><p>
'

outputfunc linux-mips-tx39-elf.html

EXTRAPATCH=

##################
# sparclite

TOOLPREFIX=sparclite-elf
TARGETNAME="SPARClite"


###################
# Windows sparclite

HOST=Windows
WINDOWS=
unset LINUX
unset GZIP
HOSTPREFIX=i686-pc-cygwin
BINUTILSBLDDSK=35MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=40MB
GCCINSTDSK=20MB
INSIGHTBLDDSK=110MB
INSIGHTINSTDSK=35MB
TOTBLDDSK=180MB
TOTINSTDSK=70MB

outputfunc win-sparclite-elf.html

###################
# Linux sparclite


HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=30MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=35MB
GCCINSTDSK=15MB
INSIGHTBLDDSK=110MB
INSIGHTINSTDSK=65MB
TOTBLDDSK=170MB
TOTINSTDSK=95MB

outputfunc linux-sparclite-elf.html

##################
# SH

TOOLPREFIX=sh-elf
TARGETNAME="Hitachi SH"
GCCSNAP=
BINUSNAP=

###################
# Windows SH

HOST=Windows
WINDOWS=
# Note GZIP set this time for the gcc snapshot because it only comes in .gz format
GZIP=
unset LINUX
HOSTPREFIX=i686-pc-cygwin
BINUTILSBLDDSK=40MB
BINUTILSINSTDSK=25MB
GCCBLDDSK=50MB
GCCINSTDSK=25MB
INSIGHTBLDDSK=110MB
INSIGHTINSTDSK=35MB
TOTBLDDSK=195MB
TOTINSTDSK=80MB

outputfunc win-sh-elf.html

###################
# Linux SH


HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=35MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=40MB
GCCINSTDSK=20MB
INSIGHTBLDDSK=115MB
INSIGHTINSTDSK=80MB
TOTBLDDSK=185MB
TOTINSTDSK=115MB

outputfunc linux-sh-elf.html

unset GCCSNAP
unset BINUSNAP

##################
# V850

TOOLPREFIX=v850-elf
TARGETNAME="NEC V850"
GCCSNAP=

###################
# Windows V850

HOST=Windows
WINDOWS=
# Note GZIP set this time for the gcc snapshot because it only comes in .gz format
GZIP=
unset LINUX
HOSTPREFIX=i686-pc-cygwin
BINUTILSBLDDSK=28MB
BINUTILSINSTDSK=21MB
GCCBLDDSK=33MB
GCCINSTDSK=13MB
INSIGHTBLDDSK=110MB
INSIGHTINSTDSK=63MB
TOTBLDDSK=171MB
TOTINSTDSK=97MB

outputfunc win-v850-elf.html

###################
# Linux V850


HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=28MB
BINUTILSINSTDSK=21MB
GCCBLDDSK=33MB
GCCINSTDSK=13MB
INSIGHTBLDDSK=110MB
INSIGHTINSTDSK=63MB
TOTBLDDSK=171MB
TOTINSTDSK=97MB

outputfunc linux-v850-elf.html

unset GCCSNAP

##################
# mn10300

TOOLPREFIX=mn10300-elf
TARGETNAME="MN10300/AM33"
GCCSNAP=

###################
# Windows mn10300

HOST=Windows
WINDOWS=
# Note GZIP set this time for the gcc snapshot because it only comes in .gz format
GZIP=
unset LINUX
HOSTPREFIX=i686-pc-cygwin
BINUTILSBLDDSK=35MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=40MB
GCCINSTDSK=20MB
INSIGHTBLDDSK=125MB
INSIGHTINSTDSK=35MB
TOTBLDDSK=195MB
TOTINSTDSK=70MB
EXTRAPATCH='
Some hosts have had difficulty compiling the mn10300 architectural
simulator (part of the GDB source distribution).
Specifically, the compiler may abort when compiling the source
file <tt>sim/mn10300/semantics.c</tt>.
If this happens, download the <a href="patches/ecos-mn10300-sim-o1.pat">
ecos-mn10300-sim-o1.pat</a> patch to a file and apply it to
reduce the compiler optimization level when compiling the file:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gdb/insight-<i>YYYYMMDD</i><br>
&nbsp;&nbsp;&nbsp;&nbsp;tr -d '\'\\r\'' &lt; ecos-mn10300-sim-o1.pat | patch -p0
</tt></nobr><p>
'

outputfunc win-mn10300-elf.html

###################
# Linux mn10300


HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=30MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=35MB
GCCINSTDSK=15MB
INSIGHTBLDDSK=145MB
INSIGHTINSTDSK=90MB
TOTBLDDSK=205MB
TOTINSTDSK=120MB
EXTRAPATCH='
Some hosts have had difficulty compiling the mn10300 architectural
simulator (part of the GDB source distribution).
Specifically, the compiler may abort when compiling the source
file <tt>sim/mn10300/semantics.c</tt>.
If this happens, download the <a href="patches/ecos-mn10300-sim-o1.pat">
ecos-mn10300-sim-o1.pat</a> patch to a file and apply it to
reduce the compiler optimization level when compiling the file:<p>
<nobr><tt>
&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gdb/insight-<i>YYYYMMDD</i><br>
&nbsp;&nbsp;&nbsp;&nbsp;patch -p0 &lt; ecos-mn10300-sim-o1.pat
</tt></nobr><p>
'

outputfunc linux-mn10300-elf.html

unset GCCSNAP
EXTRAPATCH=

##################
# thumb

TOOLPREFIX=arm-elf
TARGETNAME="ARM THUMB"
GCCSNAP=
USENEWSNAPSHOT=
EXTRASNAPPATCH='
At this time no patches appear to be required for ARM Thumb support.'

###################
# Windows thumb

HOST=Windows
WINDOWS=
# Note GZIP set this time for the gcc snapshot because it only comes in .gz format
GZIP=
unset LINUX
HOSTPREFIX=i686-pc-cygwin
BINUTILSBLDDSK=35MB
BINUTILSINSTDSK=25MB
GCCBLDDSK=45MB
GCCINSTDSK=25MB
INSIGHTBLDDSK=110MB
INSIGHTINSTDSK=140MB
TOTBLDDSK=185MB
TOTINSTDSK=75MB

outputfunc win-thumb-elf.html

###################
# Linux thumb

HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=30MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=40MB
GCCINSTDSK=20MB
INSIGHTBLDDSK=115MB
INSIGHTINSTDSK=60MB
TOTBLDDSK=180MB
TOTINSTDSK=95MB

outputfunc linux-thumb-elf.html

EXTRAPATCH=
unset GCCSNAP
unset USENEWSNAPSHOT
unset EXTRASNAPPATCH

##################
# vr4300

TOOLPREFIX=mips64vr4300-elf
TARGETNAME="NEC MIPS VR4300"
GCCSNAP=

###################
# Windows vr4300

HOST=Windows
WINDOWS=
# Note GZIP set this time for the gcc snapshot because it only comes in .gz format
GZIP=
unset LINUX
HOSTPREFIX=i686-pc-cygwin
BINUTILSBLDDSK=40MB
BINUTILSINSTDSK=25MB
GCCBLDDSK=45MB
GCCINSTDSK=20MB
INSIGHTBLDDSK=115MB
INSIGHTINSTDSK=35MB
TOTBLDDSK=195MB
TOTINSTDSK=75MB
EXTRASNAPPATCH='
Download the <a href="patches/ecos-gcc-snap.pat">ecos-gcc-snap.pat</a> patch
to a file and apply it:<p>
<nobr><tt>
<!--&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gcc/gcc-<i>YYYYMMDD</i><br>-->
&nbsp;&nbsp;&nbsp;&nbsp;tr -d '\'\\r\'' &lt; ecos-gcc-snap.pat | patch -p0
</tt></nobr><p>
'

outputfunc win-vr4300-elf.html

###################
# Linux vr4300


HOST=Linux
LINUX=
GZIP=
unset WINDOWS
HOSTPREFIX=i686-pc-linux-gnu
BINUTILSBLDDSK=40MB
BINUTILSINSTDSK=20MB
GCCBLDDSK=40MB
GCCINSTDSK=15MB
INSIGHTBLDDSK=130MB
INSIGHTINSTDSK=70MB
TOTBLDDSK=205MB
TOTINSTDSK=105MB
EXTRASNAPPATCH='
Download the <a href="patches/ecos-gcc-snap.pat">ecos-gcc-snap.pat</a> patch
to a file and apply it:<p>
<nobr><tt>
<!--&nbsp;&nbsp;&nbsp;&nbsp;cd /src/gcc/gcc-<i>YYYYMMDD</i><br>-->
&nbsp;&nbsp;&nbsp;&nbsp;patch -p0 &lt; ecos-gcc-snap.pat
</tt></nobr><p>
'

outputfunc linux-vr4300-elf.html

EXTRAPATCH=
unset GCCSNAP

#EOF
