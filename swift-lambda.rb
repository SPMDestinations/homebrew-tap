class SwiftLambda < Formula

  desc "Scripts to build and deploy Swift Package Manager projects on AWS Lambda"
  homepage "https://github.com/SwiftXcode/swift-lambda"
  url "https://github.com/SwiftXcode/swift-lambda/archive/0.1.0.tar.gz"
  # curl -L https://github.com/SwiftXcode/swift-lambda/archive/0.1.0.tar.gz | shasum -a 256
  sha256 "da340e28adf1a4e8b8123c3e1faf66ab23bab8587ab13db4c518334d069677eb"

  version "0.1.0"
  version_scheme 1
  revision 1
  
  depends_on "spmdestinations/tap/spm-dest-5.2-x86_64-amazonlinux2"
  depends_on "awscli"
  depends_on "jq"
  
  def install
    system "make", "install"
  end
end
