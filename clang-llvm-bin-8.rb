class ClangLlvmBin8 < Formula

  desc "Prebuilt CLang and LLVM 8.0.0 for cross compilation purposes."
  homepage "https://releases.llvm.org"
  url "https://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-apple-darwin.tar.xz"
  # curl -L https://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-apple-darwin.tar.xz | shasum -a 256
  sha256 "94ebeb70f17b6384e052c47fef24a6d70d3d949ab27b6c83d4ab7b298278ad6f"

  # This patch is for adding the Makefile which does the installation
  patch do
    url "https://helgehess.eu/patches/clang-llvm-8.0.0-makefile.patch"
    # curl -L https://helgehess.eu/patches/clang-llvm-8.0.0-makefile.patch | shasum -a 256
    sha256 "7f13437a92ab36113412164107584b46512dca4a08552740d1ac7d1c1ddd3d75"
  end
  
  def install
    system "make", "prefix=#{prefix}", "VERSION=8.0.0", "install"
  end
end
