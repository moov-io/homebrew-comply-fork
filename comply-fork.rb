class Comply < Formula
  desc "Compliance automation framework, focused on SOC2"
  homepage "https://github.com/moov-io/comply-fork"
  url "https://github.com/moov-io/comply-fork/archive/v1.5.2.tar.gz"
  sha256 "18701d5a5b9a9bfe549ea943b6df179d1a996214290ec7a2f581f0f60e3e62b7"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    (buildpath/"src/github.com/moov-io/comply-fork").install buildpath.children
    cd "src/github.com/moov-io/comply-fork" do
      system "make", "brew"
      bin.install "bin/comply"
    end
  end

  test do
    (testpath/"init_comply.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout 2
      spawn #{bin}/comply init
      send -- "Hello Corporation\r"
      expect "*Filename Prefix*"
      send -- "\r\r\r"
      expect "*GitHub*"
      send -- "\r"
      expect "*Configure github now*"
      send -- "\r\r"
      expect "+:+"
      send -- "thing\r"
      expect "+:+"
      send -- "thing\r"
      expect "+:+"
      send -- "thing\r"
      expect "+:+"
      send -- "thing\r"
      expect "*Next steps*"
      expect eof
    EOS

    chmod 0755, testpath/"init_comply.sh"
    mkdir testpath/"rundir"

    system "cd rundir && ../init_comply.sh"
    assert_predicate testpath/"rundir/narratives", :exist?
    assert_predicate testpath/"rundir/policies", :exist?
    assert_predicate testpath/"rundir/procedures", :exist?
    assert_predicate testpath/"rundir/standards", :exist?
    assert_predicate testpath/"rundir/templates", :exist?
  end
end
