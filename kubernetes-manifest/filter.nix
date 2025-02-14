{ lib, ... }:
let
  inherit (lib) recursiveUpdate;

  rewriteStringImpl = (
    from: to: self: value:
    let
      actions = {
        "set" = lib.mapAttrs (_: v: self v);
        "list" = builtins.map (v: self v);
        "string" = builtins.replaceStrings [ from ] [ to ];
      };
    in
    (lib.attrByPath [ (builtins.typeOf value) ] (v: v) actions) value
  );

  rewriteString = from: to: (lib.fix (rewriteStringImpl from to));
in
{
  manifests.rewrites = [
    (rewriteString "/var/lib/kubelet" "/var/lib/kubernetes")
    (rewriteString "gcr.io/cloud-provider-vsphere/csi/release" "registry.k8s.io/csi-vsphere")
  ];
}
