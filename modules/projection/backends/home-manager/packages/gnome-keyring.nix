{ input, ... }:
{ ... }:
throw
"Package `gnome-keyring` requires NixOS-side integration and is unsupported on `${input.backend.type}` backends."
