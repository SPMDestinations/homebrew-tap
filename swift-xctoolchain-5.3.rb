class SwiftXctoolchain53 < Formula
  
  desc     "A macOS Swift 5.3.1 SNAPSHOT toolchain for cross compilation purposes"
  homepage "https://swift.org"
  url      "https://swift.org/builds/swift-5.3.1-release/xcode/swift-5.3.1-RELEASE/swift-5.3.1-RELEASE-osx.pkg"
  # curl -L https://swift.org/builds/swift-5.3.1-release/xcode/swift-5.3.1-RELEASE/swift-5.3.1-RELEASE-osx.pkg | shasum -a 256
  sha256   "9df54d4f5b866845751775cd7836850224b443dc055d0503fb01128775688b44"
  
  version "swift-5.3.1"
  version_scheme 2
  revision 3
  
  def install
    system "xar -xf *.pkg"
    system "mkdir", "swift.xctoolchain"
    system "cd swift.xctoolchain && cat ../*.pkg/Payload | gunzip -dc | cpio -i"
    system "mkdir", "-p", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3.1"
    system "cp -ac swift.xctoolchain #{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3.1/swift.xctoolchain"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/fat-apple-darwin/5.3.1", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-current"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3.1", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-current"
  end
end
