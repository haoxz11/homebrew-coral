class CoralCli < Formula
  desc "coral 入口：clap 参数、配置加载、tracing 初始化、生命周期与优雅停机"
  homepage "https://github.com/haoxz11/coral"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/haoxz11/coral/releases/download/v0.3.1/coral-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8d6279c22f094701a7ffffd3a6f8fbf645e8b101cb93c459ce9165ac68c6045a"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/haoxz11/coral/releases/download/v0.3.1/coral-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9255ebd04858d7ef52cc302a450eda0e04e7d531e3af5ea1e1b02fa7d16b716"
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
