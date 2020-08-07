class SwiftXctoolchain52 < Formula
  
  desc     "A macOS Swift 5.2 toolchain for cross compilation purposes"
  homepage "https://swift.org"
  url      "https://swift.org/builds/swift-5.2.5-release/xcode/swift-5.2.5-RELEASE/swift-5.2.5-RELEASE-osx.pkg"
  sha256   "be38e81ca0519aff0a3e6b3a80c474c134da4aa80cc8876cb1a9c273ad3b2586"

  version "5.2.5"
  version_scheme 1
  revision 2
  
  def install
    system "xar -xf *.pkg"
    system "mkdir", "swift.xctoolchain"
    system "cd swift.xctoolchain && cat ../*.pkg/Payload | gunzip -dc | cpio -i"
    system "mkdir", "-p", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.2.5"
    system "cp -ac swift.xctoolchain #{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.2.5/swift.xctoolchain"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.2.5", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.2-current"
  end
end
