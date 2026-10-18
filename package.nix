{ appimageTools, fetchurl, lib }:
let
  pname = "rootapp";
  version = "0.9.147";
  src = fetchurl {
    url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
    hash = "sha256-6Sy5bgylIntzlGp+GBwRzj9Lp/LnK4ZKhLoDhBBl3dY=";
  };
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/Root.desktop $out/share/applications/rootapp.desktop
    substituteInPlace $out/share/applications/rootapp.desktop \
      --replace 'Exec=Root' 'Exec=rootapp %u' \
      --replace 'Icon=Root' 'Icon=rootapp'
    grep -q '^MimeType=' $out/share/applications/rootapp.desktop || printf '\nMimeType=x-scheme-handler/rootapp;\n' >> $out/share/applications/rootapp.desktop
    mkdir -p $out/share/icons/hicolor/512x512/apps $out/share/pixmaps
    cp ${appimageContents}/Root.png $out/share/icons/hicolor/512x512/apps/rootapp.png
    cp ${appimageContents}/Root.png $out/share/pixmaps/rootapp.png
    chmod -R u+w $out/share/icons
  '';
  meta = {
    description = "Root messaging platform packaged from the official upstream AppImage";
    longDescription = "Voice, video, and chat plus powerful apps for communities. Packaged from the official Linux AppImage so it runs on NixOS and other Nix setups.";
    homepage = "https://www.rootapp.com";
    downloadPage = "https://www.rootapp.com/download";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "rootapp";
    maintainers = [ ];
  };
}
