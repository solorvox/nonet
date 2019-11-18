# nonet
Command line script used for per-application firewall blocking

# Installation
Run `./install.sh`, the script will require sudo to copy the iptables boot script and create the system group.  You may decline the boot script but the group is required to function.

# Manual Installation
Copy `nonet` into your `$HOME/bin` directory and ensure it is marked as executable using `chmod +x nonet`.

Create a system group nonet, remove the password and add the current user to the group list.

You can install the iptables boot script located in `etc/network/if-pre-up.d/nonet` into your `/etc` directory or manually add it each boot.  

# Usage
`nonet ping www.google.com`

or 

`nonet firefox`

# Network access test
By default `nonet` will allow access to localhost (127.0.0.0/8) but will block all other outbound traffic.  The script will test for the existance of group `nonet` and abort if not found.  

It then attempts to ping your default gateway.  If successful, it will prompt the user to to run a iptables command via sudo.  That command blocks outbound traffic from any process with the group `nonet`.   This question has a time-out of 15 seconds with a default of `no`. In the event it was run from a GUI the user would not see the request for input on the terminal.  If your application appears to stop loading, please check it can run from the command line and verify the output. 

# Steam games 
To manually block access to a Steam library item, right click on the name in the list and select *properties*.  Then on the *General* tab select "Set Launch Options".  Change the field to:

`nonet %command%`

Steam will replace *%command%* with the default command line for the application.  

# Tips
- Put the script to your $HOME/bin directory so it will be in your path for easy access
- All child processes will also inherit the group and thus be blocked.  Running `nonet steam` would block *all* access to steam and any games run.
- nonet run will check for the iptables rule on run and prompt to add if network access is detected.  See installation for system boot script. 
