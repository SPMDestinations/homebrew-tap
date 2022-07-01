class SwiftXctoolchain54 < Formula
  
  desc     "A macOS Swift 5.4 toolchain for cross compilation purposes"
  homepage "https://swift.org"
  url      "https://swift.org/builds/swift-5.4-release/xcode/swift-5.4-RELEASE/swift-5.4-RELEASE-osx.pkg"
  # curl -L https://swift.org/builds/swift-5.4-release/xcode/swift-5.4-RELEASE/swift-5.4-RELEASE-osx.pkg | shasum -a 256
  sha256   "2271ec22eac8849d84278767d1e02a81614f6e94c8a83351fb7d28e814e9b99d"
  
  version "swift-5.4.0"
  version_scheme 2
  revision 18
  
  def install
    system "xar -xf *.pkg"
    system "mkdir", "swift.xctoolchain"
    system "cd swift.xctoolchain && cat ../*.pkg/Payload | gunzip -dc | cpio -i"
    system "mkdir", "-p", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.4.0"
    system "cp -ac swift.xctoolchain #{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.4.0/swift.xctoolchain"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/fat-apple-darwin/5.4.0", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.4-current"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.4.0", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.4-current"
  end
end
