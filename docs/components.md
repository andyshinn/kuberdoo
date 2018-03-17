# Components

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
