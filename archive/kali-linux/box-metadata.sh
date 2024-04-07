#!/bin/bash

metadata_file="metadata.json"
user="zer0ttl"
box_file="kali-2023.4-libvirt.box"
box_file_path=$(realpath ${box_file})
box_file_checksum=$(sha256sum ${box_file_path} | cut -d ' ' -f 1)

cat > ${metadata_file} <<END
{
    "description": "Kali Linux 2023.4\r\n",
    "short_description": "Kali Linux 2023.4\r\n",
    "name": "${user}/kali-2023.4",
    "versions": [
        {
            "version": "2023.4",
            "status": "active",
            "description_html": "<h4>Kali Linux 2023.4</h4>\n\n",
            "description_markdown": "#### Kali Linux 2023.4\r\n\r\n",
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