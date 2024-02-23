#!/bin/bash

metadata_file="metadata.json"
user="zer0ttl"
box_file="parrotos-6.0-libvirt.box"
box_file_path=$(realpath ${box_file})
box_file_checksum=$(sha256sum ${box_file_path} | cut -d ' ' -f 1)

cat > ${metadata_file} <<END
{
    "description": "ParrotOS 6.0\r\n",
    "short_description": "ParrotOS 6.0\r\n",
    "name": "${user}/parrotos-6.0",
    "versions": [
        {
            "version": "6.0",
            "status": "active",
            "description_html": "<h4>ParrotOS 6.0</h4>\n\n",
            "description_markdown": "#### ParrotOS 6.0\r\n\r\n",
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