class CoralCli < Formula
  desc "coral 入口：clap 参数、配置加载、tracing 初始化、生命周期与优雅停机"
  homepage "https://github.com/haoxz11/coral"
  version "0.6.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/haoxz11/coral/releases/download/v0.6.4/coral-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a31e88ba6d328ac8e06d6b41d67bd552a040f984f941359d073a7a358196a0cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/haoxz11/coral/releases/download/v0.6.4/coral-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a379b5a077edf4e76cc52e441a9607ce6e9a5650e8522be7b8780bbb6671c0c6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "coral"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "coral"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
