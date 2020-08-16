class SwiftXctoolchain53 < Formula
  
  desc     "A macOS Swift 5.3 DEV SNAPSHOT toolchain for cross compilation purposes"
  homepage "https://swift.org"
  url      "https://swift.org/builds/swift-5.3-branch/xcode/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a-osx.pkg"
  # curl -L https://swift.org/builds/swift-5.3-branch/xcode/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a-osx.pkg | shasum -a 256
  sha256   "c283e5f50a171bdfbde87480c0c996ec97a137a6885c68c51d040af0e424b282"
  
  version "swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a"
  version_scheme 1
  revision 2
  
  def install
    system "xar -xf *.pkg"
    system "mkdir", "swift.xctoolchain"
    system "cd swift.xctoolchain && cat ../*.pkg/Payload | gunzip -dc | cpio -i"
    system "mkdir", "-p", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-dev-2020-08-15-a"
    system "cp -ac swift.xctoolchain #{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-dev-2020-08-15-a/swift.xctoolchain"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-dev-2020-08-15-a", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-current"
  end
end
