class SpmDest53X8664Amazonlinux2 < Formula

  desc "An AmazonLinux2 cross compilation toolchain for Swift 5.3.1"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.3.1-release/amazonlinux2/swift-5.3.1-RELEASE/swift-5.3.1-RELEASE-amazonlinux2.tar.gz"
  # curl -L https://swift.org/builds/swift-5.3.1-release/amazonlinux2/swift-5.3.1-RELEASE/swift-5.3.1-RELEASE-amazonlinux2.tar.gz | shasum -a 256
  sha256 "ebf2d981a624b353f8bb24ffcfb8a74a19959e31b6da088e32a6a8b1414839bf"

  version "5.3.1"
  version_scheme 2
  revision 8
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.3" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/amazonlinux2-5.3-2020-11-21-8.patch"
    sha256 "73e9611c090d54baef4fa5b5aae74083028302eeacff7fb0e858a6ff99bd6d73"
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
