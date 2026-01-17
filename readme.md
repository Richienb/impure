# Impure Nix templates

Create mutable project-specific containers for easy programming on Nix.

## uv (Python) with Cuda

To initialize environment (run inside project folder):

```sh
nix flake init --template github:Richienb/impure#uv-cuda
```

You might need to run `direnv allow` so that the environment loads automatically.

Then, you can initialise your project as normal if you haven't already:

```sh
uv init
```

But, if you already have a `requirements.txt` file, you can install your dependencies with `uv pip install -r requirements.txt`, or migrate to `pyproject.toml`:

```sh
uv init --bare
uv add -r requirements.txt
```

## uv (Python) (without Cuda)

```sh
nix flake init --template github:Richienb/impure#uv
```
