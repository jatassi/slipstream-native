# slipstream-native
Prebuilt, content-addressed native bundles (toolchains, libtorrent-rasterbar, OpenSSL, boost) for SlipStream v2's release build.

Each layer is the single asset of its own release, tagged `layer-<digest>`. The digest covers the layer's inputs and recipe in SlipStream, so a published layer never changes. These are prereleases and never "latest", so nothing treats them as SlipStream releases.

## Bumping a native input

1. In a SlipStream PR, edit `native/inputs.json` or `native/recipe/`.
2. Dispatch [layers.yml](.github/workflows/layers.yml) at the PR's head: `gh workflow run layers.yml -R jatassi/slipstream-native -f ref=<branch-or-sha>`. It builds and publishes every layer the inputs list that has no release yet: the toolchain layers first, then the libs layers, each compiled with its target's published toolchain layer.
3. In the SlipStream checkout, run `scripts/native-deps pin`. It downloads each published asset, hashes it and writes `native/lock.json`.
4. Commit `native/lock.json`. Lint fails any PR whose lock no longer matches its inputs and recipe.
