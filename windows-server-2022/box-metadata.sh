#!/bin/bash

if [[ "${#}" -lt 1 ]]; then
    echo "Usage: ${0} packer.box"
    echo "Please provide the name of the box file."
    exit 1
fi

box_file="${1}"
name=$(echo ${box_file} | awk -F '-libvirt.box' '{print $1}')
version=$(echo ${name} | awk -F '-' '{print $NF}')
metadata_file="metadata-${name}.json"
user="zer0ttl"
box_file_path=$(realpath ${box_file})
box_file_checksum=$(sha256sum ${box_file_path} | cut -d ' ' -f 1)

cat > ${metadata_file} <<END
{
    "description": "Windows Server 2022 ${version}\r\n",
    "short_description": "Windows Server 2022 ${version}\r\n",
    "name": "${user}/${name}",
    "versions": [
        {
            "version": "2102.0.2308",
            "status": "active",
            "description_html": "<h4>Windows Server 2022 ${version}</h4>\n\n",
            "description_markdown": "#### Windows Server 2022 ${version}\r\n\r\n",
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