class SpmDest53X8664Ubuntu1604 < Formula
  
  desc "An Ubuntu 16.04 (Xenial) cross compilation toolchain for Swift 5.3-2020-08-15-a"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.3-branch/ubuntu1604/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a-ubuntu16.04.tar.gz"
  # curl -L https://swift.org/builds/swift-5.3-branch/ubuntu1604/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a-ubuntu16.04.tar.gz | shasum -a 256
  sha256 "d698c7d7c0f8d7dc2f137280244a0fdcd6b8497d0c3a073bbac5050ff9c88d14"
  
  version "swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a"
  version_scheme 1
  revision 7
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.3" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/build-ubuntu16.04-5.3-p6.patch"
    sha256 "4999891eda8b8b91407e0388e4a95a21bfd32c20b62b7be96b7d7e70dffa1178"
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
