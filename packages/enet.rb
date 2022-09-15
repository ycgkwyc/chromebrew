require 'package'

class Enet < Package
  description 'ENet reliable UDP networking library'
  homepage 'https://github.com/lsalzman/enet'
  version '1.3.17'
  license 'GPL-2'
  compatibility 'all'
  source_url 'https://github.com/lsalzman/enet.git'
  git_hashtag "v#{version}"

  binary_url({
    aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/enet/1.3.17_armv7l/enet-1.3.17-chromeos-armv7l.tar.zst',
     armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/enet/1.3.17_armv7l/enet-1.3.17-chromeos-armv7l.tar.zst',
       i686: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/enet/1.3.17_i686/enet-1.3.17-chromeos-i686.tar.zst',
     x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/enet/1.3.17_x86_64/enet-1.3.17-chromeos-x86_64.tar.zst'
  })
  binary_sha256({
    aarch64: '8dceccdbee07800d199f700a1c3eeb2a8a9003b948052ff29ea09cbdc5e358ea',
     armv7l: '8dceccdbee07800d199f700a1c3eeb2a8a9003b948052ff29ea09cbdc5e358ea',
       i686: '443da89c623d5bb1d921b145643e5e83f2178f72fd85c55427f641c4b59e964c',
     x86_64: '0f96b8e2b248e78bc8e3f70bb21c5006d0c0064382b3930441317a8856078252'
  })

  def self.build
    system 'autoreconf -vfi'
    system "./configure #{CREW_OPTIONS}"
    system 'make'
  end

  def self.install
    system 'make', "DESTDIR=#{CREW_DEST_DIR}", 'install'
  end
end
