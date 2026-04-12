{ input }:
let
  registry = {
    docker = [ "docker" ];
    virt-manager = [ "libvirtd" ];
    wireshark = [ "wireshark" ];
  };
in builtins.concatLists (map (packageId: registry.${packageId} or [ ])
  (builtins.attrNames input.packages.system))
