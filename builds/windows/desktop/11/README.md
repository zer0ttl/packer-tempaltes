## Update: Thu 21 Mar 2024 07:06:13 AM MDT

Windows 11 build requires vTPM.

The vTPM option in Qemu builder is not working.

https://macroform-node.medium.com/building-a-windows-11-vm-with-qemu-using-tpm-emulation-for-research-malware-analysis-part-1-8846378b9582

You could also bypass TPM during installation.

https://github.com/StefanScherer/packer-windows/blob/main/windows_11.json

Bentos boxes bypass TPM check too.

https://github.com/chef/bento/blob/main/packer_templates/win_answer_files/11/Autounattend.xml

