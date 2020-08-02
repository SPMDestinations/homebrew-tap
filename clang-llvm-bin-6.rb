class ClangLlvmBin6 < Formula

  desc "Prebuilt CLang and LLVM 6.0.x for cross compilation purposes."
  homepage "https://releases.llvm.org"
  url "https://releases.llvm.org/6.0.0/clang+llvm-6.0.0-x86_64-apple-darwin.tar.xz"
  # curl -L https://releases.llvm.org/6.0.0/clang+llvm-6.0.0-x86_64-apple-darwin.tar.xz | shasum -a 256
  sha256 "0ef8e99e9c9b262a53ab8f2821e2391d041615dd3f3ff36fdf5370916b0f4268"

  # This patch is for adding the Makefile which does the installation
  patch do
    url "https://helgehess.eu/patches/clang-llvm-8.0.0-makefile.patch"
    # curl -L https://helgehess.eu/patches/clang-llvm-8.0.0-makefile.patch | shasum -a 256
    sha256 "7f13437a92ab36113412164107584b46512dca4a08552740d1ac7d1c1ddd3d75"
  end
  
  def install
    system "make", "prefix=#{prefix}", "VERSION=6.0.0", "install"
  end
end
