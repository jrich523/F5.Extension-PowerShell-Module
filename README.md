F5.Extension PowerShell Module
==============================

A module the extend the functionality of the icontrol snappin which can be downloaded here:

[https://devcentral.f5.com/d/microsoft-powershell-with-icontrol](https://devcentral.f5.com/d/microsoft-powershell-with-icontrol "iControl snappin")




## Install ##
	iex (new-object System.Net.WebClient).DownloadString('https://raw.github.com/jrich523/F5.Extension-PowerShell-Module/master/Install.ps1')

## Details ##

Functions are in the same form for *Verb*-F5.LTM*function*
functions can be listed by running

	gcm -module f5.extension

I am by no means an F5 expert and this is in the very early stages so feedback/Requests are very much welcomed.

## Areas to be extended ##

- LTM
	- Pools
	- Virtaul Servers
	- Nodes
	- Monitors

Other areas upon request.