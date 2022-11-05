#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <target dir>" 1>&2
    echo 1>&2
    exit 1
fi

targetdir="$1"
if [ -d "$targetdir" ]; then
    n=$(ls "$targetdir" 2>/dev/null | wc -l)
    if [ $n -gt 0 ]; then
	echo "Error: dir '$targetdir' not empty." 1>&2
	exit 2
    fi
else
    mkdir "$targetdir"
fi

# Get list of packages already installed
dpkg -S /usr/share/backgrounds | cut -f 1 -d ':' | tr ',' '\n' | tr -d ' ' > "$targetdir/installed.txt"

# Get list of available packages
# edubuntu-artwork is corrupted, exclude
apt-cache search ubuntu wallpapers | cut -f 1 -d ' ' | grep -v 'edubuntu-artwork'  > "$targetdir/wallpapers-packages.txt"
#echo budgie-wallpapers >"$targetdir/wallpapers-packages.txt"

nb=$(cat "$targetdir/wallpapers-packages.txt" | wc -l)

no=0
cat "$targetdir/wallpapers-packages.txt" | while read package; do
    no=$(( $no + 1 ))
    echo 1>&2
    echo "# Package $no/$nb: '$package'" 1>&2
    if grep -q "$package" "$targetdir/installed.txt" ; then
	installed=1
    else
	installed=
	sudo apt install -qq -y "$package"
	if [ $? -ne 0 ]; then
	   echo "An error happened, aborting" 1>&2
	   exit 11
	fi
    fi
    dpkg -L "$package" | grep .jpg | while read f; do
	b=$(basename "$f")
#	echo -n "    $b... " 1>&2
	lineNo=$(grep -n "$b" "/usr/share/doc/$package/copyright" | cut -f 1 -d ':')
	if [ ! -z "$lineNo" ]; then
	    license=$(grep -n '^License:' "/usr/share/doc/$package/copyright" | cut -f 1,3 -d ':' | while read licenseLine; do
	       licenseLineNo=$(echo "$licenseLine" | cut -f 1 -d ':')
	       licenseThis=$(echo "$licenseLine" | cut -f 2  -d ':' | tr -d ' ')
	       if [ $licenseLineNo -gt $lineNo ]; then
		   echo "$licenseThis"
	       fi
	    done | head -n 1)
#	    echo "$license" 1>&2
	fi
	if [ -z "$lineNo" ] || [ -z "$license" ]; then
	    license="NOTFOUND"
	    echo "Warning: license not found for $b in $package, not copying." 1>&2
	    echo -e "$package\t$b" >> "$targetdir/licenses-not-found.txt"
	else
	    cp -a "$f" "$targetdir"
	    echo -e "$license\n$package" > "$targetdir/$b.license"
	    echo "$license"
	fi
    done > "$targetdir/licenses.txt" 
    nblicenses=$(cat "$targetdir/licenses.txt" | grep -v 'NOTFOUND' | sort -u | wc -l)
    if [ -z "$nblicenses" ]; then
	echo "Warning: problem with getting number of licenses in '$package'" 1>&2
    else
	if [ $nblicenses -gt 1 ]; then
	    echo "Warning: multiple licenses for package '$package'" 1>&2
	fi
    fi
    if [ -z "$installed" ]; then
	sudo apt remove -qq --purge -y "$package"
	if [ $? -ne 0 ]; then
	   echo "An error happened, aborting" 1>&2
	   exit 11
	fi
	sudo apt autoremove -y
    fi
done
rm -f "$targetdir/installed.txt" "$targetdir/wallpapers-packages.txt" "$targetdir/licenses.txt"
