class SwiftXctoolchain53 < Formula
  
  desc     "A macOS Swift 5.3 DEV SNAPSHOT toolchain for cross compilation purposes"
  homepage "https://swift.org"
  url      "https://swift.org/builds/swift-5.3-branch/xcode/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-07-31-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-07-31-a-osx.pkg"
  # curl -L https://swift.org/builds/swift-5.3-branch/xcode/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-07-31-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-07-31-a-osx.pkg | shasum -a 256
  sha256   "11faec25bc7fa8512970bf86352ee723606e895031172a3d0b37f900fa455dfd"
  
  def install
    system "xar -xf *.pkg"
    system "mkdir", "swift.xctoolchain"
    system "cd swift.xctoolchain && cat ../*.pkg/Payload | gunzip -dc | cpio -i"
    system "mkdir", "-p", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-dev-2020-07-31-a"
    system "cp -ac swift.xctoolchain #{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-dev-2020-07-31-a/swift.xctoolchain"
    system "ln", "-sf", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-dev-2020-07-31-a", "#{prefix}/lib/swift/xctoolchains/x86_64-apple-darwin/5.3-current"
  end
end
