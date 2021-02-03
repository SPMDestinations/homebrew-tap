class SwiftLambda < Formula

  desc "Scripts to build and deploy Swift Package Manager projects on AWS Lambda"
  homepage "https://github.com/SwiftXcode/swift-lambda"
  url "https://github.com/SwiftXcode/swift-lambda/archive/0.1.2.tar.gz"
  # curl -L https://github.com/SwiftXcode/swift-lambda/archive/0.1.2.tar.gz | shasum -a 256
  sha256 "014e1cad25dfeabf9189470b1dc000d1af431c5ef4317c4703105995b121d44f"

  version "0.1.2"
  version_scheme 1
  revision 2
  
  depends_on "spmdestinations/tap/spm-dest-5.3-x86_64-amazonlinux2"
  depends_on "spmdestinations/tap/spm-dest-5.2-x86_64-amazonlinux2" => [:optional]
  depends_on "awscli"
  depends_on "jq"
  
  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
