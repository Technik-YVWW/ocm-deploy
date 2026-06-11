# deploycode_inotify_ansible

Deploy Code automatic over inotify and Ansible to Other Servers/Devices, etc.

The project is intentionally broad: a filesystem event selects one or more Ansible playbooks, and the playbooks may act locally or remotely.

```text
inotify event
-> debounce
-> enabled config
-> ordered Ansible playbook chain
-> local or remote target
```

## Requirements

- GNU find
- yq
- inotifywait (`inotify-tools` on Debian)
- ansible-core or full ansible
- flock (`util-linux` on Debian)

## Runtime modernization

The `modernize-runtime` branch keeps the architecture intact and hardens the existing implementation in small steps:

- runtime state below `/run/deploycode` instead of `/tmp/deploycode`
- proper non-zero error codes
- `command -v` instead of `which`
- per-config locking with `flock`
- cleaner systemd runtime handling
- preserved local and remote Ansible execution

The first planned production use case after modernization is directed Servermoench boot-media synchronization:

```text
/boot    -> /efi -> /efi2
/rescue1 -> /rescue2
```
