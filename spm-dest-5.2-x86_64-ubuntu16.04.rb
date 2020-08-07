class SpmDest52X8664Ubuntu1604 < Formula
  
  desc "An Ubuntu 16.04 (Xenial) cross compilation toolchain for Swift 5.2"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.2.5-release/ubuntu1604/swift-5.2.5-RELEASE/swift-5.2.5-RELEASE-ubuntu16.04.tar.gz"
  sha256 "e5768a597d32f7dc8dfbfde0d7850be36a660860ef1fa38a08041ec09aac1fa9"
  
  version "5.2.5"
  version_scheme 1
  revision 1
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.2" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/build-ubuntu16.04-5.2-p1.patch"
    sha256 "35c55060900c8edac48cbb806647c7453a8b4ff0ab8b6f52fc00fb37a7fe180c"
  end
  
  def install
    ENV.deparallelize
    system "chmod", "+x", "build-toolchain.sh"
    system "chmod", "+x", "retrieve-sdk-packages.sh"
    system "make", \
           "prefix=#{prefix}", \
           "ACTUAL_DESTINATION_PREFIX=#{HOMEBREW_PREFIX}", \
           "install"
  end
end
