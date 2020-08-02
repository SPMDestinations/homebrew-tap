class SwiftXctoolchain52 < Formula
  
  desc     "A macOS Swift 5.2 toolchain for cross compilation purposes"
  homepage "https://swift.org"
  url      "https://swift.org/builds/swift-5.2.4-release/xcode/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-osx.pkg"
  sha256   "ba409649620129375e014c4753a6f802fb94e46ee833dbf917111e593342ddfc"
  
  def install
    system "xar -xf *.pkg"
    system "mkdir", "swift.xctoolchain"
    system "cd swift.xctoolchain && cat ../*.pkg/Payload | gunzip -dc | cpio -i"
    system "mkdir", "-p", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.2.4"
    system "cp -ac swift.xctoolchain #{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.2.4/swift.xctoolchain"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.2.4", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.2-current"
  end
end
