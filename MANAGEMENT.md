# Managament

The `hosts` file is a Ansible inventory file that can be used for host management.

## Ping

Ping all hosts to verify they are up:

```console
$ ansible -m ping -i hosts -k -o all
SSH password:
udoo2 | SUCCESS => {"changed": false, "ping": "pong"}
udoo3 | SUCCESS => {"changed": false, "ping": "pong"}
udoo5 | SUCCESS => {"changed": false, "ping": "pong"}
udoo4 | SUCCESS => {"changed": false, "ping": "pong"}
udoo6 | SUCCESS => {"changed": false, "ping": "pong"}
udoo1 | SUCCESS => {"changed": false, "ping": "pong"}
```

## Shutdown

Shutdown all hosts so that the boards do not automatically power on with the PSU:

```console
$ ansible -m shell -a "shutdown -h now &" -i hosts -k -b -o all
SSH password:
udoo5 | SUCCESS | rc=0 | (stdout)
udoo3 | SUCCESS | rc=0 | (stdout)
udoo2 | SUCCESS | rc=0 | (stdout)
udoo1 | SUCCESS | rc=0 | (stdout)
udoo4 | SUCCESS | rc=0 | (stdout)
udoo6 | SUCCESS | rc=0 | (stdout)
```

## Boot Preseed

Enable:

```
/ip dhcp-server lease> set [ find dhcp-option ~ "udoo*" ] dhcp-option-set=boot-preseed
```

Disable:

```
/ip dhcp-server lease set [ find dhcp-option ~ "udoo*" ] dhcp-option-set=none
```

## Boot WOL

```
/ip dhcp-server lease { :foreach mac in=[find dhcp-option ~ "hostname-udoo*"] do={ :local address [get $mac mac-address ]; /tool wol interface=ether2-master $address } }
```

kubespray prepare --nodes node1\[ansible_ssh_host=192.168.88.11\] node2\[ansible_ssh_host=192.168.88.12\] node3\[ansible_ssh_host=192.168.88.13\] node4\[ansible_ssh_host=192.168.88.14\] node5\[ansible_ssh_host=192.168.88.15\] node6\[ansible_ssh_host=192.168.88.16\]
