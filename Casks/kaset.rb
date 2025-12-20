cask "kaset" do
  version "1.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://github.com/sozercan/kaset/releases/download/v#{version}/Kaset-v#{version}.dmg"
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
