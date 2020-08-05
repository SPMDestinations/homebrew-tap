class SpmDest53X8664Ubuntu1604 < Formula
  
  desc "An Ubuntu 16.04 (Xenial) cross compilation toolchain for Swift 5.3-2020-07-31-a"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.3-branch/ubuntu1604/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-07-31-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-07-31-a-ubuntu16.04.tar.gz"
  sha256 "56457054578913a691c3998d7c5583a4bf950d6d32b9d7a37281c1eb8a3b24c6"
  
  version "swift-5.3-DEVELOPMENT-SNAPSHOT-2020-07-31-a"
  version_scheme 1
  revision 3
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.3" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/build-ubuntu16.04-5.3-p2.patch"
    sha256 "dbb00ccdba0d585ececedd4d1ee0494aed01973205027f5951e4830eef5b2473"
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
