# The script for managing the LUKS encrypted hard drives
#
# Author : Rishav Das (https://github.com/rdofficial)
#

# Defining the ANSII color codes for the bash script colored output to the terminal screen
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
blue="\033[94m"
defcol="\033[00m"

mountEncryptedPartition() {
	# The function for mounting the partition as per user defined input

	# Asking the user for the partition name
	echo
	read -p "Enter the partition name (example - sda1) : " partition_name
	echo
	if [[ -z $partition_name ]]; then
		# If the user enters a empty value for the partition name

		printf "\n${redCol}[ Please enter a valid partion name ]${defcol}\n"
	elif [[ -z $(lsblk -o NAME | grep $partition_name) ]]; then
		# If the user enters a wrong partition name
		printf "\n${red}[ Please enter a valid partition name whose drive is connected to the computer ]${defcol}\n"
	else
		# If the user mentions a correct partition name, then we proceed to mount the device
		
		cryptsetup luksOpen /dev/$partition_name $partition_name
		echo
		read -p "Enter the mountpoint location : " mount_location

		# Asking the user for the mountpoint location
		if [[ $(ls $mount_location) = *"No such file or directory"* ]]; then
			printf "\n${red}[ No such directory found that can be the mount point ]${defcol}\n"
		else
			if [[ $(mount /dev/mapper/$partition_name $mount_location) = *"does not exists"* ]]; then
				# If the mount point location as per specified by the user does not exists
				
				printf "\n"
			else 
				# If the drive is mounted successfully

				printf "\n${green}Done mounting at ${yellow}${mount_location}${green}!!!${defcol}\n"
			fi
		fi
	fi
}

unmountEncryptedPartition() {
	# The function for unmounting the LUKS partition as per user defined input

	# Asking the user for the partition name
	echo
	read -p "Enter the partition name (example - sda1) : " partition_name

	# Checking if the mounted device really does exists or not
	if [[ $(lsblk -o NAME,TYPE | grep crypt) = *"${partition_name}"* ]]; then
		# If the encrypted partition is mounted, then we proceed to unmount and close the luks encrypted partition

		umount /dev/mapper/$partition_name
		cryptsetup luksClose $partition_name
		printf "\n${green}The requested partition is unmounted from the computer!!!${defcol}\n"

	else 
		# If no such encrypted partition is mounted

		printf "\n{red}[ No such encrypted partition mounted ]${defcol}\n"
	fi
}

encryptPartition() {
	# The function for encrypting a partition in the linux filesystem and with LUKS

	# Asking the user for the partition name that needs to be LUKS formatted and encrypted
	echo
	read -p "Enter the partition name (example - sda1 ) : " partition_name

	if [[ -z $(lsblk -o NAME | grep $partition_name) ]]; then
		printf "\n${red}[ No such partition exists ]${defcol}\n"
		return 0
	fi

	printf "\n${red}[ THE DATA ON THE DISK IS GOING TO BE ERASED AND MAKE SURE YOU WONT USE THIS DRIVE FOR THE SYSTEM FILES LIKE /home OR /root ]${defcol}\n"
	read -p "Press enter key to continue..."

	# Formatting the data on the partition and making it LUKS encrypted
	wipefs --all /dev/$partition_name
	cryptsetup luksFormat --verbose --verify-passphrase /dev/$partition_name
	cryptsetup luksOpen /dev/$partition_name $partition_name

	# Asking the user for the partition name
	echo; read -p "Enter the label name for the partition : " label

	# Making the filesystem ext4 on the LUKS encrypted partition
	mfks.ext4 -L $label /dev/mapper/$partition_name
	tune2fs -m 0 /dev/mapper/$partition_name
}

mainMenu() {
	# Function to print the main menu and initiating all other functions defined in the script

	printf "\n\t\033[07;93m[ LUKS Partition Manager ]${defcol}\n\n${green}[${red}1${green}] ${blue}Mount a partition\n${green}[${red}2${green}] ${blue}Unmount a partition\n${green}[${red}3${green}] ${blue}Encrypt a partition with LUKS\n${green}[${red}0${green}] ${blue}Exit${defcol}\n"
	echo
	read -p "Enter your choice : " choice

	if [ $choice = "1" ]; then
		# If the user chooses the option for mounting a partition
		mountEncryptedPartition

	elif [ $choice = "2" ]; then
		# If the user chooses the option for unmounting an encrypted partition
		unmountEncryptedPartition

	elif [ $choice = "3" ]; then
		# If the user chooses the option for encrypting a partition in LUKS format
		encryptPartition

	else
		echo "EXITING..."
	fi
}

clear

# Checking for the arguments
if [[ $1 = "1" ]]; then
	mountEncryptedPartition
elif [[ $1 = "2" ]]; then
	unmountEncryptedPartition
elif [[ $1 = "3" ]]; then
	encryptPartition
fi

# Calling the mainMenu function
mainMenu
