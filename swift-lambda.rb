class SwiftLambda < Formula

  desc "Scripts to build and deploy Swift Package Manager projects on AWS Lambda"
  homepage "https://github.com/SwiftXcode/swift-lambda"
  url "https://github.com/SwiftXcode/swift-lambda/archive/0.1.3.tar.gz"
  # curl -L https://github.com/SwiftXcode/swift-lambda/archive/0.1.3.tar.gz | shasum -a 256
  sha256 "a0a6255b8254e59b62bc903f06ae472200a686eb38db5a6448038a11ac40ec7e"

  version "0.1.3"
  version_scheme 1
  revision 3
  
  depends_on "spmdestinations/tap/spm-dest-5.3-x86_64-amazonlinux2"
  depends_on "spmdestinations/tap/spm-dest-5.2-x86_64-amazonlinux2" => [:optional]
  depends_on "awscli"
  depends_on "jq"
  
  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
