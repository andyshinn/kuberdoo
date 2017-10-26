# oct/25/2017 20:09:51 by RouterOS 6.40.4
# software id = 8K0S-Z4TM
#
# model = RouterBOARD 750G r3
# serial number = XXXXXXXXXXXX
:global password "kub3rd00"
/interface l2tp-server
add name=l2tp-in1 user=""
/interface ethernet
set [ find default-name=ether2 ] arp=proxy-arp name=ether2-master
set [ find default-name=ether3 ] master-port=ether2-master
set [ find default-name=ether4 ] master-port=ether2-master
set [ find default-name=ether5 ] master-port=ether2-master
/ip neighbor discovery
set ether1 discover=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=kuberdoo
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=dhcp ranges=192.168.88.50-192.168.88.254
add name=vpn ranges=192.168.89.2-192.168.89.254
/ip dhcp-server
add address-pool=dhcp authoritative=after-2sec-delay disabled=no interface=ether2-master name=defconf
/ppp profile
set *FFFFFFFE dns-server=192.168.89.1 local-address=192.168.89.1 remote-address=vpn
/interface l2tp-server server
set enabled=yes ipsec-secret="$password" use-ipsec=yes
/interface pptp-server server
set enabled=yes
/interface sstp-server server
set default-profile=default-encryption enabled=yes
/ip address
add address=192.168.88.1/24 comment=defconf interface=ether2-master network=192.168.88.0
/ip dhcp-client
add comment=defconf dhcp-options=hostname,clientid disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.88.0/24 boot-file-name=netboot.xyz.kpxe comment=defconf gateway=192.168.88.1 next-server=192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 name=router
/ip firewall filter
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment="defconf: accept established,related" connection-state=established,related
add action=accept chain=input comment="allow l2tp" dst-port=1701,500,4500 protocol=udp
add action=accept chain=input comment="allow l2tp ipsec" protocol=ipsec-esp
add action=accept chain=input comment="allow pptp" dst-port=1723 protocol=tcp
add action=accept chain=input comment="allow sstp" dst-port=443 protocol=tcp
add action=accept chain=input comment="external management" dst-port=80,22 protocol=tcp
add action=drop chain=input comment="defconf: drop all from WAN" in-interface=ether1
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" connection-state=established,related
add action=accept chain=forward comment="defconf: accept established,related" connection-state=established,related
add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
add action=drop chain=forward comment="defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat connection-state=new in-interface=ether1
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" out-interface=ether1
add action=masquerade chain=srcnat comment="masq. vpn traffic" src-address=0.89.168.192-255.89.168.192
/ip tftp
add disabled=yes ip-addresses=192.168.88.0/24 real-filename=netboot.xyz.kpxe req-filename=netboot.xyz.kpxe
/ppp secret
add name=vpn password="$password"
/system clock
set time-zone-name=America/Chicago
/system identity
set name=kuberdoo
/tool
fetch https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe
