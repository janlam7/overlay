# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P}"

inherit eutils user git-r3
AUTOTOOLS_AUTORECONF="1"
EGIT_REPO_URI="https://github.com/icecc/icecream.git"
EGIT_COMMIT="aa9e2fc68ee045f7fb55dab853f1cf58a80d2952"

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
	app-arch/zstd
	app-arch/libarchive
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
        default
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
        find "${D}" -name '*.la' -delete || die

	newconfd suse/sysconfig.icecream icecream
	newinitd "${FILESDIR}"/icecream-r2 icecream

	insinto /etc/logrotate.d
	newins suse/logrotate icecream
}
