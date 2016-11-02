pkg_name=imagemagick
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_origin=core
pkg_version=6.9.2-10
pkg_license=('Apache2')
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_source=http://www.imagemagick.org/download/releases/ImageMagick-${pkg_version}.tar.xz
pkg_shasum=da2f6fba43d69f20ddb11783f13f77782b0b57783dde9cda39c9e5e733c2013c
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_deps=(
  core/zlib
  core/glibc
  core/libpng
  core/libjpeg-turbo
  core/xz
  uafgina/libtiff/4.0.3/2016101316515
)
pkg_build_deps=(
  core/file
  core/zlib
  core/pkg-config
  core/coreutils
  core/diffutils
  core/patch
  core/make
  core/gcc
  core/sed
  core/glibc
  core/libpng
  core/libjpeg-turbo
  core/xz
  uafgina/libtiff/4.0.3/20161013165156
)
pkg_dirname=ImageMagick-${pkg_version}

do_prepare() {
  do_default_prepare

  local _file=$(pkg_path_for file)/bin/file

  build_line "Updating '/usr/bin/file' to '${_file}' in configure"
  sed -i.bak 's@/usr/bin/file@'"$_file"'@' configure
}

do_build() {
  CC="gcc -std=gnu99" ./configure --disable-openmp --prefix=$pkg_prefix

  make
}
