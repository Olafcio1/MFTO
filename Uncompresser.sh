#!/usr/bin/bash
if [[ "$1" == "" || "$2" == "" ]]; then
	echo "Usage: $0 [source file] [output directory]"
	exit 0
fi
if [[ -d "$1" ]]; then
	echo "[ERR] Specified file '$1' does not exists!"
	exit 1
elif [[ ! -e "$1" ]]; then
	echo "[ERR] Specified file/directory '$1' does not exists!"
	exit 1
fi
if [[ -d "$2" ]]; then
	cd $2
	mkdir _temp$2
elif [[ -f "$2" ]]; then
	echo "[ERR] Specified output directory arleady exists and is a file!"
	exit 1
elif [[ ! -e "$2" ]]; then
	mkdir _temp$2
fi
_PATH="$(pwd)"
function _exit() {
	cd $_PATH
	chmod u+rwx ./_temp$2
	rm -R ./_temp$2
	echo " --- Uncompresser crashed during unarchiving process! --- "
	echo "|                                                        |"
	echo "|               Cleaning up made trash...                |"
	echo "|  +++++++++++++++++++++++++++++-----------------------  |"
	echo "|                                                        |"
	echo " -------------------------------------------------------- "
	exit 1
}
cd '_temp'"$2"
while read p; do
	if [[ "$(echo $p | cut -c -5)" == "#----" ]]; then
		cfile="$(echo $p | cut -c 6-)"
		cfile_nice="$(echo $p | tr -d '.' | tr -d ' ')"
		if [[ "$cfile_nice" == "" ]]; then
			echo "[ERR] Archive error: specified output file with empty name!"
			_exit
		fi
		continue
	fi
	if [[ "$cfile" == "" ]]; then
		echo "[ERR] Archive error: no output file is specified at start of file!"
		_exit
	fi
	echo "$p" >> $cfile
done <$_PATH/$1
cd $_PATH
mv ./_temp$2 ./$2
echo "Uncompressed succesfully!"
