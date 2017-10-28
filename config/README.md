# Config Files

## embed.ipxe

The `embed.ipxe` file is used to build the iPXE `undionly.kpxe` binary with the `embed.ipxe` embedded inside. This PXE booter will chainload to `tftp://192.168.88.1/preseed.ipxe`. This makes it easier for us to make edits to the iPXE script without having to rebuild the iPXE binary. See http://ipxe.org/embed for information on building the binary with the embedded script.

## preseed.cfg

This is the main Ubuntu preseed file. It automates the installation of Ubuntu for us so we don't need a keyboard or monitor. This gets passed to the `url` parameter as a kernel command line option at boot. See the `preseed.ipxe` script for the command line that gets passed.

## preseed.ipxe

This is the chainloaded iPXE script. We use this to pull down a remote Ubuntu installer image and boot using our `preseed.cfg` file. The installation procdes automatically and shuts down the node when done (so we can disable the TFTP options before we next power on).

## preseed.kpxe

This is the `undionly.kpxe` file with our embedded `embed.ipxe` script. It was generated using instructions at http://ipxe.org/embed and then renamed from `undionly.kpxe` to `preseed.kpxe`.

## ros_default.rsc

This is the default configuration of the MikroTik hEX before any of our edits. It is just here for reference.

## ros_kuberdoo.rsc

This is the MikroTik hEX configuration with our edits. It can be applied on top of the default MikroTik configuration. You will likely want to change the DHCP lease MAC addresses of the boards and the global password at top (which is used for VPN and admin functions).
