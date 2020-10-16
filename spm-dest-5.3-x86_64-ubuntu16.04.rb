class SpmDest53X8664Ubuntu1604 < Formula
  
  desc "An Ubuntu 16.04 (Xenial) cross compilation toolchain for Swift 5.3"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.3-release/ubuntu1604/swift-5.3-RELEASE/swift-5.3-RELEASE-ubuntu16.04.tar.gz"
  # curl -L https://swift.org/builds/swift-5.3-release/ubuntu1604/swift-5.3-RELEASE/swift-5.3-RELEASE-ubuntu16.04.tar.gz | shasum -a 256
  sha256 "f681af53dd2e7650f22cafbad816a867ce34673344e7ba8610b98a4d7a140a03"
  
  version "5.3.0"
  version_scheme 2
  revision 9
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.3" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/ubuntu16.04-5.3-2020-10-16-9.patch"
    sha256 "e6bf4e5719ab1c74f50c9562025da8789b4aa6bb90c17bfbb0669d0481eac282"
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
