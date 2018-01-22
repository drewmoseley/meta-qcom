require u-boot-dragonboard-410c.inc

do_compile () {
	oe_runmake ${UBOOT_MACHINE}
	oe_runmake envtools
}
