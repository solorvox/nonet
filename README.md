# nonet
Command line script used for per-application firewall blocking.

# Installation
First clone the repo

`git clone https://github.com/solorvox/nonet`

Then `cd nonet` and run `./install.sh`.  The script will require sudo to copy the iptables boot script and create the system group.  You may decline the boot script installation but the system group is required. If you decide to install the boot script, a logout is required for the script to be loaded in the system.

# Manual installation
Create a system group nonet, remove the password and add the current user to the group list.

Copy `nonet` into your $PATH somewhere like the `$HOME/bin` directory and ensure it is marked as executable using `chmod +x nonet`.

You can install the provided iptables boot script located in `/etc/NetworkManager/dispatcher.d/pre-up.d/nonet` into your `/etc` directory or manually add that rule each boot. If you decide to install the boot script, a logout is required for the script to be loaded in the system.

# Usage
`nonet ping www.google.com`

or 

`nonet firefox`

# Network access test
By default `nonet` will allow access to localhost (127.0.0.0/8) but will block all other outbound traffic.  The script will test for the existence of group `nonet` and abort if not found.  

It then attempts to ping your default gateway.  If successful, it will prompt the user to add a rule to iptables via sudo.  That command blocks outbound traffic from any process with the group `nonet`.   The prompt has a time-out of 15 seconds with a defaulting to `no`. In the event it was run from a GUI the user would not see the request for input on the terminal.  This will then exit with an error.  If your application appears to stop loading, please check it can run from the command line and verify the output.  Adding the boot rule script will prevent this problem.

# Steam games 
To manually block access to a Steam library item, right click on the name in the list and select *properties*.  Then on the *General* tab select "Set Launch Options".  Change the field to:

`nonet %command%`

Steam will replace *%command%* with the default command line for the application.  You will still be able to receive achievements but the game will not be allowed out. 

# Updates
To update any changes from a previously installed update git via:

`git pull origin master`

Then you can re-run `./install.sh` to copy over any changes.

# Uninstall
Simply run the provided script `./uninstall.sh`


# Tips
- All child processes will also inherit the group and thus be blocked.  Running `nonet steam` would block *all* access to steam and any games run.
- nonet run will check for network access and prompt for sudo access to run iptables to add the rule when run from terminal.  See installation for system boot script to have this done automatically.
- Take a look at the etc/network/if-pre-up.d/nonet for options to whitelist and disable logging.  You will need to modifiy your TESTIP in the base nonet script.  You could use your ISP's DNS or router for example.
