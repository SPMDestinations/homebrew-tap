class SwiftXctoolchain56 < Formula
  
  desc     "A macOS Swift 5.6 toolchain for cross compilation purposes"
  homepage "https://swift.org"
  url      "https://download.swift.org/swift-5.6.2-release/xcode/swift-5.6.2-RELEASE/swift-5.6.2-RELEASE-osx.pkg"
  # curl -L https://download.swift.org/swift-5.6.2-release/xcode/swift-5.6.2-RELEASE/swift-5.6.2-RELEASE-osx.pkg | shasum -a 256
  sha256   "6c5365bc2d143f9ff37ccd48b7193b7c7a7f0179edf18b8b5274e160c74cb6e3"
  
  version "swift-5.6.2"
  version_scheme 2
  revision 20
  
  def install
    system "xar -xf *.pkg"
    system "mkdir", "swift.xctoolchain"
    system "cd swift.xctoolchain && cat ../*.pkg/Payload | gunzip -dc | cpio -i"
    system "mkdir", "-p", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.6.2"
    system "cp -ac swift.xctoolchain #{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.6.2/swift.xctoolchain"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/fat-apple-darwin/5.6.2", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.6-current"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.6.2", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.6-current"
  end
end
