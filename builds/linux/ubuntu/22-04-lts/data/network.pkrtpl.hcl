  network:
    network:
      version: 2
      ethernets:
        all-en:
          match:
            name: "en*"
          dhcp4: true
        all-eth:
          match:
            name: "eth*"
          dhcp4: true
