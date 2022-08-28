# Author: Dan Moulding <dmoulding@me.com>
EAPI=7

inherit multilib rpm

model=hll3230cdw

DESCRIPTION="CUPS Printer Driver for Brother HL-L3230CDW Color LED Printers"
HOMEPAGE=https://support.brother.com
SRC_URI=https://download.brother.com/welcome/dlf103944/${model}pdrv-${PV}-0.i386.rpm

LICENSE=Brother
SLOT=0
KEYWORDS=amd64
IUSE=

DEPEND=net-print/cups
RDEPEND=${DEPEND}
BDEPEND=
RESTRICT=mirror

S=${WORKDIR}

driver_dir=opt/brother/Printers/${model}
filter=brother_lpdwrapper_${model}
filter_dir=usr/libexec/cups/filter
model_dir=usr/share/cups/model/Brother
ppd=brother_${model}_printer_en.ppd
wrap_dir=${driver_dir}/cupswrapper

prestripped+=(usr/bin/brprintconf_"${model}")
prestripped+=("${driver_dir}"/lpd/br"${model}"filter)

QA_PRESTRIPPED=${prestripped[*]}

src_install()
{
	has_multilib_profile && ABI=x86

	dobin usr/bin/brprintconf_"${model}"

	# Copy driver files to /opt
	cp -r opt "${D}" || die

	# Create symlink to PPD file
	mkdir -p "${D}"/"${model_dir}" || die
	ln -s "${D}"/"${wrap_dir}"/"${ppd}" "${D}"/"${model_dir}" || die
	chmod 644 "${D}"/"${model_dir}"/"${ppd}" || die

	# Create symlink to filter file
	mkdir -p "${D}"/"${filter_dir}" || die
	ln -s "${D}"/"${wrap_dir}"/"${filter}" "${D}"/"${filter_dir}" || die
	chmod 755 "${D}"/"${filter_dir}"/"${filter}" || die
}
