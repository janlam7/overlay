# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P="${P}"

inherit base eutils user git-r3
AUTOTOOLS_AUTORECONF="1"
EGIT_REPO_URI="https://github.com/icecc/icecream.git"
EGIT_COMMIT="e3d10a32bc6c046d8f3d1182e75c659d4b28ed49"

DESCRIPTION="Distributed compiling of C(++) code across several machines; based on distcc"
HOMEPAGE="https://github.com/icecc/icecream"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="
	sys-libs/libcap-ng
	app-text/docbook2X
	dev-libs/lzo
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
)

pkg_setup() {
	enewgroup icecream
	enewuser icecream -1 -1 /var/cache/icecream icecream
}

src_prepare() {
        ./autogen.sh || die
}

src_configure() {
	econf \
		--enable-shared --disable-static \
		--enable-clang-wrappers \
		--enable-clang-rewrite-includes
}

src_install() {
	default
	prune_libtool_files --all

	newconfd suse/sysconfig.icecream icecream
	newinitd "${FILESDIR}"/icecream-r2 icecream

	insinto /etc/logrotate.d
	newins suse/logrotate icecream
}
