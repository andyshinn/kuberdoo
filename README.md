# About

​The Kuberdoo is a not-so-cheap take on a Raspberry Pi cluster. I had originally tested building a small desktop cluster based on the Raspberry Pi but ended up with more compatibility issues than I hoped for. My search for a comparable x86 board started...

There are a couple x86 boards out there. The closest to the UDDO in price and features was the Up Board. Others, such as the Jaguarboard, were lacking in specifications or were not clear if they were even available for purchase (Kickstarter or other). I purchased one UDOO to confirm I could do some things (such as running Docker containers without tweaks and native PXE boot capabilities).

I wanted to build a case around all the components. A friend prototyped an acrylic case that could be laser cut. I immediately started playing with Onshape to take the idea to completion. After learning how to sketch and build the panels, I took the drawings to Pololu for supplying and cutting the acrylic.

# Build

Let's go through some of the main build components and how they came to be. Some of these could be swapped out for different sizes or models. I'll try and point out some of the places where I would have done differently.

### Boards

I did some research on boards. I had originally wanted to go with a Raspberry Pi design. But like most of the other ARM platforms I found in the Pi price range, I just ran into too many limitations for what I wanted to do (the biggest one being lack of proper PXE support). The ARM compatibilities around containers was also frustrating enough that I wanted to go x86_64. Though, I imagine in another year or two, we'll be able to have proper LAN boot options and more transparent multi-architecture support in technologies like Docker.

The UDOO X86 Advanced was the board I settled on. Some of the stuff I wanted to work with (such as Juju) require 4GB of RAM. The Advanced version of the board fit the bill. I imagine two ways to cut costs would be to either go with the Advanced Plus model (which has 32GB eMMC storage built-in) or go with the Basic model and use a cheaper SD card as storage and get only 2GB RAM (in my notes near the bottom I talk about SD storage and why I chose to use a M.2 SSD instead).

### Case

The case was the most fun exercise. I had never used any CAD style tooling before so there was a definite learning curve. But I had some help from a friend who had experience. I stumbled upon Onshape and it felt like a very polished tool. I am actually surprised at how much it is able to do in the browser.

The document is actually public at https://cad.onshape.com/documents/991c4a5831e2f997a4a71842/w/bb91f76a25a96fa561acf156/e/013c2a1a40829f74b89b5690. Anyone can open it up and check out the parts and assembly!

I did not have any calipers (I do now!) for measuring parts at the time. Most of my part and mounting dimensions were from ruler and/or visual only. This led to issues that popped up during assembly:

* The switch mounting holes didn't all line up. Turns out, the mounting holes on the switch PCB are not a perfect rectangle. Oops! I should be able to get the holes aligned better now that I have a pair of calipers.
* The PSU mounting is too far forward. The bottom of the PSU is resting against the front mounting nuts. Not a huge deal but I'll move the PSU back about 5mm so it clears the nuts.
* The notches in the top of the rear panel are not lined up perfectly with the notches in the top panel (off by about 1mm). I was able to use some wire cutters to try the notch in the top panel so it would fit. You can actually see this in the Onshape assembly, I just missed it during my review.
* The bottom panel bears most of the weight yet it only attaches to the sides. This could probably be designed a little better to attach at the front and back as well. Though, being able to screw the top panel into the standoffs help alleviate any pressure by the boards. Not as bad as it sounds (you can't really see it bowing) but it could be better.
* The edges of the case have some flex to them. The notches could have probably been spread out more evenly instead of right next to the bolt holes.
* The front air vents are off by 1.6mm compounding for each vent as I forgot to account for the width of the board. Oops again!

## Setup

### UDOO BIOS

* Set boot type to legacy
* Enable PXE boot to LAN
* Under Legacy submenu navigate to boot type order.
* Use the - key to move the hard drive under _Other_ (PXE boot).

### Head Node

#### Install MAAS

```
sudo apt install maas
sudo maas createadmin
```

### Network

The MikroTik hEX has a default IP address of 192.168.88.1 and offers DHCP on ports 2-5. Configure your computer to get DHCP from the ethernet port, connect it up to the hEX on port 2, and then navigate to http://192.168.88.1/. Here, we'll be able to configure a password and VPN settings.

* Disable DHCP.
* Change password.
* Add L2TP server.
* Add UDP ports 500,4500 to firewall for L2TP.
* Add DNS server 192.168.88.11.

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
