#!/bin/bash

if [[ "${#}" -lt 1 ]]; then
    echo "Usage: ${0} packer.box"
    echo "Please provide the name of the box file."
    exit 1
fi

box_file="${1}"
name=$(echo ${box_file} | awk -F '_' '{print $2}') # packer_windows-desktop-10-22H2-ent_libvirt_amd64.box
os_family=$(echo ${name} | awk -F '-' '{print $1}') # windows
os_experience=$(echo ${name} | awk -F '-' '{print $2}') # desktop
os_name=$(echo ${name} | awk -F '-' '{print $3}') # 10
os_version=$(echo ${name} | awk -F '-' '{print $4}') # 22h2
os_edition=$(echo ${name} | awk -F '-' '{print $5}') # enterprise
name="${os_family}-${os_name}-${os_edition}"
metadata_file="metadata-${name}.json"
user="zer0ttl"
box_file_path=$(realpath ${box_file})
box_file_checksum=$(sha256sum ${box_file_path} | cut -d ' ' -f 1)

cat > ${metadata_file} <<END
{
    "description": "${os_family^} ${os_name^} ${os_version} ${os_edition^}\r\n",
    "short_description": "${os_family^} ${os_name^} ${os_version} ${os_edition^}\r\n",
    "name": "${user}/${name}",
    "versions": [
        {
            "version": "19045.2006",
            "status": "active",
            "description_html": "<h4>${os_family^} ${os_name^} ${os_version} ${os_edition^}</h4>\n\n",
            "description_markdown": "#### ${os_family^} ${os_name^} ${os_version} ${os_edition^}\r\n\r\n",
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