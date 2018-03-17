## Notes

### Storage

The UDOO X86 supports SD card, SATA, and M.2 type SSD. It also has a model that has a built-in 32GB eMMC option.

I tested using a SD card (Samsung 32GB EVO Select U1) and it was too slow for my liking. Definitely the cheaper of the options available (only $13 on Amazon at the time). If speed isn't your primary concern then this would be an option to keep cost down. It would be worth looking at the Samsung 64GB EVO Select U3 or other U3 SD cards as they should be faster than the U1.

I picked up the lowest cost 64GB M.2 SSD I could get on Amazon. It turned out to be magnitudes faster than the SD card. In comparison, it took 20+ minutes to install Ubuntu onto the Samsung 32GB EVO and only about 5 minutes onto the M.S SSD.

You might look at the 1.8 inch SATA SSD available if space and cabling is less of a concern. With these you'd likely get more performance and space per dollar. I won't need more than 64GB per node and didn't want to deal with the extra parts and cabling.

I figured if the SD card was this slow then a USB key wouldn't be much faster so I didn't test this option. But a faster USB drive could be an option if space and cabling isn't a concern.

### Network

One of my goals was to have an isolated network for protocols like PXE, DHCP, and DNS. This should allow use of the cluster for testing that might conflict with the parent network. I also needed something that would act as a VPN server as it would be my way into the network.

I had looked at some smaller home routers and boards to run pfSense. But none of them fit well (not enough ports, too big, more expensive than home routers). I then stumbled upon Mikrotik (which I had known about for many years). The [hEX](https://mikrotik.com/product/RB750Gr3) (and [hEX lite](https://mikrotik.com/product/RB750r2)) were pretty much a perfect fit. I was able to prototype everything the router needed to do in VirtualBox thanks to the Mikrotik x86 distribution.

The next model up (RB2011iL-IN) had 8 ports but not all were gigabit. I think if there were an 8 port version of the hEX or hEX lite at $99 that would have been the better buy rather than a hEX and dumb switch. Even the bare RouterBOARD with more than 1 port ([the RB450](https://mikrotik.com/product/RB450)) costs more than the hEX.

Another thought was to use the [hAP](https://mikrotik.com/product/RB951Ui-2nD) and do wireless client to the parent network. This would remove the need for a wired cable uplink. Though, you'd need to change the wireless client settings anytime it moved to a new wireless network.

### Other

Some other thoughts on other physical cluster stuff I'd love to replicate on the desktop:

* Bonding and port failover. Mikrotik handles this. But we'd need boards that had multiple interfaces (UP squared might be a good candidate for this).
* VLANs and routing between them. Mikrotik already supports this. Would t least need a switch that could also handle VLANs and tagging / trunking.
* IPMI / OOB management. The onboard Arduino has the ability to power on/off the main board. I wonder if it could act as a simple IPMI device?
* An alternative to the Arduino might be using a Raspberry Pi to act as a remote power controller. The pins with some pull up resistors or transistors could control the power / reset pins.
* HDMI / USB case ports for each board. It should be possible to widen the case and make room for some HDMI and USB passthrough cables for each board. This would make it easier to service (changing BIOS options, debugging broken boot, etc.). See http://a.co/8QIUuin and http://a.co/ibqY3Ak.


#### Node Management Options

* [MAAS](https://maas.io/)
* [xCAT](https://xcat.org/)
* [Warewulf](http://warewulf.lbl.gov/trac/wiki/Documentation)
