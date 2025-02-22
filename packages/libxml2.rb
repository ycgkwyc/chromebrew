require 'package'

class Libxml2 < Package
  description 'Libxml2 is the XML C parser and toolkit developed for the Gnome project.'
  homepage 'http://xmlsoft.org/'
  version '2.10.2'
  license 'MIT'
  compatibility 'all'
  source_url 'https://gitlab.gnome.org/GNOME/libxml2/-/archive/v2.10.2/libxml2-v2.10.2.tar.bz2'
  source_sha256 'd50e8a55b2797501929d3411b81d5d37ec44e9a4aa58eae9052572977c632d7a'

  binary_url({
    aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/libxml2/2.10.2_armv7l/libxml2-2.10.2-chromeos-armv7l.tar.zst',
     armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/libxml2/2.10.2_armv7l/libxml2-2.10.2-chromeos-armv7l.tar.zst',
       i686: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/libxml2/2.10.2_i686/libxml2-2.10.2-chromeos-i686.tar.zst',
     x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/libxml2/2.10.2_x86_64/libxml2-2.10.2-chromeos-x86_64.tar.zst'
  })
  binary_sha256({
    aarch64: 'd71f1920d9c2db027f1dabf735038ef8bbcfca33d714773ae6d1049879ac9889',
     armv7l: 'd71f1920d9c2db027f1dabf735038ef8bbcfca33d714773ae6d1049879ac9889',
       i686: 'e1c1c121adb611590f66062919e5a15cfdd62a9da89b37105af5789660db416a',
     x86_64: '0d463712429ba8c0d01f58ac772db9e5e1e88d47ae57f88c7e9a06e87dc8788b'
  })

  depends_on 'gcc'
  depends_on 'icu4c'
  depends_on 'ncurses'
  depends_on 'readline'
  depends_on 'zlibpkg'
  no_patchelf

  def self.patch
    # Fix encoding.c:1961:31: error: ‘TRUE’ undeclared (first use in this function)
    system "for f in \$(grep -rl \'TRUE)\'); do sed -i 's,TRUE),true),g' \$f; done"
  end

  def self.build
    # libxml2-python built in another package (py3_libxml2)
    system "./autogen.sh \
      #{CREW_OPTIONS} \
      #{CREW_ENV_OPTIONS} \
      --enable-shared \
      --enable-static \
      --with-pic \
      --without-python \
      --without-lzma \
      --with-zlib \
      --with-icu \
      --with-threads \
      --with-history"
    system 'make'
  end

  def self.check
    # Remove EBCDIC test since it fails.
    # Check https://mail.gnome.org/archives/xml/2010-April/msg00010.html for details.
    system 'rm', 'test/ebcdic_566012.xml'

    system 'make', 'check'
  end

  def self.install
    system 'make', "DESTDIR=#{CREW_DEST_DIR}", 'install'
  end
end
