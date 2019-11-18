#!/bin/bash 
# nonet installer
# Copyright 2012 Solorvox <solorvox@epic.geek.nz>
# Source: https://github.com/solorvox/nonet
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

NETSCR="etc/network/if-pre-up.d/"
GROUP="nonet"

if [ ! -d $HOME/bin ]; then
	echo "Creating local user binaries directory $HOME/bin"
	mkdir $HOME/bin
fi
# ensure execute bit
chmod +x nonet
echo "Copying nonet to $HOME/bin"
cp nonet $HOME/bin


# ensure execute bit
chmod +x ${NETSCR}/nonet

echo -n "Checking for required group [$GROUP]... "
# check for existance of group
if [ ! $(getent group $GROUP) ]; then
	echo " *not found*"
	echo "Creating new group [$GROUP] using sudo"
	# add required group
	sudo groupadd $GROUP
	# remove the password so any user can change via sg
	sudo gpasswd -r $GROUP
	# add the current user to the group
	sudo gpasswd -M $USER $GROUP
	GROUPADD=1
else
	echo "found!"
fi

echo 
echo "You can manually add the iptables rule when run each time, or you may choose to install it into the system boot scripts. (requires sudo)"
echo -n "Install iptable script into system /${NETSCR} [y/N]? "
read ans
if [ "$ans" == "y" -o "$ans" == "Y" ]; then
	echo " installing ${NETSCR}nonet to /${NETSCR}"
	sudo cp ${NETSCR}nonet /${NETSCR}
else
	echo " skipped boot iptable rule script"
fi

echo "Installation complete."
if [ "$GROUPADD" == "1" ]; then
	echo
	echo "NOTE: When adding new system group, it often is required you logout and back to use the new group."
fi
