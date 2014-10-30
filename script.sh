#!/bin/bash

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export version=V1.0
export DATE=$(date +"%d-%m-%Y")
export TIME=$(date +"%T")
function g8_bld_menu {
	cmd=(dialog --title "$G8_TITLE" --keep-tite --menu "Compiling Kernel " 25 96 16)
		options=( 1 "Install Necessary files and libraries"
				2 "Make backup of Previous config file"
				3 "Clean Kernel"
				4 "Make Menu Config"
				5 "Compile Kernel"
				6 "Make Boot Image and Kernel Image"
				7 "Exit"
			)
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		for choice in $choices
			do
				case $choice in
					1)
					clear
					sudo apt-get -y install gcc-arm-linux-gnueabihf build-essential lzop libncurses5-dev libssl-dev
					cp rockchip-mkbootimg/mkbootimg /usr/sbin/
					g8_bld_menu
					;;
			2)
				clear
				mkdir -p Backup/backup-$DATE-$TIME
				cp ${pwd}kernel/.config ${pwd}Backup/backup-$DATE-$TIME/
				cp ../Image/boot.img ${pwd}Backup/backup-$DATE-$TIME/
				cp ../Image/kernel.img ${pwd}Backup/backup-$DATE-$TIME/
				g8_bld_menu
				;;
			3)
				clear
				cd ${pwd}kernel/
				make mrproper
				cd ..
				g8_bld_menu
				;;
			4)
				clear
				cd ${pwd}kernel/
				make menuconfig
				cd ..
				g8_bld_menu
				;;	
			5)
				clear
				cd ${pwd}kernel/
				make -j8 
				cd ..
				g8_bld_menu
				;;
			6)	
				clear
				cat kernel/arch/arm/boot/zImage > ../Image/kernel.img
				make -C initrd
				mkbootimg --kernel ../Image/kernel.img --ramdisk initrd.img -o ../Image/boot.img
				rm initrd.img
				g8_bld_menu
				;;
			7)
				exit 0
				;;
			esac
				done
}

g8_bld_menu 
