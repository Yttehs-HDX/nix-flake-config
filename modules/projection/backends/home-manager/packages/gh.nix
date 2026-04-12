{ definition, ... }:
{ lib, ... }:
let
  settings = builtins.removeAttrs definition.settings [
    "gitCredentialHelper"
    "hosts"
    "extensions"
  ];
in {
  programs.gh = {
    enable = true;
  } // lib.optionalAttrs (settings != { }) { inherit settings; }
    // lib.optionalAttrs (definition.settings ? gitCredentialHelper) {
      gitCredentialHelper = definition.settings.gitCredentialHelper;
    } // lib.optionalAttrs (definition.settings ? hosts) {
      hosts = definition.settings.hosts;
    } // lib.optionalAttrs (definition.settings ? extensions) {
      extensions = definition.settings.extensions;
    };
}
