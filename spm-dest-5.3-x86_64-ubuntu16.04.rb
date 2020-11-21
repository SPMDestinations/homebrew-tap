class SpmDest53X8664Ubuntu1604 < Formula
  
  desc "An Ubuntu 16.04 (Xenial) cross compilation toolchain for Swift 5.3.1"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.3.1-release/ubuntu1604/swift-5.3.1-RELEASE/swift-5.3.1-RELEASE-ubuntu16.04.tar.gz"
  # curl -L https://swift.org/builds/swift-5.3.1-release/ubuntu1604/swift-5.3.1-RELEASE/swift-5.3.1-RELEASE-ubuntu16.04.tar.gz | shasum -a 256
  sha256 "e2a49d4e1f3284c22eb31b19e2001e530e47443a333f9e87085a12444def5135"
  
  version "5.3.1"
  version_scheme 2
  revision 12
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.3" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/ubuntu16.04-5.3-2020-11-21-11.patch"
    sha256 "97ab5a610188487681360032b64e90834cbdbf5a753ddac339bf72d0d2619269"
  end
  
  def install
    ENV.deparallelize
    system "chmod", "+x", "build-toolchain.sh"
    system "chmod", "+x", "retrieve-sdk-packages.sh"
    system "make", \
           "prefix=#{prefix}", \
           "ACTUAL_DESTINATION_PREFIX=#{HOMEBREW_PREFIX}", \
           "SWIFT_LIB_DIR=#{HOMEBREW_PREFIX}/lib/swift", \
           "install"
  end
end
