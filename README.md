# deploycode

`deploycode` watches configured filesystem paths and runs ordered Ansible playbook chains after a change. The playbooks may act locally or remotely.

```text
filesystem event
-> debounce
-> enabled config
-> per-config lock
-> ordered Ansible playbook chain
-> local or remote target
```

The runtime command remains `/usr/bin/deploycode`. The existing repository name `deploycode_inotify_ansible` can be shortened to `deploycode` after the modernization branch is merged; renaming the installed command is unnecessary and would only create avoidable migration work.

## Requirements

Runtime tools:

- `ansible-playbook` (`ansible-core` or full `ansible`)
- `inotifywait` (`inotify-tools` on Debian)
- `flock` (`util-linux` on Debian)
- `pkill` (`procps` on Debian)
- `realpath` (`coreutils` on Debian)

The installer additionally uses standard tools such as `install`, `readlink`, `dirname`, and `basename`.

## Install

```sh
sudo ./install.sh
```

The installer creates the `/etc/deploycode` directory structure, installs the runtime scripts and library, installs the systemd unit, and copies missing skeleton files without overwriting local configuration.

## Configuration layout

```text
/etc/deploycode/
├── configs-available/
├── configs-enabled/
├── playbooks/
├── playbook-vars/
└── roles/
```

Create a config from the installed skeleton:

```sh
sudo cp /etc/deploycode/configs-available/_skeleton.conf \
  /etc/deploycode/configs-available/example.conf
sudo editor /etc/deploycode/configs-available/example.conf
sudo ln -s ../configs-available/example.conf \
  /etc/deploycode/configs-enabled/example.conf
```

A config defines one watch directory and a consecutive, ordered playbook chain:

```text
inotify_watchdir:/srv/git/example.git
playbook1:git-pull
vars_playbook1:example
playbook2:test-ping
vars_playbook2:example
```

Each `playbookN` requires a matching `vars_playbookN`. Numbering must remain consecutive. The referenced vars file must contain a top-level `target_server` value because `deploycode` creates a temporary Ansible inventory for each playbook execution.

## Validate a config once

Before enabling the long-running watcher, execute a config directly:

```sh
sudo deploycode-test example
```

For development directly from the repository root:

```sh
sh ./deploycode-test _skeleton
```

The test command uses `/tmp/deploycode-test` for transient state unless `DEPLOYCODE_RUNTIME_DIR` is explicitly set.

## Enable the service

```sh
sudo systemctl enable --now deploycode-inotify
```

Runtime state is stored below `/run/deploycode`:

```text
/run/deploycode/
├── inv/
├── locks/
└── pids/
```

A separate `flock` lock exists for each enabled config. This prevents duplicate concurrent runs of the same chain while allowing independent configs to run in parallel.

## Runtime semantics

- A watcher reacts to `modify`, `create`, `delete`, and `move` events below its configured directory.
- Events are debounced for five seconds by default. Override this with `DEPLOYCODE_DEBOUNCE_SECONDS`.
- The watcher runs the configured chain after a filesystem event. It does **not** perform an automatic initial deployment merely because the service starts.
- Use `deploycode-test <config>` for an explicit one-shot execution and validation.

## Development checks

```sh
sh ./check-shell.sh
```

The script always runs `dash -n` and `bash -n`. It additionally runs `shellcheck` and `shfmt -d` when those tools are installed.

## Planned first extension

The first planned production extension is a directed local path-sync playbook for the Servermoench boot and rescue media:

```text
/boot    -> /efi -> /efi2
/rescue1 -> /rescue2
```

That sync logic belongs in a dedicated idempotent playbook and vars file. The generic event runner should remain independent from the concrete synchronization policy.
