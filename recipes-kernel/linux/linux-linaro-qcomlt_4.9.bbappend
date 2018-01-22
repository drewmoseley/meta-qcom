DEPENDS += "u-boot-mkimage-native"

#
# Generate the uImage file per instructions from:
#   https://github.com/96boards/documentation/blob/master/ConsumerEdition/DragonBoard-410c/Guides/uboot-linux-sd.md
#
# It doesn't appear that the upstream Linux sources have uImage support
# for arm64 so we have to manually do it here.
#
UIMAGE_BASE_ADDRESS ?= "0x80080000"
do_compile_append_dragonboard-410c() {
    ${STAGING_BINDIR_NATIVE}/mkimage -A arm64 -O linux -C none \
             -T kernel -a ${UIMAGE_BASE_ADDRESS} -e ${UIMAGE_BASE_ADDRESS} \
             -n Dragonboard -d ${B}/arch/arm64/boot/Image ${B}/uImage
}

FILES_kernel-image += "/${KERNEL_IMAGEDEST}/uImage /${KERNEL_IMAGEDEST}/uImage-${KERNEL_VERSION}"

do_install_append_dragonboard-410c() {
    install -d ${D}/${KERNEL_IMAGEDEST}/
    install -D -m 0644 ${B}/uImage ${D}/${KERNEL_IMAGEDEST}/uImage
    ln -sf ${KERNEL_IMAGEDEST}/uImage ${D}/${KERNEL_IMAGEDEST}/uImage-${KERNEL_VERSION}
}

do_deploy_append_dragonboard-410c() {
    install -d ${DEPLOYDIR}/
    install -D -m 0644 ${B}/uImage ${DEPLOYDIR}/uImage-${KERNEL_IMAGE_BASE_NAME}.img
    ln -sf uImage-${KERNEL_IMAGE_BASE_NAME}.img ${DEPLOYDIR}/uImage
}
