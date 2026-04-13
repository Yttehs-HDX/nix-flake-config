{ lib, input, scope }:
map (info:
  "Package `${info.name}` is unsupported on `${info.backend}` (${info.platform}): ${info.reason} ${info.suggestion}")
(lib.attrValues (input.unsupportedPackages.${scope} or { }))
