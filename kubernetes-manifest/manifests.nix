{ lib, config, ... }:
with lib;
with builtins;
let
  rewriteType = mkOptionType {
    name = "manifest-rewrite";
    description = "A functor rewriting a manifest attrset -> attrset.";
    check = isFunction;
  };

  top = config.manifests;
in
{
  options.manifests = {
    raw = mkOption {
      description = "Raw JSON(s) of the manifests, as a list";
      type = with types; either str (listOf str);
      default = [ ];
      apply = v: if isList v then v else [ v ];
    };
    output = mkOption {
      description = "Final manifests";
      type = with types; listOf (attrsOf anything);
      default = [ ];
    };
    outputApply = mkOption {
      description = "Pseudo-YAML, that can be passed to kubectl apply";
      type = types.str;
    };
    rewrites = mkOption {
      description = "Final manifests";
      type = with types; listOf rewriteType;
      default = [ ];
      apply = v: if isList v then v else [ v ];
    };
  };

  config.manifests = {
    output = lists.concatMap (r: map (o: lists.foldl (v: f: f v) o top.rewrites) (fromJSON r)) top.raw;
    outputApply = "---\n" + (concatStringsSep "\n---\n" (map (v: toJSON v) top.output));
  };
}
