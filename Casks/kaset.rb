cask "kaset" do
  version "0.4.0"
  sha256 "eb98f09350b034fb7e0f2a047e74c3d773d79f05d18ee7afef792ed5c36985e9"

  url "https://github.com/sozercan/kaset/releases/download/v0.4.0/kaset-v0.4.0.dmg"
  name "Kaset"
  desc "Native macOS YouTube Music client"
  homepage "https://github.com/sozercan/kaset"

  auto_updates true
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
