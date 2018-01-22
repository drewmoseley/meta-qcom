require u-boot-dragonboard-410c.inc
DEPENDS += "skales-native"

# Generate the ABoot compatible UBoot image file.
do_compile_append_dragonboard-410c() {
    touch ${B}/fake-ramdisk.img
    ${STAGING_BINDIR_NATIVE}/skales/dtbTool -o ${B}/dt.img ${B}/arch/arm/dts/
    ${STAGING_BINDIR_NATIVE}/skales/mkbootimg \
                --kernel ${B}/u-boot-dtb.bin \
                --output ${B}/${PN}.img \
                --dt ${B}/dt.img \
                --pagesize ${QCOM_BOOTIMG_PAGE_SIZE} \
                --base ${QCOM_BOOTIMG_KERNEL_BASE} \
                --ramdisk ${B}/fake-ramdisk.img \
                --cmdline ""
}

U_BOOT_IMAGE_BASE_NAME[vardepsexclude] = "DATETIME"
U_BOOT_IMAGE_BASE_NAME ?= "${PKGE}-${PKGV}-${PKGR}-${MACHINE}-${DATETIME}"

do_deploy_append_dragonboard-410c() {
    install -D -m 0644 ${B}/${PN}.img ${DEPLOYDIR}/${PN}-${U_BOOT_IMAGE_BASE_NAME}.img
    ln -sf ${PN}-${U_BOOT_IMAGE_BASE_NAME}.img ${DEPLOYDIR}/${PN}.img
}
