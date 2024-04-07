#!/bin/bash

if [[ "${#}" -lt 2 ]]; then
    echo "Usage: ${0} <BOX_FILE_NAME> <BOX_VERSION>"
    echo "Example: ${0} ubuntu-destop-22.04-libvirt.box.box 22.04.4"
    echo "Example: ${0} windows-server-2019-std-libvirt.box.box 230568"
    echo "Please provide the name of the box file."
    exit 1
fi

box_file="${1}"
version="${2}"
name=$(echo ${box_file} | awk -F '-libvirt.box' '{print $1}')
# version=$(echo ${name} | awk -F '-' '{print $NF}')

metadata_file="metadata.json"
user="zer0ttl"
# box_file="ubuntu-desktop-22.04-libvirt.box"
box_file_path=$(realpath ${box_file})
box_file_checksum=$(sha256sum ${box_file_path} | cut -d ' ' -f 1)

cat > ${metadata_file} <<END
{
    "description": "Ubuntu Desktop ${version}\r\n",
    "short_description": "Ubuntu Desktop ${version}\r\n",
    "name": "${user}/${name}",
    "versions": [
        {
            "version": "${version}",
            "status": "active",
            "description_html": "<h4>Ubuntu Desktop ${version}</h4>\n\n",
            "description_markdown": "#### Ubuntu Desktop ${version}\r\n\r\n",
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