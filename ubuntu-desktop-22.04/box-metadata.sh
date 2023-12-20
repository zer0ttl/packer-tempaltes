#!/bin/bash

metadata_file="metadata.json"
user="zer0ttl"
box_file="ubuntu-desktop-22.04-libvirt.box"
box_file_path=$(realpath ${box_file})
box_file_checksum=$(sha256sum ${box_file_path})

cat > ${metadata_file} <<END
{
    "description": "Ubuntu Desktop 22.04.3\r\n",
    "short_description": "Ubuntu Desktop 22.04.3\r\n",
    "name": "${user}/ubuntu-desktop-22.04",
    "versions": [
        {
            "version": "22.04.3",
            "status": "active",
            "description_html": "<h4>Ubuntu Desktop 22.04.3</h4>\n\n",
            "description_markdown": "#### Ubuntu Desktop 22.04.3\r\n\r\n",
            "providers": [
                {
                    "name": "libvirt",
                    "checksum": "${box_file_checksum}",
                    "checksum_type": "sha256",
                    "url": "file://${box_file_path}"
                }
            ]
        }
    ]
}
END

cat <<END
Add the vagrant box with:

vagrant box add "${metadata_file}"
END