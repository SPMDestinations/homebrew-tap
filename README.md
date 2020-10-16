<h2>SPMDestinations
  <img src="http://zeezide.com/img/SwiftXcodePkgIcon.svg"
       align="right" width="128" height="128" />
</h2>

What is this? It's a set of Homebrew formulas (installation packages) to install
(and build) Swift cross compilers hosted on macOS.
For example it allows you to build a Swift Package Manager package on macOS,
but for Ubuntu Linux. Without running anything in Docker.

End of April 2017
[Johannes Weiß](https://github.com/weissi)
added
[custom toolchain support](https://github.com/apple/swift-package-manager/pull/1098)
to 
[Swift Package Manager](https://github.com/apple/swift-package-manager).
Johannes also provided 
[a script](https://github.com/apple/swift-package-manager/blob/main/Utilities/build_ubuntu_cross_compilation_toolchain)
which shows how to build an Ubuntu toolchain for x86-64.

SPMDestinations splits up the original script into multiple parts and provides
the results as Homebrew formulas. This way Homebrew can cache components which
are reused for different toolchains, and the installation is much easier.

NOTE: Thanks to [SR-13312](https://bugs.swift.org/browse/SR-13312) this 
      **requires** a **Swift 5.3** installation (e.g. Xcode 12) on the host 
      system.

## Toolchain Installation

SPMDestinations requires [Homebrew](https://brew.sh),
get it [over here](https://brew.sh).

Currently those cross compilation toolchains are provided:
- Swift 5.3, Ubuntu Xenial (16.04), x86_64
- Swift 5.3, Amazon Linux 2, x86_64
- Swift 5.2.5, Ubuntu Xenial (16.04), x86_64
- Swift 5.2.5, Amazon Linux 2, x86_64

> Note that the required toolchains are quite big (~500MB compressed each, for
> host and target system).
> The scripts clone the respective folders to make things reasonably fast and
> save space.

```shell
brew tap SPMDestinations/tap
brew install spm-dest-5.3-x86_64-ubuntu16.04
```

This puts the toolchain into:
```shell
ls /usr/local/lib/swift/dst/x86_64-unknown-linux/
swift-5.3-ubuntu16.04.xtoolchain
```

### Testing the Toolchain

To build an SPM package for a different platform,
one just adds the `--destination` argument, pointing to the desired
cross toolchain.

A full example:
```shell
mkdir macro-test && cd macro-test
swift package init --type=executable

swift build --destination \
  /usr/local/lib/swift/dst/x86_64-unknown-linux/swift-5.3-ubuntu16.04.xtoolchain/destination.json
```

The built product can be found in `.build` as usual:
```shell
file .build/debug/macro-test
.build/debug/macro-test:                   \
  ELF 64-bit LSB shared object, x86-64,    \
  version 1 (SYSV), dynamically linked,    \
  interpreter /lib64/ld-linux-x86-64.so.2, \
  for GNU/Linux 2.6.32, with debug_info, not stripped
```

To actually test whether it works, it can be copied over to an actual Linux
machine, or run within Docker:
```shell
docker run --rm -t                    \
  --name test-x-build                 \
  --volume "${PWD}/.build/debug:/run" \
  --workdir "/run"                    \
  swiftlang/swift:nightly-5.3-xenial  \
  bash -c "LD_LIBRARY_PATH=/usr/lib/swift/linux ./macro-test"
Hello, world!
```
> The LD_LIBRARY_PATH is b0rked in the `nightly-5.3-xenial` Docker image
> (doesn't include /usr/lib/swift/linux),
> hence the explicit setting.


## Dev Installation

When building own toolchains a Swift host toolchain is usually required.
Plus for Linux targets the LLVM linker (lld).
This project provides formulas for both.

> They don't do much but grab the toolchains from swift.org and put them into a
> specific Brew directory. The advantage is that Brew does all the caching.

```shell
brew tap SPMDestinations/tap
brew install host-lld-bin-8 swift-xctoolchain-5.3
```

The full binary clang/llvm toolchains (as used in the original script)
are also provided as formulas via `brew install clang-llvm-bin-8` (BIG!).


### Who

**SPMDestinations** is brought to you by
[ZeeZide](http://zeezide.de).
We like feedback, GitHub stars, cool contract work,
presumably any form of praise you can think of.
