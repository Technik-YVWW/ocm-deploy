# Runtime modernization patches

These patches cover changes that could not be written directly through the connector safety filter. Apply them locally from the repository root after checking out `modernize-runtime`.

## Apply order

```sh
git apply --check patches/libDeploy-count-folder-files.patch
git apply --check patches/deploycode-test-modernization.patch
git apply --check patches/install-modernization.patch

git apply patches/libDeploy-count-folder-files.patch
git apply patches/deploycode-test-modernization.patch
git apply patches/install-modernization.patch
```

## Validate afterwards

```sh
dash -n deploycode
dash -n deploycode-test
dash -n install.sh
dash -n usr/lib/libDeploy

bash -n deploycode
bash -n deploycode-test
bash -n install.sh
bash -n usr/lib/libDeploy
```

When available, additionally run:

```sh
shellcheck deploycode deploycode-test install.sh usr/lib/libDeploy
shfmt -d deploycode deploycode-test install.sh usr/lib/libDeploy
```

## Patch scope

- `libDeploy-count-folder-files.patch`
  - replaces the old `find -type "f,l"` helper with robust glob-based counting
  - handles empty folders correctly

- `deploycode-test-modernization.patch`
  - adds development-folder fallbacks for vars and configs
  - returns non-zero status codes for missing prerequisites
  - quotes the config-folder listing

- `install-modernization.patch`
  - enables `set -eu`
  - installs files with explicit modes
  - reloads systemd after installing the unit
