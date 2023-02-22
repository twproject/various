
# Run ZeroTier on UDM Pro 2.4.x release

How to run Zerotier client on a Ubiquity UDM Pro with latest firmware


## Commands

Login as root and

```shell
echo "deb https://apt.unifiblueberry.io/ stretch main" > /etc/apt/sources.list.d/unifi-blueberry.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C320FD3D3BF10DA7415B29F700CCEE392D0CA761 
apt update 
apt install unifi-blueberry-addon-podman 
podman run -d --name zerotier-one --device=/dev/net/tun --net=host --cap-add=NET_ADMIN --cap-add=SYS_ADMIN --cap-add=CAP_SYS_RAWIO -v /data/zerotier-one:/var/lib/zerotier-one bltavares/zerotier
podman exec zerotier-one zerotier-cli join <zerotier_network_ID>
```

