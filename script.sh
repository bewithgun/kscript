#!/bin/bash
verison=1.0
v="verison=1.0"
printline()
{
echo "---------------------------------------------------------------";
}

updates()
{
if [ "$(wget -O - https://raw.githubusercontent.com/bewithgun/kscript/master/script.sh > temp.sh && cat temp.sh | grep version -m1)" = "$v" ]
then
a=""
else
cd $HOME/bin && wget https://raw.githubusercontent.com/bewithgun/kscript/master/script.sh && chmod 777 *;
echo "Scipt updated"
fi
rm -rf temp.sh
cd -
}

n=`basename "$(realpath $0)"`
sl=$(pwd)/$n
mkdir -p $HOME/bin
exi=$(ls $HOME/bin | grep "$n")

if [ "$exi" = "$n" ]; then
	a=""
else
	cp $sl $HOME/bin
	chmod 777 $HOME/bin/*
	ln -s $HOME/bin/$n $HOME/bin/s
	touch $HOME/.profile
	echo ""export PATH=$HOME/bin:$PATH"" > $HOME/.profile
	source $HOME/.profile
	printline
	echo "Installed script , now you can run script using s command"
	printline
	updates
fi

export aarch64=$(find $HOME -name *-gcc | grep bin/aarch64-linux-android-gcc -m1)
export gcc="gcc"
export CROSS_COMPILE=${aarch64%gcc}
export arm32=$(find $(pwd) -name *-gcc | grep bin/arm-linux-androideabi-gcc -m1)
export CROSS_COMPILE_ARM32=${arm32%gcc}
export KBUILD_BUILD_USER="incinerator"
export KBUILD_BUILD_HOST="incinerated-laptop"

printline
mkdir -p ~/.tmpdata
data=$HOME/.tmpdata/data.txt
touch $data
export toc=$(find . -maxdepth 1 -name AndroidKernel.mk | grep "" -m1)

if [ "$toc" = "" ]; then
echo "Please run this script in kernel tree";
printline
exit 1
fi

make clean O=out && make mrproper O=out
make X00T_defconfig O=out
make -j$(nproc --all) O=out

#"$(wget -O - https://raw.githubusercontent.com/bewithgun/kscript/master/script.sh > temp.sh && cat temp.sh | grep version)" == "$v"
