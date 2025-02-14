{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    jetbrains.goland
    nixfmt-rfc-style
    yq-go
    jq
  ];
}
