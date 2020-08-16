class SpmDest53X8664Amazonlinux2 < Formula

  desc "An AmazonLinux2 cross compilation toolchain for Swift 5.3-2020-08-15-a"
  homepage "https://github.com/SPMDestinations/homebrew-tap"
  url "https://swift.org/builds/swift-5.3-branch/amazonlinux2/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a-amazonlinux2.tar.gz"
  # curl -L https://swift.org/builds/swift-5.3-branch/amazonlinux2/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a-amazonlinux2.tar.gz | shasum -a 256
  sha256 "cfb18f6f0e72a96f17be6178dcdc21fe0b942b480cf46ff0565e70afb0eb986e"

  version "swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a"
  version_scheme 1
  revision 3
  
  # the respective things are cloned into the X toolchain, hence only required
  # at build time.
  depends_on "spmdestinations/tap/swift-xctoolchain-5.3" => [:build]
  depends_on "spmdestinations/tap/host-lld-bin-8"   => [:build, :recommended]
  depends_on "spmdestinations/tap/clang-llvm-bin-8" => [:build, :optional]

  patch do
    url "https://helgehess.eu/patches/build-amazonlinux2-5.3-p2.patch"
    sha256 "f57e5bd826f3c7b84d7203c99b798997b2dc26f1083b3760c4e763b9ad0b9d92"
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
