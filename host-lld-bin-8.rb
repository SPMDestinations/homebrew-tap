class HostLldBin8 < Formula

  desc "Prebuilt LLVM lld 8.0.0 for cross compilation purposes."
  homepage "https://github.com/SPMDestinations/host-lld"
  url "https://github.com/SPMDestinations/host-lld/raw/main/x86_64-apple-darwin/8.0.0/lld"
  # curl -L https://github.com/SPMDestinations/host-lld/raw/main/x86_64-apple-darwin/8.0.0/lld | shasum -a 256
  sha256 "757a8fd830b855e33a9eaabd3915ccf4ab9a9937299d08592e124ef68d7cf15d"

  conflicts_with "spmdestinations/tap/clang-llvm-bin-8", :because => "clang-llvm-bin-8 also ships `lld`"

  def install
    system "mkdir", "-p", "#{prefix}/lib/swift/clang-llvm/x86_64-apple-darwin/8.0.0/bin"
    system "cp", "-ac", "lld", "#{prefix}/lib/swift/clang-llvm/x86_64-apple-darwin/8.0.0/bin/"
  end
end
