#!/bin/sh

# Ermittle das Verzeichnis, in dem das Skript liegt
# Verwende "readlink" für absolute Pfade und "dirname" für relative Pfade
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd $SCRIPT_DIR

. ./lib/functions

#watch_and_run_playbook:
#$1:WATCH_DIR="/pfad/zum/zu/überwachenden/verzeichnis"
#$2: VARS_FILE="/pfad/zum/ansible-vars-file.yml"
#$3: PLAYBOOK="/pfad/zum/ansible-playbook.yml"

watch_and_run_playbook "/git/ansible_ww_inventorys.git" "vars_inventorys_to_semaphore.yml" "push-to-server.yml"
