#!/bin/bash

# Ermittle das Verzeichnis, in dem das Skript liegt
# Verwende "readlink" für absolute Pfade und "dirname" für relative Pfade
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd $SCRIPT_DIR

. ./lib/functions

# Setzen Sie die gewünschten Parameter
#WATCH_DIR="/pfad/zum/zu/überwachenden/verzeichnis"
#VARS_FILE="/pfad/zum/ansible-vars-file.yml"
#PLAYBOOK="/pfad/zum/ansible-playbook.yml"

# Rufe die Funktion watch_and_run_playbook auf
watch_and_run_playbook "/git/ansible_ww_inventorys.git" "vars_inventorys_to_semaphore.yml" "push-to-server.yml"
#ansible-playbook -i inventory.yml -e "@vars_inventorys_to_semaphore.yml" push-to-server.yml
