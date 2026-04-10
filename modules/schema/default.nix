{ lib }: {
  softwareItemType = lib.types.submodule (import ./options/software-item.nix);
  userType = lib.types.submodule (import ./options/users.nix);
  hostType = lib.types.submodule (import ./options/hosts.nix);
  relationType = lib.types.submodule (import ./options/relations.nix);
}
