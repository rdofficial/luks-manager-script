# LUKS Manager Scripts [bash]

This project contains the scripts for managing LUKS encrypted hard drive partitions. [ ONLY FOR LINUX OPERATING SYSTEMS ]

## Information about the LUKS

The Linux Unified Key Setup (LUKS) is a disk encryption specification created by Clemens Fruhwirth in 2004 and was originally intended for Linux. While most disk encryption software implements different, incompatible, and undocumented formats[citation needed], LUKS implements a platform-independent standard on-disk format for use in various tools. This not only facilitates compatibility and interoperability among different programs, but also assures that they all implement password management in a secure and documented manner. The reference implementation for LUKS operates on Linux and is based on an enhanced version of cryptsetup, using dm-crypt as the disk encryption backend. Under Microsoft Windows, LUKS-encrypted disks can be used with the now defunct FreeOTFE (formerly DoxBox, LibreCrypt). LUKS is designed to conform to the TKS1 secure key setup scheme.

## How to use

To use the scripts, just open up a terminal and go to the folder containing the file '__script.sh__' file of this project / repository. And, then type the below command.
```
sudo bash script.sh
```
Note that the application requires sudo access i.e., Super user access in order to properly work with the hard drive partitions and the cryptsetup software. Also, the software _cryptsetup_ also should be installed on your linux installed computer system.

## About the author

The project is created by Rishav Das ([https://github.com/rdofficial/](https://github.com/rdofficial)).
