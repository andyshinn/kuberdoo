:global password "kub3rd00"
/ip pool
set [ find name=default-dhcp ] ranges=192.168.88.50-192.168.88.254
add name=vpn ranges=192.168.89.2-192.168.89.254
/ip dhcp-server
set [ find name=defconf ] address-pool=default-dhcp authoritative=after-2sec-delay disabled=no interface=ether2-master name=kuberdoo
/ip dhcp-server option
add code=12 name=hostname-udoo1 value="'udoo1'"
add code=12 name=hostname-udoo2 value="'udoo2'"
add code=12 name=hostname-udoo3 value="'udoo3'"
add code=12 name=hostname-udoo4 value="'udoo4'"
add code=12 name=hostname-udoo5 value="'udoo5'"
add code=12 name=hostname-udoo6 value="'udoo6'"
add code=66 name=tftp-server value="'192.168.88.1'"
add code=67 name=file-netboot value="'netboot.xyz.kpxe'"
add code=67 name=file-preseed value="'preseed.kpxe'"
/ip dhcp-server option sets
add name=boot-netboot options=file-netboot,tftp-server
add name=boot-preseed options=file-preseed,tftp-server
/ip dhcp-server lease
add address=192.168.88.11 always-broadcast=yes dhcp-option=hostname-udoo1 mac-address=00:C0:08:90:58:5A server=kuberdoo
add address=192.168.88.12 always-broadcast=yes dhcp-option=hostname-udoo2 mac-address=00:C0:08:90:38:0B server=kuberdoo
add address=192.168.88.13 always-broadcast=yes dhcp-option=hostname-udoo3 mac-address=00:C0:08:90:38:C5 server=kuberdoo
add address=192.168.88.14 always-broadcast=yes dhcp-option=hostname-udoo4 mac-address=00:C0:08:90:58:6B server=kuberdoo
add address=192.168.88.15 always-broadcast=yes dhcp-option=hostname-udoo5 mac-address=00:C0:08:90:57:AF server=kuberdoo
add address=192.168.88.16 always-broadcast=yes dhcp-option=hostname-udoo6 mac-address=00:C0:08:90:58:59 server=kuberdoo
/ip dhcp-server network
set [ find address="192.168.88.0/24" ] next-server=192.168.88.1 boot-file-name=netboot.xyz.kpxe
/ppp profile
set *FFFFFFFE dns-server=192.168.89.1 local-address=192.168.89.1 remote-address=vpn
/interface l2tp-server server
set enabled=yes ipsec-secret="$password" use-ipsec=yes
/ip firewall filter
add place-before=[ find comment="defconf: drop all not coming from LAN" ] action=accept chain=input comment="kuberdoo: allow l2tp" dst-port=1701,500,4500 protocol=udp
add place-before=[ find comment="defconf: drop all not coming from LAN" ] action=accept chain=input comment="kuberdoo: allow l2tp ipsec" protocol=ipsec-esp
add place-before=[ find comment="defconf: drop all not coming from LAN" ] action=accept chain=input comment="kuberdoo: external management" dst-port=80,22 protocol=tcp
/ip firewall nat
add action=masquerade chain=srcnat comment="kuberdoo: vpn traffic" src-address=0.89.168.192-255.89.168.192
/ip tftp
add real-filename=flash/netboot.xyz.kpxe req-filename=netboot.xyz.kpxe
add real-filename=flash/preseed.cfg req-filename=preseed.cfg
add real-filename=flash/preseed.kpxe req-filename=preseed.kpxe
add real-filename=flash/preseed.ipxe req-filename=preseed.ipxe
/ppp secret
add name=vpn password="$password"
/interface l2tp-server
add name=l2tp-in1 user=""
/system identity
set name=kuberdoo
/tool
fetch https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe dst-path=flash
fetch https://github.com/andyshinn/kuberdoo/blob/master/config/preseed.cfg dst-path=flash
fetch https://github.com/andyshinn/kuberdoo/blob/master/config/preseed.ipxe dst-path=flash
fetch https://github.com/andyshinn/kuberdoo/blob/master/config/preseed.kpxe dst-path=flash
/user
set [ find name=admin ] password="$password
