#!/bin/bash
set -eu

##### Convenience script to mount rclone remotes to ~/rclone/remotename
##### See also rclone-browser for a convenient GUI.

##### see the following links for help setting up rclone with onedrive:
# https://docs.ccs.uky.edu/display/HPC/How+to+configure+Rclone+to+access+your+SharePoint
# https://www.linuxuprising.com/2018/07/how-to-mount-onedrive-in-linux-using.html
# https://rclone.org/commands/rclone_mount/#file-caching
# https://rclone.org/onedrive/
# https://blog.jonmassey.co.uk/posts/sharepoint-rclone/
# https://forum.rclone.org/t/rclone-cache-remote-gets-unmounted-and-cant-be-remounted-without-reboot-how-to-resolve-it/6564

###################
##### short setup instructions:
# 1) install rclone
# 2) run: rclone config
# -create a new remote
# -choose a name
# -pick mostly defaults until getting to "Use auto config?"
# -Use auto config?
# -> yes for your main onedrive
# -> no if you want to use a group/teams/sharepoint
#   For sharepoint, you can then pick "url" at the config_type question and enter a URL of the form "https://contoso.sharepoint.com/sites/mysite" or "mysite":
#     config_type> url
#     config_site_url> https://contoso.sharepoint.com/sites/mysite
# -Follow the rest of the instructions.

#####
# List available remotes:
# rclone listremotes

# Check if all parameters are present
# If no, exit
if [ $# -lt 1 ]
then
  echo "usage :"
  echo "`basename $0` REMOTE1 REMOTE2 ..."
  echo
  echo "Available remotes are:"
  rclone listremotes
  exit 0
fi

FLAGS="--daemon --vfs-cache-mode writes"

for REMOTE in "$@"
do
  REMOTE="${REMOTE%:}" # remove any trailing ":"
  MOUNTPOINT="${HOME}/rclone/${REMOTE}"
  echo "Mounting ${REMOTE} to ${MOUNTPOINT}"
  mkdir --parents "${MOUNTPOINT}"
  rclone mount "${REMOTE}:" "${MOUNTPOINT}" ${FLAGS}
done
