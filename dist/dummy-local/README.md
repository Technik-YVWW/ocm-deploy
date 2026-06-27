# dummy-local dist package

This package provides a harmless local test action for `ocm-deploy`.

It writes a marker file to `/tmp/ocm-deploy-dummy-action.txt` when an
inotify event happens below `/tmp/ocm-deploy-watch-dummy`.

## Prerequisite

Install the base runtime first from the repository root:

```sh
sudo ./install.sh
```

The base installer creates the `/etc/ocm-deploy` directory layout, installs the
runtime scripts and library, copies bundled playbooks, copies missing skeleton
configuration files, and installs the systemd unit when systemd is available.

## Install the dummy package

From the repository root, copy only the dummy payload files:

```sh
sudo install -m 0644 dist/dummy-local/playbooks/dummy-local-marker.yml \
  /etc/ocm-deploy/playbooks/dummy-local-marker.yml
sudo install -m 0644 dist/dummy-local/playbook-vars/dummy-local.yml \
  /etc/ocm-deploy/playbook-vars/dummy-local.yml
sudo install -m 0644 dist/dummy-local/configs-available/dummy-local.conf \
  /etc/ocm-deploy/configs-available/dummy-local.conf

sudo ln -sf ../configs-available/dummy-local.conf \
  /etc/ocm-deploy/configs-enabled/dummy-local.conf
```

## Run the test

Terminal 1:

```sh
sudo mkdir -p /tmp/ocm-deploy-watch-dummy
sudo rm -f /tmp/ocm-deploy-dummy-action.txt
sudo DEPLOYCODE_RUNTIME_DIR=/tmp/ocm-deploy-runtime ocm-deploy
```

Terminal 2:

```sh
touch /tmp/ocm-deploy-watch-dummy/trigger-$(date +%s)
cat /tmp/ocm-deploy-dummy-action.txt
```

## Cleanup

```sh
sudo rm -f /etc/ocm-deploy/configs-enabled/dummy-local.conf
sudo rm -f /etc/ocm-deploy/configs-available/dummy-local.conf
sudo rm -f /etc/ocm-deploy/playbooks/dummy-local-marker.yml
sudo rm -f /etc/ocm-deploy/playbook-vars/dummy-local.yml
sudo rm -rf /tmp/ocm-deploy-watch-dummy
sudo rm -rf /tmp/ocm-deploy-runtime
sudo rm -f /tmp/ocm-deploy-dummy-action.txt
```
