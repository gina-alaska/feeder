pkg_name="feeder"
pkg_version="1.4.1"
pkg_shasum="29356528a22cb0eba3a1fd4b7d8a680f1919d35eed42995c9e2af6327d19e499"
pkg_origin="uafgina"
pkg_maintainer="UAF GINA <support+habitat@gina.alaska.edu>"
pkg_license=('MIT')
pkg_source="https://github.com/gina-alaska/${pkg_name}/archive/${pkg_version}.tar.gz"
pkg_svc_user="feeder"
pkg_svc_group=$pkg_svc_user
pkg_deps=(
  core/bundler
  core/cacerts
  core/glibc
  core/libffi
  core/libyaml
  core/libxml2
  core/libxslt
  core/openssl
  core/postgresql
  core/redis
  bixu/memcached
  core/ruby
  core/zlib
  uafgina/imagemagick/6.9.2-10/20161013170256
)
pkg_build_deps=(
  core/coreutils
  core/gcc
  core/gcc-libs
  core/make
  core/git
  core/postgresql
  core/which
  core/pkg-config
  core/node
  uafgina/imagemagick/6.9.2-10/20161013170256
)

pkg_bin_dirs=(dist/bin)
pkg_expose=(9292)

do_prepare() {
  build_line "Setting link for /usr/bin/env to 'coreutils'"
  [[ ! -f /usr/bin/env ]] && ln -s $(pkg_path_for coreutils)/bin/env /usr/bin/env

  build_line "Setting link for /usr/bin/which to 'which'"
  [[ ! -f /usr/bin/which ]] && ln -s $(pkg_path_for which)/bin/which /usr/bin/which

  build_line "Setting link for /usr/bin/pkg-config to 'pkg-config'"
  [[ ! -f /usr/bin/which ]] && ln -s $(pkg_path_for pkg-config)/bin/pkg-config /usr/bin/pkg-config

  return 0
}

do_build() {
  export CPPFLAGS="${CPPFLAGS} ${CFLAGS}"

  local _bundler_dir=$(pkg_path_for core/bundler)
  local _libxml2_dir=$(pkg_path_for core/libxml2)
  local _libxslt_dir=$(pkg_path_for core/libxslt)
  local _postgresql_dir=$(pkg_path_for core/postgresql)
  local _imagemagick_dir=$(pkg_path_for uafgina/imagemagick)
  local _pg_config=${_postgresql_dir}/bin/pg_config
  local _magickconfig=${_imagemagick_dir}/bin/Magick-config
  local _zlib_dir=$(pkg_path_for zlib)

  export GEM_HOME=${pkg_path}/vendor/bundler
  export GEM_PATH=${_bundler_dir}:${GEM_HOME}
  export PKG_CONFIG_PATH=$(pkg_path_for imagemagick)/lib/pkgconfig
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$_imagemagick_dir/lib
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pkg_path_for gcc-libs)/lib

  # don't let bundler split up the nokogiri config string (it breaks
  # the build), so specify it as an env var instead
  # -- Thanks JTimberman for writing this!
  export NOKOGIRI_CONFIG="--use-system-libraries --with-zlib-dir=${_zlib_dir} --with-xslt-dir=${_libxslt_dir} --with-xml2-include=${_libxml2_dir}/include/libxml2 --with-xml2-lib=${_libxml2_dir}/lib"
  bundle config build.nokogiri '${NOKOGIRI_CONFIG}'
  build_line "Setting pg_config=${_pg_config}"
  bundle config build.pg --with-pg-config=$_pg_config

  if [[ -z "`grep 'gem .*tzinfo-data.*' Gemfile`" ]]; then
    echo 'gem "tzinfo-data"' >> Gemfile
  fi

  if [[ -z "`grep 'gem .*rb-readline.*' Gemfile`" ]]; then
    echo 'gem "rb-readline"' >> Gemfile
  fi

  build_line "Vendoring Gems"
  bundle install --jobs 2 --retry 5 --path vendor/bundle --without development test

  build_line "Precompiling Assets"
  bin/rake assets:precompile

  build_line "Removing dragonfly/uploads"
  rm -rf public/uploads
  rm -rf public/dragonfly
}

do_install() {
  cp -R . ${pkg_prefix}/dist

  for binstub in ${pkg_prefix}/dist/bin/*; do
    build_line "Setting shebang for ${binstub} to 'ruby'"
    [[ -f $binstub  ]] && sed -e "s#/usr/bin/env ruby#$(pkg_path_for ruby)/bin/ruby#" -i $binstub
  done

  if [[ `readlink /usr/bin/env` = "$(pkg_path_for coreutils)/bin/env" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/env'"
    rm /usr/bin/env
  fi

  if [[ `readlink /usr/bin/which` = "$(pkg_path_for coreutils)/bin/which" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/which'"
    rm /usr/bin/which
  fi

  if [[ `readlink /usr/bin/pkg-config` = "$(pkg_path_for pkg-config)/bin/pkg-config" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/pkg-config'"
    rm /usr/bin/pkg-config
  fi
 }