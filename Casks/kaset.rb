cask "kaset" do
  version "0.4.1"
  sha256 "e63d0d61bb6d0c2c5a61db54fd10606a1816b70e822c867588d0a301a5dd49b1"

  url "https://github.com/sozercan/kaset/releases/download/v0.4.1/kaset-v0.4.1.dmg"
  name "Kaset"
  desc "Native macOS YouTube Music client"
  homepage "https://github.com/sozercan/kaset"

  auto_updates false
  depends_on macos: ">= :tahoe"

  app "Kaset.app"

  zap trash: [
    "~/Library/Application Support/Kaset",
    "~/Library/Caches/com.sertacozercan.Kaset",
    "~/Library/Preferences/com.sertacozercan.Kaset.plist",
    "~/Library/Saved Application State/com.sertacozercan.Kaset.savedState",
    "~/Library/WebKit/com.sertacozercan.Kaset",
  ]
end
