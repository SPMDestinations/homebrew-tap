class SpmDest53X8664Amazonlinux2 < Formula

  desc "An AmazonLinux2 cross compilation toolchain for Swift 5.3-2020-09-09-a"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.3-branch/amazonlinux2/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-09-09-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-09-09-a-amazonlinux2.tar.gz"
  # curl -L https://swift.org/builds/swift-5.3-branch/amazonlinux2/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-09-09-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-09-09-a-amazonlinux2.tar.gz | shasum -a 256
  sha256 "aa63427c590764fa471fe9edb88cabdcb000655a48206f90224f62246a7b56ac"

  version "swift-5.3-DEVELOPMENT-SNAPSHOT-2020-09-09-a"
  version_scheme 1
  revision 4
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.3" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/amazonlinux2-5.3-2020-09-11-2.patch"
    sha256 "d6d42319e878bb482cd5bb61a619594096e14157b78a3b9bde204db6c0186526"
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
