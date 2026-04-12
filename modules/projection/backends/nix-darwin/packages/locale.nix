{ ... }:
{ ... }: {
  time.timeZone = "Asia/Taipei";

  environment.variables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  system.defaults.NSGlobalDomain = {
    AppleMetricUnits = 1;
    AppleICUForce24HourTime = true;
  };

  warnings = [
    "Package `locale` on nix-darwin currently projects timezone, POSIX locale environment variables, and a subset of NSGlobalDomain locale defaults. AppleLocale and AppleLanguages still need manual macOS configuration if required."
  ];
}
