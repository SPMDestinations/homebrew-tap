class SpmDest53X8664Ubuntu2004 < Formula
  
  desc "An Ubuntu 20.04 (Xenial) cross compilation toolchain for Swift 5.3.3"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.3.3-release/ubuntu2004/swift-5.3.3-RELEASE/swift-5.3.3-RELEASE-ubuntu20.04.tar.gz"
  # curl -L https://swift.org/builds/swift-5.3.3-release/ubuntu2004/swift-5.3.3-RELEASE/swift-5.3.3-RELEASE-ubuntu20.04.tar.gz | shasum -a 256
  sha256 "e2624f2b56cd63011aa1a185ea3fa9aedf157efe86e6b21b3eacc569a948e75e"
  
  version "5.3.3"
  version_scheme 2
  revision 15
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.3" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/ubuntu20.04-5.3-2021-02-17-3.patch"
    sha256 "1cbca03078819a74ab2895b14c95fcb5eee4c3b9911dabfbf0cd887f0f6c070f"
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
