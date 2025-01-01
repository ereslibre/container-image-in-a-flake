{
  description = "A flake to build a Docker image with a Hello World script";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    helloWorld = pkgs.writeScriptBin "hello-world" ''
      #! ${pkgs.runtimeShell}
      echo "Hello, World!"
    '';
  in {
    packages.x86_64-linux.default = pkgs.dockerTools.buildImage {
      name = "hello-world";
      tag = "latest";
      config = {
        Cmd = [ (nixpkgs.lib.getExe helloWorld) ];
      };
      copyToRoot = pkgs.buildEnv {
        name = "root";
        paths = with pkgs; [
          bashInteractive
          coreutils
        ];
      };
    };
  };
}
