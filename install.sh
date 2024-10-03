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

NETSCR="etc/NetworkManager/dispatcher.d/pre-up.d/"
GROUP="nonet"
DEFAULT_DIR="/usr/local/bin"

echo -n "Install path for script [press enter for default: $DEFAULT_DIR] ? "
read insdir

if [ -z "$insdir" ]; then
	DST=$DEFAULT_DIR
else
	DST=$insdir
fi

if [ ! -d "$DST" ]; then
	echo "Creating directory $DST"
	sudo mkdir -p "$DST"
fi

# ensure execute bit
chmod +x nonet
echo "Copying nonet to $DST"
sudo cp nonet "$DST"

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
	echo "Attempting to run iptables rule"
	sudo /${NETSCR}nonet
else
	echo " skipped boot iptable rule script"
	echo "NOTE: you must either manually add the iptables rule or run nonet and add it after each reboot."
fi

echo 
echo "Installation complete!"
if [ "$GROUPADD" == "1" ]; then
	echo
	echo "NOTE: After adding new system group you are required to logout and back in to use the new group."
fi
