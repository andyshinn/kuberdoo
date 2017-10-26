# About

​The Kuberdoo is a not-so-cheap take on a Raspberry Pi cluster. I had originally tested building a small desktop cluster based on the Raspberry Pi but ended up with more compatibility issues than I hoped for. My search for a comparable x86 board started...

There are a couple x86 boards out there. The closest to the UDDO in price and features was the Up Board. Others, such as the Jaguarboard, were lacking in specifications or were not clear if they were even available for purchase (Kickstarter or other). I purchased one UDOO to confirm I could do some things (such as running Docker containers without tweaks and native PXE boot capabilities).

I wanted to build a case around all the components. A friend prototyped an acrylic case that could be laser cut. I immediately started playing with Onshape to take the idea to completion. After learning how to sketch and build the panels, I took the drawings to Pololu for supplying and cutting the acrylic.

## Components

Let's go through some of the main build components and how they came to be. Some of these could be swapped out for different sizes or models. I'll try and point out some of the places where I would have done differently.

### Boards

The main board is the UDOO X86 Advanced.

I did some research on boards. I had originally wanted to go with a Raspberry Pi design. But like most of the other ARM platforms I found in the Pi price range, I just ran into too many limitations for what I wanted to do (the biggest one being lack of proper PXE support). The ARM compatibilities around containers was also frustrating enough that I wanted to go x86_64. Though, I imagine in another year or two, we'll be able to have proper LAN boot options and more transparent multi-architecture support in technologies like Docker.

The UDOO X86 Advanced was the board I settled on. Some of the stuff I wanted to work with (such as Juju) require 4GB of RAM. The Advanced version of the board fit the bill. I imagine two ways to cut costs would be to either go with the Advanced Plus model (which has 32GB eMMC storage built-in) or go with the Basic model and use a cheaper SD card as storage and get only 2GB RAM (in my notes near the bottom I talk about SD storage and why I chose to use a M.2 SSD instead).

### Case

The case is built from laser cut 3mm thick acrylic panels. The CAD is actually public at https://cad.onshape.com/documents/991c4a5831e2f997a4a71842/w/bb91f76a25a96fa561acf156/e/013c2a1a40829f74b89b5690. Anyone can open it up and check out the parts and assembly!

The case was the most fun exercise. I had never used any CAD style tooling before so there was a definite learning curve. But I had some help from a friend who had experience. I stumbled upon Onshape and it felt like a very polished tool. I am actually surprised at how much it is able to do in the browser.

I did not have any calipers (I do now!) for measuring parts at the time. Most of my part and mounting dimensions were from ruler and/or visual only. This led to issues that popped up during assembly:

* The switch mounting holes didn't all line up. Turns out, the mounting holes on the switch PCB are not a perfect rectangle. Oops! I should be able to get the holes aligned better now that I have a pair of calipers.
* The PSU mounting is too far forward. The bottom of the PSU is resting against the front mounting nuts. Not a huge deal but I'll move the PSU back about 5mm so it clears the nuts.
* The notches in the top of the rear panel are not lined up perfectly with the notches in the top panel (off by about 1mm). I was able to use some wire cutters to try the notch in the top panel so it would fit. You can actually see this in the Onshape assembly, I just missed it during my review.
* The bottom panel bears most of the weight yet it only attaches to the sides. This could probably be designed a little better to attach at the front and back as well. Though, being able to screw the top panel into the standoffs help alleviate any pressure by the boards. Not as bad as it sounds (you can't really see it bowing) but it could be better.
* The edges of the case have some flex to them. The notches could have probably been spread out more evenly instead of right next to the bolt holes.
* The front air vents are off by 1.6mm compounding for each vent as I forgot to account for the thickness of the board. Oops again!

The case I built was version `V3`. I went through and tweaked a bunch of constraints for the some of the issues above. If I ever build another case (or if you do, please let me know) I will make a version `V4`.

### Power Supply

The power supply unit (PSU) is a Mean Well RS-100-12. I would later learn that this is an older model and has been replaced by the LRS-100-12. The LRS-100-12 is smaller, has a better efficiency rating (should run cooler), and slightly cheaper. For new builds I'd recommend just using the LRS-100-12.

I looked at dual voltage power supplies (since I was initially thinking I would run a 5v switch and that the fan would be 5v as well). But it turned out to be much bulkier to get the wattage needed at 12 and 5 volts. I also finally found a 12v based switch and realized that most computer fans are actually 12v.

### Networking

The networking components consist of a Netgear GS108 switch, MikroTik hEX router, and some Monoprice SlimRun ethernet cables. The hEX has mechanical drawings available but I couldn't find any for the GS108. Fortunately, it had mounting holes on the board and I was (mostly) able to figure out the correct hole to hole dimensions.

The GS108 was the only switch ii found that was powered by 12 volts (most others were 5 or 9). The hEX has a very wide range input voltage so no worries there. But both the GS108 and hEX are a bit pricey for what they are doing. I think the hEX could be swapped out for the hEX lite and the GS108 for another 12v switch if I searched longer. I am also not fond of the GS108 DC power jack on the back. Had it been on the same side of the ethernet ports I would have been able to move the switch forward a bit more to create some cable space.

The hEX acts not only as a NAT gateway for the internal network but also as a VPN server. To get into the network I create a L2TP VPN connection in my macOS network settings. Once connected, I get access as if I was directly connected to the switch.

I go into the router and VPN configuration specifics later in the installation instructions.

### Fan, Ethernert, C14

The fan is a Antec TwoCool 140mm. The ethernet jack and C13 receptacle were just whatever I found available on Amazon. I'm sure any comparable parts would work as long as the dimensions were tweaked to fit them.

I got the fan in a dual speed model because I wasn't sure how much airflow I needed. So far, the low speed on the fan works well and seems to be keeping everything cool. I haven't measured temperatures yet. But just touching the PSU and heatsinks on the boards feels much cooler than being in the open air.

### Other

There are some other various parts that I already had on hand but I'll try to list them out in case they are needed:

* M3 x 5mm nylon standoffs (brass or metal would be fine as well).
* M3 washers (for spacing the boards off the base panel)
* 18 AWG wire (for building the wiring harness from the PSU to the DC pigtails)
* Various tools (philips screw driver, wire cutters, wire tap crimpers)
* Soldering iron and solder
* Spade terminals for 18 AWG wire (for easy connecting to C14 receptacle. though, you could also just solder the wires on).
* Eye hole terminals for 18 AWG wire to PSU outputs and inputs (though, you could probably just screw the bare wires in if you wanted).
* Shrink tubing in various sizes.
* Double sided foam tape.

## Instructions

Now that you have all the parts, let's get building!

### Router Configuration

Before we install the router we need to do some pre-configuration so we can connect to it.

1. Connect up your computer to the second ethernet port and make sure it is configured for DHCP.
1. Power up the hEX with the included power adapter.
1. SSH or telnet to 192.168.88.1.
1. Copy and paste the configuration from https://github.com/andyshinn/kuberdoo/blob/master/config/default_vpn.rsc (this should get the NAT, firewall, VPN, and basics set up).

After loading the configuration, connect port 1 up to your home network, power cycle the hEX, and verify that you can connect to it (you will need to consult your home router to find out what address the MikroTik was given). For example, my home network is 10.0.1.0/24 and the MikroTik got an address of 10.0.1.58. I am able to connect to the device via SSH at 10.0.1.58 with user `admin` and password `kub3rd00`. There is also a web interface at http://10.0.1.58/ if you prefer to configure the device that way.

Now that we have verified the device can be remotely connected to, it is ready to be installed into the case. You can leave the router powered up because we'll use the TFTP server configured on it to bootstrap the first UDOO board next.

### UDOO Preparation

In addition to the router, we need to prep the UDOO boards so that they properly boot from PXE and failover to hard drive when no PXE server is available. We also need to install Ubuntu on one of the boards so that we have a node to bootstrap from.

1. Install the M.2 SSDs onto all the boards. The UDOO X86 should have come with a small bag of M.2 mounting hardware.
1. Use a small piece of double sided foam tape to hold down the CMOS battery.
1. Connect up a UDOO to monitor via HDMI or mini DisplayPort, keyboard, and a 12 volt DC power adapter. You can use the one that comes with the Netgear GS108 switch. But don't use the adapter that comes with the MikroTik hEX as it is 24 volts!
1. Start repeatedly pressing the <kbd>ESC</kbd> key on the keyboard while applying power to the UDOO board.
1. Enter the SCU once at the setup screen.
1. Navigate to _Power_ and set the _Power Fail Resume Type_ to _Always OFF_ (we don't want to boards automatically powering on).
1. Navigate to _Boot_ menu.
1. Set _Boot Type_ to _Legacy_ (UEFI doesn't failover to hard disk properly when PXE fails).
1. Enable _PXE boot to LAN_.
1. Navigate to _Exit_ and choose _Exit Saving Changes_.
1. Keep pressing the ESC key as the device reboots again.
1. Navigate to the _Boot_ menu again and there should be a new _Legacy_ menu.
1. Under _Legacy_ submenu navigate to _Boot Type Order_.
1. Highlight _Hard Disk Drive_ and use the <kbd>-</kbd> key to move it under _Other_ (so that PXE will boot before the SSD).
1. Navigate to _Exit_ and choose _Exit Saving Changes_.

Repeat these steps for all the boards. It is difficult to hook up HDMI and keyboard to the boards while they are in the case so this is why we do it now. We want the boards to boot and install headless.

Choose one of the boards to be the head node. This is the board we'll use to install Ubuntu onto and will run Ubuntu MAAS or other PXE server to bootstrap the other boards. With this board:

1. Connect the board up to your monitor and keyboard again.
1. Connect this board to one of the ethernet ports on the MikroTik hEX.
1. Power on the board and it should PXE boot into https://netboot.xyz/ from the TFTP server we previously set up on the hEX.
1. Navigate the menus to install Ubuntu 16.04 or other flavor of Linux (if you plan to use something other than MAAS).
1. Follow through the installation and verify you can SSH to the node afterwards.

Once we can remotely connect to this node it is safe to go in the case. We know that we can connect to it without needing monitor and keyboard. It may be helpful to number the boards at this point. I put a number 1 on my head node CMOS battery and labeled the others boards 2 through 6.

### Wiring Harness

I started by mocking up the boards on the bottom panel and the PSU on the side panel. This helped give an idea of how long the DC plug pigtails needed to be for the wiring harness. I ended up making two, one harness for the 6 boards and one for the fan, switch, and router. The harnesses are the pigtails soldered to 18 AWG wire leads that plug into the positive and negative terminals on the PSU.

### Mounting Switch

### Mounting Router

### Head Node MAAS

```
sudo apt install maas
sudo maas createadmin
```


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
* HDMI / USB case ports for each board. It should be possible to widen the case and make room for some HDMI and USB passthrough cables for each board. This would make it easier to service (changing BIOS options, debugging broken boot, etc.)
