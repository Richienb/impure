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
					cxxRuntime = if pkgs.stdenv.isLinux then pkgs.gcc.cc.lib else pkgs.libcxx;
				in
				{
					default = pkgs.mkShell {
						packages = with pkgs; [
							python3
							uv
							cudatoolkit
							cxxRuntime
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
								);
						};

						shellHook = ''
							unset PYTHONPATH
							# Python libraries often load native shared objects using dlopen(3).
							# Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
							export LD_LIBRARY_PATH="${cxxRuntime}/lib:${pkgs.zlib}/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
							uv sync
							. .venv/bin/activate
						'';
					};
				}
			);
		};
}
