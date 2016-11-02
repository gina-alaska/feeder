pkg_name=libtiff
pkg_maintainer="UAF GINA <support+habitat@gina.alaska.edu>"
pkg_origin=uafgina
pkg_version=4.0.3
pkg_license=('MIT')
pkg_source=ftp://download.osgeo.org/libtiff/tiff-${pkg_version}.tar.gz
pkg_shasum=ea1aebe282319537fb2d4d7805f478dd4e0e05c33d0928baba76a7c963684872
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_deps=(core/glibc core/zlib)
pkg_build_deps=(core/coreutils core/make core/gcc core/glibc core/zlib)
pkg_dirname=tiff-${pkg_version}

