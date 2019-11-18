# nonet
Command line script used for per-application firewall blocking

# usage
`nonet ping www.google.com`
or 
`nonet firefox`

# Network access test
By default, `nonet` will allow acess to localhost (127.0.0.0/8) but will block all other traffic.  The script will test for the group `nonet` and abort if not found.  

It then attempts to ping your default gateway.  If successful, it will prompt the user to to run a iptables command via sudo that blocks access to `nonet` group.  This question has a timeout of 15 seconds with a default of `no` in case it was run from a GUI. 

# Steam games 
You can manually block access to a Steam library game by setting the "Launch Options" on the General tab of properties.

`nonet %command%`

Steam will fill in the %command% with the default application.  

# Tips
- Put the script to your $HOME/bin directory so it will be in your path for easy access
- All child processes will also inherit the group and thus be blocked.  Running `nonet steam` would block *all* access to steam and any games run.
- If you want to quick insert the blocking rule to iptables, simply open a terminal and run `nonet` without arguments.  It will prompt you to add the rule via sudo. Adding a rule this way will only be good until you reboot.
- For a permanent blocking rule, add a script to `/etc/network/if-pre-up.d/nonet` with the following:
`/sbin/iptables -I OUTPUT -m owner --gid-owner nonet ! -d 127.0.0.0/8 -j REJECT --reject-with icmp-net-unreachable` or using your favourite firewall tool.
