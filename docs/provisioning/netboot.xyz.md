Choose one of the boards to be the head node. This is the board we'll use to install Ubuntu onto and will run Ubuntu MAAS or other PXE server to bootstrap the other boards. With this board:

1. Connect the board up to your monitor and keyboard again.
1. Connect this board to one of the ethernet ports on the MikroTik hEX.
1. Power on the board and it should PXE boot into https://netboot.xyz/ from the TFTP server we previously set up on the hEX.
1. Navigate the menus to install Ubuntu 16.04 or other flavor of Linux (if you plan to use something other than MAAS).
1. Follow through the installation and verify you can SSH to the node afterwards.
