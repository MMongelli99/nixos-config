{ pkgs, ... }:
{
  fonts.packages =
    let
      sf-mono = pkgs.fetchFromGitHub {
        owner = "supercomputra";
        repo = "SF-Mono-Font";
        rev = "1409ae79074d204c284507fef9e479248d5367c1";
        sha256 = "sha256-3wG3M4Qep7MYjktzX9u8d0iDWa17FSXYnObSoTG2I/o=";
      };
    in
    [
      sf-mono
    ]
    ++ (with pkgs; [
      mononoki
      terminus_font_ttf
      geist-font
    ]);
}
