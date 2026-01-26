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
					};
					cxxRuntime = if pkgs.stdenv.isLinux then pkgs.gcc.cc.lib else pkgs.libcxx;
				in
				{
					default = pkgs.mkShell {
						packages = with pkgs; [
							python3
							uv
							cxxRuntime
						];

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
