{pkgs ? import <nixpkgs> {}}: let
  # Load the JSON metadata
  fontInfo = pkgs.lib.trivial.importJSON ./fonts.json;

  buildFont = font:
    pkgs.stdenvNoCC.mkDerivation rec {
      pname = font.name;
      version = "1.0"; # Define version

      src = pkgs.fetchzip {
        url = font.url;
        hash = font.hash;
        stripRoot = false;
      };

      nativeBuildInputs = [pkgs.xz pkgs.unzip];

      installPhase = ''
        runHook preInstall
        mkdir -p "$out/share/fonts"
        echo "=========================================================="
        ls
        echo "=========================================================="
        dst_opentype=$out/share/fonts/opentype/${pname}
        dst_truetype=$out/share/fonts/truetype/${pname}
        find -name \*.otf -exec mkdir -p $dst_opentype \; -exec cp -p {} $dst_opentype \;
        find -name \*.ttf -exec mkdir -p $dst_truetype \; -exec cp -p {} $dst_truetype \;
        runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = font.description;
        homepage = "https://github.com/ryanoasis/nerd-fonts";
        license = licenses.${font.license};
        maintainers = [maintainers.abhinandh-s];
        platforms = platforms.all;
      };
    };
in
  builtins.listToAttrs (map (font: {
      inherit (font) name;
      value = buildFont font;
    })
    fontInfo.fonts)
