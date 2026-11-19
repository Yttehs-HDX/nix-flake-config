{ pkgs, inputs, ... }:

let
  hermes = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # The Honcho plugin (plastic-labs/honcho, hermes-plugin-honcho 1.2.0) needs
  # honcho-ai>=2.2,<3. The Nix install's venv is sealed, so plugin deps are
  # supplied through the upstream `extraPythonPackages` hook, which appends
  # them to the wrapped commands' PYTHONPATH (and fails the build on a
  # collision with a core dependency).
  #
  # Built against `hermes.python` — not our own nixpkgs python — because
  # `requiredPythonModules` only keeps modules whose `pythonModule` is that
  # exact interpreter. `propagatedBuildInputs` stays empty: httpx and pydantic
  # are already in Hermes' venv, and re-adding them would trip the collision
  # check.
  honcho-ai = hermes.python.pkgs.buildPythonPackage {
    pname = "honcho-ai";
    version = "2.2.0";
    format = "wheel";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/d0/c6/66af5f7ba3d75796f4523eac1e069fbdc759c3f0b8adab9fb7ae04e15784/honcho_ai-2.2.0-py3-none-any.whl";
      hash = "sha256-MvCYpMi8/kKI8JlN2rC8UqaNyHBp0PLOLIdY7ioXYfI=";
    };
    propagatedBuildInputs = [ ];
    doCheck = false;
    # httpx/pydantic arrive from Hermes' venv at runtime; declaring them here
    # would pull them into extraPythonPackages and fail the collision check.
    dontCheckRuntimeDeps = true;
  };
in
{
  home.packages = [ (hermes.override { extraPythonPackages = [ honcho-ai ]; }) ];
}
