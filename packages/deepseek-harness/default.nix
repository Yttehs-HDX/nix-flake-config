{
  lib,
  buildNpmPackage,
  makeWrapper,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}:

let
  # The native require-builtin loader probes Node's private machine-code layout.
  # It supports the official binary, but fails with nixpkgs' compiled Node.
  runtime = stdenvNoCC.mkDerivation {
    pname = "deepseek-harness-nodejs";
    version = "24.22.1";
    src = fetchurl {
      url = "https://nodejs.org/dist/v24.22.1/node-v24.22.1-linux-x64.tar.xz";
      hash = "sha256-bBcqmrZxj3uAH7WnvUhq8u5eMnWAhqBLhPzOKqdwleY=";
    };
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib ];
    installPhase = ''
      runHook preInstall
      install -Dm755 bin/node $out/bin/node
      install -Dm644 LICENSE $out/share/licenses/nodejs/LICENSE
      runHook postInstall
    '';
    dontStrip = true;
    meta.platforms = [ "x86_64-linux" ];
  };
in
buildNpmPackage {
  pname = "deepseek-harness";
  version = "0.2.1-rc.2";
  src = ./.;

  npmDepsHash = "sha256-wxf3IA/UJQPQuRI8/REgpGE/8SG623p415uDy+ujqnk=";
  dontNpmBuild = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/deepseek-harness $out/bin
    cp -r node_modules $out/lib/deepseek-harness/
    makeWrapper ${runtime}/bin/node $out/bin/dsh \
      --add-flags "$out/lib/deepseek-harness/node_modules/@deepseek-ai/dsh/lib/bin.js"
    runHook postInstall
  '';

  meta = {
    description = "DeepSeek's plugin-based agent harness";
    homepage = "https://github.com/deepseek-ai/deepseek-harness";
    license = lib.licenses.mit;
    mainProgram = "dsh";
    platforms = [ "x86_64-linux" ];
  };
}
