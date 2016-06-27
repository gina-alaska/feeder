pkg_name=libjpeg
pkg_maintainer="UAF GINA <support+habitat@gina.alaska.edu>"
pkg_origin=uafgina
pkg_version=9b
pkg_license=('MIT')
pkg_source=http://www.ijg.org/files/jpegsrc.v${pkg_version}.tar.gz
pkg_shasum=240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052
pkg_bin_dirs=(bin)
pkg_deps=(core/glibc)
pkg_build_deps=(core/coreutils core/make core/gcc core/glibc)
pkg_dirname=jpeg-${pkg_version}

do_build() {
  ./configure --prefix=$pkg_prefix --enable-shared --enable-static
  make
  make install
}
