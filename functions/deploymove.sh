#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
# NOTES
# Variable recall comes from /functions/variables.sh
################################################################################
executemove () {

# Reset Front Display
rm -rf plexguide/deployed.version

# Call Variables
pgclonevars

# to remove all service running prior to ensure a clean launch
ansible-playbook /opt/pgclone/ymls/remove.yml

# gdrive deploys by standard
echo "gdrive" > /var/plexguide/deploy.version
echo "mu" > /var/plexguide/deployed.version
type=gdrive
ansible-playbook /opt/pgclone/ymls/mount.yml -e "drive=gdrive"

# deploy only if pgmove is using encryption
if [[ "$transport" == "me" ]]; then
echo "me" > /var/plexguide/deployed.version
type=gcrypt
ansible-playbook /opt/pgclone/ymls/crypt.yml -e "drive=gcrypt"; fi

# deploy union
ansible-playbook /opt/pgclone/ymls/pgunion.yml -e "\
  transport=$transport \
  type=$type
  hdpath=$hdpath"

# output final display
if [[ "$type" == "gdrive" ]]; then finaldeployoutput="PG Move - Unencrypted"
else finaldeployoutput="PG Move - Encrypted"; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 DEPLOYED: $finaldeployoutput
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

read -rp '↘️  Acknowledge Info | Press [ENTER]: ' typed < /dev/tty

EOF
}