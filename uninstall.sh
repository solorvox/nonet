#!/bin/bash 
# nonet uninstaller
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
DEFAULT_DIR="/usr/local/bin"

echo -n "Checking for script... "
if [ -f "$DEFAULT_DIR/nonet" ]; then
	sudo rm "$DEFAULT_DIR/nonet"
	echo "removed $DEFAULT_DIR/nonet"
else
	echo "not found"
fi

echo -n "Checking for boot script... "
if [ -f "/${NETSCR}" ]; then
	sudo rm /${NETSCR}
	echo "removed /${NETSCR}"
else
	echo "not found."
fi

echo "Checking for nonet iptables rule (sudo required)"
# remove rule (if valid)
RULE=$(sudo /sbin/iptables -L OUTPUT |grep 'GID.*nonet')

if [[ ! -z "$RULE" ]]; then
	NUM=$(sudo /sbin/iptables --line-numbers -L OUTPUT |grep nonet |  awk '{print $1}')
	if [[ ! -z "$NUM" ]]; then
		for n in $NUM; do	
			echo "Removing iptables rule number $n"
			sudo /sbin/iptables -D OUTPUT $n
		done
	fi
else
	echo "No iptables rule found."
fi


echo -n "Checking for group [$GROUP]... "
if [ $(getent group $GROUP) ]; then
	echo "found, removing"
	sudo groupdel $GROUP
else
	echo "not found!"
fi

echo "Uninstall complete."
