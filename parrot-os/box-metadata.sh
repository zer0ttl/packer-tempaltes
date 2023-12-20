#!/bin/bash

metadata_file="metadata.json"
user="zer0ttl"
box_file="parrotos-5.3-libvirt.box"
box_file_path=$(realpath ${box_file})
box_file_checksum=$(sha256sum ${box_file_path} | cut -d ' ' -f 1)

cat > ${metadata_file} <<END
{
    "description": "ParrotOS 5.3\r\n",
    "short_description": "ParrotOS 5.3\r\n",
    "name": "${user}/parrotos-5.3",
    "versions": [
        {
            "version": "5.3",
            "status": "active",
            "description_html": "<h4>ParrotOS 5.3</h4>\n\n",
            "description_markdown": "#### ParrotOS 5.3\r\n\r\n",
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