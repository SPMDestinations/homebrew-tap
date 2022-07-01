class SpmDest54X8664Amazonlinux2 < Formula

  desc "An AmazonLinux2 cross compilation toolchain for Swift 5.4"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.4-release/amazonlinux2/swift-5.4-RELEASE/swift-5.4-RELEASE-amazonlinux2.tar.gz"
  # curl -L https://swift.org/builds/swift-5.4-release/amazonlinux2/swift-5.4-RELEASE/swift-5.4-RELEASE-amazonlinux2.tar.gz | shasum -a 256
  sha256 "8b8ea3e0ecbddc2db197af0d0aa68f7fb5d3f17c216dbe20e3c5836ecaa9eb18"

  version "5.4.0"
  version_scheme 2
  revision 18
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.4" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/amazonlinux2-5.3-2020-11-21-9.patch"
    sha256 "ac317170417c712446a4e02718db960cbad3dc1eb0f8e084ec0ab2e0a7f23632"
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
