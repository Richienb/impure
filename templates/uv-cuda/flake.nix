{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
            	allowUnfree = true;
            };
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              python3
              uv
              cudatoolkit
            ];

            env = lib.optionalAttrs pkgs.stdenv.isLinux {
								LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath (
									[
										# CUDA shared libraries
										# config.hardware.opengl.package
										(if pkgs.stdenv.hostPlatform.is32bit
											then "/run/opengl-driver-32"
											else "/run/opengl-driver"
										)
										cudatoolkit
									]
									# Python libraries often load native shared objects using dlopen(3).
									# Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
									++ pythonManylinuxPackages.manylinux1
								);
            };

            shellHook = ''
              unset PYTHONPATH
              uv sync
              . .venv/bin/activate
            '';
          };
        }
      );
    };
}
