# #!/bin/sh -eux

echo 'vagrant' | sudo -S -v

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY