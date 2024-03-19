  network:
    network:
      version: 2
      ethernets:
        all:
          match:
            name: "*"
          dhcp4: true
          dhcp6: false