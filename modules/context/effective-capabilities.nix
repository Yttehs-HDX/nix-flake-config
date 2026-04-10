{ current }:
let
  resolve = requested: allowed: hostAllowed:
    if requested == null then
      allowed && hostAllowed
    else
      requested && allowed && hostAllowed;
in {
  desktop.enable = resolve current.relation.activation.desktop.enable current.user.capabilities.desktop.enable current.host.capabilities.desktop.enable;
  development.enable = resolve current.relation.activation.development.enable current.user.capabilities.development.enable true;
  theme.enable = resolve current.relation.activation.theme.enable current.user.capabilities.theme.enable true;
}
