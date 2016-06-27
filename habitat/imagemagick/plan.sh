pkg_name=imagemagick
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_origin=core
pkg_version=6.9.2-10
pkg_license=('Apache2')
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_source=http://www.imagemagick.org/download/releases/ImageMagick-${pkg_version}.tar.xz
pkg_shasum=da2f6fba43d69f20ddb11783f13f77782b0b57783dde9cda39c9e5e733c2013c
pkg_bin_dirs=(bin)
pkg_deps=(core/zlib core/glibc core/libpng ssd/libjpeg uafgina/libtiff)
pkg_build_deps=(core/file core/zlib core/pkg-config core/coreutils core/diffutils core/patch core/make core/gcc core/sed core/glibc core/libpng ssd/libjpeg uafgina/libtiff)
pkg_dirname=ImageMagick-${pkg_version}

do_prepare() {
  do_default_prepare

  local _file=$(pkg_path_for file)/bin/file

  build_line "Updating '/usr/bin/file' to '${_file}' in configure"
  sed -i.bak 's@/usr/bin/file@'"$_file"'@' configure
}

do_build() {
  local _zlib=$(pkg_path_for zlib)/lib/pkgconfig
  local _libpng=$(pkg_path_for libpng)/lib/pkgconfig
  local _libtiff=$(pkg_path_for libtiff)/lib/pkgconfig

  export PKG_CONFIG=$(pkg_path_for pkg-config)/bin/pkg-config
  export PKG_CONFIG_PATH=$"${_zlib}:${_libpng}:${_libtiff}"

  CC="gcc -std=gnu99" ./configure --disable-openmp --prefix=$pkg_prefix

  make
}
