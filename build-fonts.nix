{pkgs ? import <nixpkgs> {}}: let
  # Load the JSON metadata
  fontInfo = pkgs.lib.trivial.importJSON ./fonts.json;
  # anonymous function which takes font as argument
  buildFont = font:
    pkgs.stdenvNoCC.mkDerivation rec {
      pname = font.name;
      version = "1.0"; # -- TODO: You can specify or compute version from the URL or other metadata

      src = pkgs.fetchzip {
        url = font.url;
        hash = font.hash;
        stripRoot = false;
      };

      nativeBuildInputs = [pkgs.xz pkgs.unzip];

      installPhase = let
        dirName = pname;
      in ''
          runHook preInstall
          mkdir -p "$out/share/fonts"

          echo "=========================================================="
          ls
          echo "=========================================================="

        dst_opentype=$out/share/fonts/opentype/NerdFonts/${dirName}
              dst_truetype=$out/share/fonts/truetype/NerdFonts/${dirName}

              find -name \*.otf -exec mkdir -p $dst_opentype \; -exec cp -p {} $dst_opentype \;
              find -name \*.ttf -exec mkdir -p $dst_truetype \; -exec cp -p {} $dst_truetype \;
          runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = font.description;
        homepage = "https://github.com/ryanoasis/nerd-fonts";
        license = licenses.${font.license};
        maintainers = with maintainers; [abhinandh-s];
        platforms = platforms.all;
      };
    };
in
  # Generate a derivation for each font defined in the JSON
  #  builtins.map buildFont fontInfo.fonts

builtins.listToAttrs (map (font: {
  name = font.name;
  value = buildFont font;
}) fontInfo.fonts)

