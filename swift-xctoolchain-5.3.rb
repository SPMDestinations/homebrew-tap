class SwiftXctoolchain53 < Formula
  
  desc     "A macOS Swift 5.3.3 toolchain for cross compilation purposes"
  homepage "https://swift.org"
  url      "https://swift.org/builds/swift-5.3.3-release/xcode/swift-5.3.3-RELEASE/swift-5.3.3-RELEASE-osx.pkg"
  # curl -L https://swift.org/builds/swift-5.3.3-release/xcode/swift-5.3.3-RELEASE/swift-5.3.3-RELEASE-osx.pkg | shasum -a 256
  sha256   "e64c37155499b41a71c8c537ce4ada388247a28d690c01cd46df69860d3e9ec1"
  
  version "swift-5.3.3"
  version_scheme 2
  revision 4
  
  def install
    system "xar -xf *.pkg"
    system "mkdir", "swift.xctoolchain"
    system "cd swift.xctoolchain && cat ../*.pkg/Payload | gunzip -dc | cpio -i"
    system "mkdir", "-p", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3.3"
    system "cp -ac swift.xctoolchain #{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3.3/swift.xctoolchain"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/fat-apple-darwin/5.3.3", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-current"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3.3", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-current"
  end
end
