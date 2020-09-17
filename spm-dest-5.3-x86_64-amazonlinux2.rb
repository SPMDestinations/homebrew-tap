class SpmDest53X8664Amazonlinux2 < Formula

  desc "An AmazonLinux2 cross compilation toolchain for Swift 5.3"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.3-release/amazonlinux2/swift-5.3-RELEASE/swift-5.3-RELEASE-amazonlinux2.tar.gz"
  # curl -L https://swift.org/builds/swift-5.3-release/amazonlinux2/swift-5.3-RELEASE/swift-5.3-RELEASE-amazonlinux2.tar.gz | shasum -a 256
  sha256 "ce6eca6509031e636b9f6bbc9b1b1ccffc954a8ae34e32b8f142bbaf2353ee71"

  version "5.3.0"
  version_scheme 2
  revision 5
  
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
