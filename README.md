# Backup home with restic

files need to be copied to the appropriate locations
configure restic environment files as required

restic environment files 
   ~/.config/restic/

systemd timer files 
  ~/.config/systemd/user/

enable timer
`systemctl --user enable --now backup`

Logs to systemd and /var/log/restic.log
