{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  # 临时覆盖：nixos-unstable 仍停在 QQ 3.2.34，而腾讯已下架该 deb（URL 404）。
  # 数据取自 nixpkgs master 的 pkgs/by-name/qq/qq/sources.nix（x86_64-linux）。
  # 等 nixos-unstable 更新到 >= 3.2.35 后，删掉这段并恢复 `unstable.qq`。
  qqVersion = "3.2.35-2026-11-03";
  qqUrl = "https://qqdl.gtimg.cn/qqfile/QQNTV2/9.9.37/release/816b3c79/QQ_3.2.35_261103_amd64_01.deb";
  qqHash = "sha256-feA4YjJ6u9FtonEwQTaYyVF3grJxlK/Fk7w6v5tV+aw=";

  qqSrc = unstable.runCommandLocal "QQ_3.2.35_261103_amd64_01.deb" {
    outputHash = qqHash;
    outputHashMode = "flat";
    nativeBuildInputs = [
      unstable.curl
      unstable.jq
      unstable.cacert
    ];
  } ''
    signedUrl=$(
      curl -fsS --retry 3 -X POST "https://im.qq.com/http2rpc/gotrpc/noauth/trpc.qqntv2.urlsign.UrlSign/GetSign" \
        -H "Content-Type: application/json" \
        -H 'x-oidb: {"uint32_command":"0x9b8e","uint32_service_type":1}' \
        -d "{\"url\":\"${qqUrl}\"}" | jq -er '.data.url'
    )
    curl -fL --retry 3 -o "$out" "$signedUrl"
  '';

  qq = unstable.qq.overrideAttrs (_: {
    version = qqVersion;
    src = qqSrc;
  });
in
{
  home.packages = [ qq ];
}
