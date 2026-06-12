# TODO

## Before merging `rename-ocm-deploy`

- Run `sh ./check-shell.sh` on a development machine with `shellcheck` and `shfmt` installed.
- Run `sudo ./install.sh` in a disposable Debian test system and validate `systemctl enable --now ocm-deploy`.
- Add one real enabled test config and verify service restart behavior after a filesystem event.
- Rename the local repository folder to `ocm-deploy` after checking out the renamed branch.
- Rename the GitHub repository from `deploycode_inotify_ansible` to `ocm-deploy` after validation and merge.

## Runtime hardening backlog

- Add an integration test that starts two enabled configs in parallel and verifies isolated locks and temporary inventories.
- Decide whether background watcher failure should stop the complete service. The current architecture keeps independent watcher processes alive while one foreground watcher owns the systemd service lifecycle.
- Add optional structured logging or journald-friendly prefixes for config name and playbook index.
- Add `ansible-lint` checks for maintained playbooks. Several existing playbooks are legacy payloads and should be modernized separately from the generic runtime.

## Planned first payload extension

- Add an idempotent directed path-sync playbook and vars file for:

  ```text
  /boot    -> /efi -> /efi2
  /rescue1 -> /rescue2
  ```

- Include locking, verify mode, and explicit source-to-target direction in that payload. Keep the generic `ocm-deploy` runtime independent from Servermoench-specific policy.
