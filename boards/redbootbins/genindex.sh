#! /bin/sh

# Generate an HTML index for all the subdirectories

for i in `find . -name CVS -prune -o -type d -print` ; do
    cat > $i/index.html <<EOF
<HTML>
<HEAD>
<TITLE>RedBoot binaries and support files for platform `echo $i | sed 's#.*/##g'`</TITLE>
</HEAD>

<body bgcolor="#FFFFFF" text="#000000" link="#CC0000" alink="#FF0000" vlink="#880000">

<h1>RedBoot binaries and support files for platform `echo $i | sed 's#.*/##g'`</h1>
<HR noshade SIZE=3>
<ul>
EOF
    for j in $i/* ; do
        SHORTNAME=`echo $j | sed 's#.*/##g'`
        if [ $SHORTNAME == "CVS" -o $SHORTNAME == index.html ]; then
            continue
        fi
        SIZE=`ls -l $j | awk '{print $5}'`
        SIZEK=`echo "$SIZE/1024" | bc`
        cat >> $i/index.html <<EOF
<li><a href="$SHORTNAME">$SHORTNAME</a> ($SIZEK Kbytes)</li>
EOF
    done
    cat >> $i/index.html <<EOF
</ul>
<HR noshade SIZE=3>
</body>
</html>
EOF

done
