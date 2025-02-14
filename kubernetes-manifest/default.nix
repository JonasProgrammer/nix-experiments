{
  manifestsJson,
  pkgs ? import <nixpkgs> { },
  ...
}:
let
  result = pkgs.lib.evalModules {
    modules = [
      (
        { config, ... }:
        {
          config._module.args = { inherit pkgs; };
        }
      )
      ./manifests.nix
      (
        { ... }:
        {
          config.manifests.raw = manifestsJson;
        }
      )
      ./filter.nix
    ];
  };
in
result.config.manifests.outputApply
