# nonet
Command line script used for per-application firewall blocking

# usage
`nonet ping www.google.com`

By default, `nonet` will allow acess to localhost (127.0.0.0/8) but blocks all other traffic.  The script will test for the group `nonet` and then abort if not found.  

# Network access test
The script will attempt (by default) to ping your default gateway.  If sccessful, it will ask the user to add a iptables rule via sudo to block access to `nonet` group.  This question has a timeout of 15 seconds with a default of `no` in case it run from a GUI. 

# Steam games 
You can manually block access to a Steam library game by setting the "Launch Options" on the General tab of properties.

`nonet %command%`

Steam will fill in the %command% with the default application.  
