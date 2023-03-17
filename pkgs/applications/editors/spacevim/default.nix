{ ripgrep
, git
, fzf
, makeWrapper
, vim
, neovim-unwrapped
, vimPlugins
, fetchFromGitHub
, lib
, stdenv
, formats
, runCommand
, spacevim_config ? import ./init.nix
}:

let
  format = formats.toml { };
  vim-customized = neovim-unwrapped;
  spacevimdir = runCommand "SpaceVim.d" { } ''
    mkdir -p $out
    cp ${format.generate "init.toml" spacevim_config} $out/init.toml
  '';
in
stdenv.mkDerivation rec {
  pname = "spacevim";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "SpaceVim";
    repo = "SpaceVim";
    rev = "v${version}";
    # 2.0.0
    sha256 = "sha256-a5HzjqwCg0b/c5wONOk+5QUzs/LS5N+Pb9hQBTwjhXs=";
  };

  nativeBuildInputs = [ makeWrapper vim-customized ];
  buildInputs = [ vim-customized ];

  buildPhase = ''
    runHook preBuild
    # generate the helptags
    export HOME=$(pwd)
    nvim -u NONE -c "helptags $(pwd)/doc" -c q
    runHook postBuild
  '';

  patches = [
    # Don't generate helptags at runtime into read-only $SPACEVIMDIR
    ./helptags.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    cp -r $(pwd) $out/SpaceVim
    echo "${spacevimdir}/"
    # trailing slash very important for SPACEVIMDIR
    makeWrapper "${vim-customized}/bin/nvim" "$out/bin/spacevim" \
        --set PATH ${lib.makeBinPath [ fzf git ripgrep]} \
        --add-flags "-u $out/SpaceVim/vimrc" --set SPACEVIMDIR "${spacevimdir}/"
    runHook postInstall
  '';
  
  meta = with lib; {
    description = "Modern Vim distribution";
    longDescription = ''
      SpaceVim is a distribution of the Vim editor that’s inspired by spacemacs.
    '';
    homepage = "https://spacevim.org/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.fzakaria ];
    platforms = platforms.all;
  };
}
