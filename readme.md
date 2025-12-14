# Impure Nix templates

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

## uv (Python) (without Cuda)

```sh
nix flake init --template github:Richienb/impure#uv
```
