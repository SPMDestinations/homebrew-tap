class SwiftLambda < Formula

  desc "Scripts to build and deploy Swift Package Manager projects on AWS Lambda"
  homepage "https://github.com/SwiftXcode/swift-lambda"
  url "https://github.com/SwiftXcode/swift-lambda/archive/0.1.1.tar.gz"
  # curl -L https://github.com/SwiftXcode/swift-lambda/archive/0.1.1.tar.gz | shasum -a 256
  sha256 "0409d93134ed595223c7f09d61bd7085d60f42e8b5e02b19c5ceb08f8d0181ec"

  version "0.1.1"
  version_scheme 1
  revision 1
  
  depends_on "spmdestinations/tap/spm-dest-5.3-x86_64-amazonlinux2"
  depends_on "spmdestinations/tap/spm-dest-5.2-x86_64-amazonlinux2" => [:optional]
  depends_on "awscli"
  depends_on "jq"
  
  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
