class SpmDest52X8664Amazonlinux2 < Formula

  desc "An AmazonLinux2 cross compilation toolchain for Swift 5.2"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.2.5-release/amazonlinux2/swift-5.2.5-RELEASE/swift-5.2.5-RELEASE-amazonlinux2.tar.gz"
  sha256 "e827d6c451bc3abe70b4b7770411e21ffcd863c9a1d669803948216235f0fcf2"

  version "5.2.5"
  version_scheme 1
  revision 3

  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.2" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/build-amazonlinux2-5.2-2020-09-11-1.patch"
    sha256 "cea1d995a9ecd37d3c03c99d50919461c6746925fba09c44b6266c949fdab36b"
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