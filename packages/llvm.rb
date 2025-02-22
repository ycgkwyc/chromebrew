require 'package'

class Llvm < Package
  description 'The LLVM Project is a collection of modular and reusable compiler and toolchain technologies. The optional packages clang, lld, lldb, polly, compiler-rt, libcxx, libcxxabi, and openmp are included.'
  homepage 'http://llvm.org/'
  @_ver = '15.0.1'
  version @_ver
  license 'Apache-2.0-with-LLVM-exceptions, UoI-NCSA, BSD, public-domain, rc, Apache-2.0 and MIT'
  compatibility 'all'
  source_url 'https://github.com/llvm/llvm-project.git'
  git_hashtag "llvmorg-#{@_ver}"

  binary_url({
    aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/llvm/15.0.1_armv7l/llvm-15.0.1-chromeos-armv7l.tar.zst',
     armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/llvm/15.0.1_armv7l/llvm-15.0.1-chromeos-armv7l.tar.zst',
       i686: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/llvm/15.0.1_i686/llvm-15.0.1-chromeos-i686.tar.zst',
     x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/llvm/15.0.1_x86_64/llvm-15.0.1-chromeos-x86_64.tar.zst'
  })
  binary_sha256({
    aarch64: 'af77b81a172156105f5a8f3f97bb096a304bea87570acc491ea9d8d46ffdf5e6',
     armv7l: 'af77b81a172156105f5a8f3f97bb096a304bea87570acc491ea9d8d46ffdf5e6',
       i686: 'a4076e4e2f7a01b8bc131f8f3e2ccc68a012fe8859657468b0fbd4f19391b704',
     x86_64: 'e70d89a80486f4afa911df7624510f465a75658b40df8db21a0ef41770fdc83a'
  })

  depends_on 'ocaml' => :build
  depends_on 'py3_pygments' => :build
  depends_on 'ccache' => :build
  depends_on 'elfutils' # R
  depends_on 'gcc' # R
  no_env_options
  no_patchelf

  case ARCH
  when 'aarch64', 'armv7l'
    # LLVM_TARGETS_TO_BUILD = 'ARM;AArch64;AMDGPU'
    # LLVM_TARGETS_TO_BUILD = 'all'.freeze
    @ARCH_C_FLAGS = "-fPIC -march=armv7-a -mfloat-abi=hard -ccc-gcc-name #{CREW_BUILD}"
    @ARCH_CXX_FLAGS = "-fPIC -march=armv7-a -mfloat-abi=hard -ccc-gcc-name #{CREW_BUILD}"
    @ARCH_LDFLAGS = ''
    @ARCH_LTO_LDFLAGS = "#{@ARCH_LDFLAGS} -flto=thin"
    # compiler-rt fails with
    # [2967/6683] Building CXX object projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonSymbolizer.armhf.dir/sanitizer_unwind_linux_libcdep.cpp.o
    # FAILED: projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonSymbolizer.armhf.dir/sanitizer_unwind_linux_libcdep.cpp.o
    # CCACHE_CPP2=yes CCACHE_HASHDIR=yes /usr/local/bin/ccache /usr/local/bin/clang++ -DHAVE_RPC_XDR_H=1 -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -Iprojects/compiler-rt/lib/sanitizer_common -I/usr/local/tmp/crew/llvm.20210420052043.dir/llvm-project-llvmorg-12.0.0/compiler-rt/lib/sanitizer_common -Iinclude -I/usr/local/tmp/crew/llvm.20210420052043.dir/llvm-project-llvmorg-12.0.0/llvm/include -I/usr/local/tmp/crew/llvm.20210420052043.dir/llvm-project-llvmorg-12.0.0/compiler-rt/lib/sanitizer_common/.. -fPIC -march=armv7-a -mfloat-abi=hard -ccc-gcc-name armv7l-cros-linux-gnueabihf -flto=thin -fuse-ld=lld -fvisibility-inlines-hidden -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -pedantic -Wno-long-long -Wno-noexcept-type -Wnon-virtual-dtor -Wsuggest-override -Wno-comment -fdiagnostics-color -flto=thin -Wall -std=c++14 -O3 -DNDEBUG  -fPIC -fno-builtin -fno-exceptions -fomit-frame-pointer -funwind-tables -fno-stack-protector -fno-sanitize=safe-stack -fvisibility=hidden -fno-lto -O3 -gline-tables-only -nostdinc++ -fno-rtti -std=c++14 -MD -MT projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonSymbolizer.armhf.dir/sanitizer_unwind_linux_libcdep.cpp.o -MF projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonSymbolizer.armhf.dir/sanitizer_unwind_linux_libcdep.cpp.o.d -o projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonSymbolizer.armhf.dir/sanitizer_unwind_linux_libcdep.cpp.o -c /usr/local/tmp/crew/llvm.20210420052043.dir/llvm-project-llvmorg-12.0.0/compiler-rt/lib/sanitizer_common/sanitizer_unwind_linux_libcdep.cpp
    # clang-11: warning: argument unused during compilation: '-fuse-ld=lld' [-Wunused-command-line-argument]
    # /usr/local/tmp/crew/llvm.20210420052043.dir/llvm-project-llvmorg-12.0.0/compiler-rt/lib/sanitizer_common/sanitizer_unwind_linux_libcdep.cpp:63:3: error: use of undeclared identifier '_Unwind_VRS_Result'; did you mean '_Unwind_Resume'?
    # _Unwind_VRS_Result res = _Unwind_VRS_Get(ctx, _UVRSC_CORE,
    # ^~~~~~~~~~~~~~~~~~
    # _Unwind_Resume
    LLVM_PROJECTS_TO_BUILD = 'clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;lld;polly'.freeze
  when 'i686'
    # LLVM_TARGETS_TO_BUILD = 'X86'.freeze
    # Because ld.lld: error: undefined symbol: __atomic_store
    # Polly demands fPIC
    @ARCH_C_FLAGS = '-latomic -fPIC'
    @ARCH_CXX_FLAGS = '-latomic -fPIC'
    # Because getting this error:
    # ld.lld: error: relocation R_386_PC32 cannot be used against symbol isl_map_fix_si; recompile with -fPIC
    # So as per https://github.com/openssl/openssl/issues/11305#issuecomment-602003528
    @ARCH_LDFLAGS = '-Wl,-znotext'
    @ARCH_LTO_LDFLAGS = "#{@ARCH_LDFLAGS} -flto=thin"
    # lldb fails on i686 due to requirement for a kernel > 4.1.
    # See https://github.com/llvm/llvm-project/issues/57594
    LLVM_PROJECTS_TO_BUILD = 'clang;clang-tools-extra;libcxx;libcxxabi;libunwind;compiler-rt;lld;polly'.freeze
  when 'x86_64'
    # LLVM_TARGETS_TO_BUILD = 'X86;AMDGPU'
    # LLVM_TARGETS_TO_BUILD = 'all'.freeze
    @ARCH_C_FLAGS = '-fPIC'
    @ARCH_CXX_FLAGS = '-fPIC'
    @ARCH_LDFLAGS = ''
    @ARCH_LTO_LDFLAGS = "#{@ARCH_LDFLAGS} -flto=thin"
    LLVM_PROJECTS_TO_BUILD = 'clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly'.freeze
  end
  @ARCH_C_LTO_FLAGS = "#{@ARCH_C_FLAGS} -flto=thin"
  @ARCH_CXX_LTO_FLAGS = "#{@ARCH_CXX_FLAGS} -flto=thin"
  # LLVM_PROJECTS_TO_BUILD = 'clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly;openmp'.freeze

  # Using Targets 'all' for non-i686 because otherwise mesa complains.
  # This may be patched upstream as per
  # https://reviews.llvm.org/rG1de56d6d13c083c996dfd44a32041dacae037d66
  LLVM_TARGETS_TO_BUILD = 'all'.freeze

  def self.build
    ############################################################
    puts "Building LLVM Targets: #{LLVM_TARGETS_TO_BUILD}".lightgreen
    puts "Building LLVM Projects: #{LLVM_PROJECTS_TO_BUILD}".lightgreen
    ############################################################
    ############################################################
    puts 'Setting compile to use python3'.lightgreen
    ############################################################
    system "grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'"

    ############################################################
    # puts "Downloading binutils #{BINUTILS_BRANCH} src to enable gold plugin build".lightgreen
    ############################################################
    # system "git config --global advice.detachedHead false"
    # As per https://github.com/SVF-tools/SVF/wiki/Install-LLVM-Gold-Plugin-on-Ubuntu
    # system "git clone --depth 1 --branch #{BINUTILS_BRANCH} git://sourceware.org/git/binutils-gdb.git binutils"

    Dir.mkdir 'builddir'
    Dir.chdir 'builddir' do
      system "echo '#!/bin/bash
machine=\$(gcc -dumpmachine)
version=\$(gcc -dumpversion)
gnuc_lib=#{CREW_LIB_PREFIX}/gcc/\${machine}/\${version}
clang -B \${gnuc_lib} -L \${gnuc_lib} \"\$@\"' > clc"
      system "echo '#!/bin/bash
machine=\$(gcc -dumpmachine)
version=\$(gcc -dumpversion)
cxx_sys=#{CREW_PREFIX}/include/c++/\${version}
cxx_inc=#{CREW_PREFIX}/include/c++/\${version}/\${machine}
gnuc_lib=#{CREW_LIB_PREFIX}/gcc/\${machine}/\${version}
clang++ -fPIC  -rtlib=compiler-rt -stdlib=libc++ -cxx-isystem \${cxx_sys} -I \${cxx_inc} -B \${gnuc_lib} -L \${gnuc_lib} \"\$@\"' > clc++"
      system "LLVM_IAS=1 PATH=#{CREW_LIB_PREFIX}/ccache/bin:#{CREW_PREFIX}/bin:/usr/bin:/bin LD=ld.lld \
            cmake -G Ninja \
            -DCMAKE_ASM_COMPILER_TARGET=#{CREW_BUILD} \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_C_COMPILER=$(which clang) \
            -DCMAKE_C_COMPILER_TARGET=#{CREW_BUILD} \
            -DCMAKE_C_FLAGS='#{@ARCH_C_LTO_FLAGS}' \
            -DCMAKE_CXX_COMPILER=$(which clang++) \
            -DCMAKE_CXX_FLAGS='#{@ARCH_CXX_LTO_FLAGS}' \
            -DCMAKE_EXE_LINKER_FLAGS='#{@ARCH_LTO_LDFLAGS}' \
            -DCMAKE_INSTALL_PREFIX=#{CREW_PREFIX} \
            -DCMAKE_LINKER=$(which ld.lld) \
            -D_CMAKE_TOOLCHAIN_PREFIX=llvm- \
            -DCOMPILER_RT_BUILD_BUILTINS=ON \
            -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
            -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
            -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
            -DLIBOMP_ENABLE_SHARED=ON \
            -DLIBOMP_INSTALL_ALIASES=OFF \
            -DLIBUNWIND_C_FLAGS='-fno-exceptions -funwind-tables' \
            -DLIBUNWIND_CXX_FLAGS='-fno-exceptions -funwind-tables' \
            -DLIBUNWIND_SUPPORTS_FNO_EXCEPTIONS_FLAG=ON \
            -DLIBUNWIND_SUPPORTS_FUNWIND_TABLES_FLAG=ON \
            -DLLVM_BINUTILS_INCDIR='#{CREW_PREFIX}/include' \
            -DLLVM_BUILD_LLVM_DYLIB=ON \
            -DLLVM_CCACHE_BUILD=ON \
            -DLLVM_DEFAULT_TARGET_TRIPLE=#{CREW_BUILD} \
            -DLLVM_ENABLE_FFI=ON \
            -DLLVM_ENABLE_LTO=Thin \
            -DLLVM_ENABLE_PROJECTS='#{LLVM_PROJECTS_TO_BUILD}' \
            -DLLVM_ENABLE_RTTI=ON \
            -DLLVM_ENABLE_RUNTIME=openmp \
            -DLLVM_ENABLE_TERMINFO=ON \
            -DLLVM_INSTALL_UTILS=ON \
            -DLLVM_LIBDIR_SUFFIX='#{CREW_LIB_SUFFIX}' \
            -DLLVM_LINK_LLVM_DYLIB=ON \
            -DLLVM_OPTIMIZED_TABLEGEN=ON \
            -DLLVM_TARGETS_TO_BUILD=\'#{LLVM_TARGETS_TO_BUILD}' \
            -DOPENMP_ENABLE_LIBOMPTARGET=OFF \
            -DPYTHON_EXECUTABLE=$(which python3) \
            -Wno-dev \
            ../llvm"
      system 'mold -run samu'
    end
  end

  def self.install
    Dir.chdir('builddir') do
      system "DESTDIR=#{CREW_DEST_DIR} samu install"
      FileUtils.install 'clc', "#{CREW_DEST_PREFIX}/bin/clc", mode: 0o755
      FileUtils.install 'clc++', "#{CREW_DEST_PREFIX}/bin/clc++", mode: 0o755
      FileUtils.mkdir_p "#{CREW_DEST_LIB_PREFIX}/bfd-plugins"
      Dir.chdir("#{CREW_DEST_LIB_PREFIX}/bfd-plugins") do
        FileUtils.ln_s "../../lib#{CREW_LIB_SUFFIX}/LLVMgold.so", 'LLVMgold.so'
      end
      # libunwind.* conflicts with libunwind package
      FileUtils.rm Dir.glob("#{CREW_DEST_LIB_PREFIX}/libunwind.*")
    end
  end

  def self.check
    Dir.chdir('builddir') do
      system 'samu check-llvm || true'
      system 'samu check-clang || true'
      system 'samu check-lld || true'
    end
  end

  def self.postinstall
    puts
    puts "To compile programs, use 'clang' or 'clang++'.".lightblue
    puts
    puts 'To avoid the repeated use of switch options,'.lightblue
    puts "try the wrapper scripts 'clc' or 'clc++'.".lightblue
    puts
    puts 'For more information, see http://llvm.org/pubs/2008-10-04-ACAT-LLVM-Intro.pdf'.lightblue
    puts
  end
end
