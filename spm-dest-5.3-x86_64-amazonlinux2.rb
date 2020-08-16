class SpmDest52X8664Amazonlinux2 < Formula

  desc "An AmazonLinux2 cross compilation toolchain for Swift 5.3-2020-08-15-a"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.3-branch/amazonlinux2/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a-amazonlinux2.tar.gz"
  sha256 "e827d6c451bc3abe70b4b7770411e21ffcd863c9a1d669803948216235f0fcf2"

  version "swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a"
  version_scheme 1
  revision 1
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.3" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/build-amazonlinux2-5.3-p1.patch"
    sha256 "19d9e82c42923055eb52c2dafc098ca87aa7b8b25160cc7f7c7b918a8f19568c"
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
