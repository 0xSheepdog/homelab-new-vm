#!/bin/bash

if [[ "$1" ]]; then

  pushd /var/lib/libvirt/images

  echo "Copying rhel-9.3-baseline.qcow2 to ${1}-disk0.qcow2"
  qemu-img create -f qcow2 -b rhel-9.3-baseline.qcow2 -F qcow2 ${1}-disk0.qcow2

  echo "Setting hostname to ${1}"
  virt-customize -a ${1}-disk0.qcow2 --hostname ${1}

  echo "Fixing disk ownership"
  chown qemu:qemu ./${1}-disk0.qcow2

  echo "Performing virt-install"
  virt-install \
    --name ${1} \
    --memory 4096 \
    --vcpus 2 \
    --os-variant rhel9.3 \
    --import \
    --clock offset=localtime \
    --disk ${1}-disk0.qcow2 \
    --cloud-init user-data=user-data

else
	echo "Please provide a hostname for the target system 'create-linked-clone.sh my-hostname'"
fi

