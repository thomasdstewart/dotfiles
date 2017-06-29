# dotfiles TODO
 * branch per linux dist?
 * systemctl is-system-running needs dbus and prompt fails without it
 * rhel/centos/old ubuntu: vimrc crypt setup, old systemctl does not have is-system-running
 * smart alias for telnet=telnet or nc -v
 * ask systemctl what services are enabled and stopped (this is not ideal and buggy):
        sudo systemctl -a list-units | awk '{print $1}' | grep service | while read unit; do sudo systemctl is-enabled $unit > /dev/null 2>&1 || sudo systemctl is-active $unit > /dev/null || echo $unit; done | grep -v systemd-readahead
 * auu for yum/dnf
 * add "aptitude search ~o" to auu to show obsolete packages
 * https://github.com/Bash-it/bash-it
 * openstack tail: tail -f /var/log/nova/*log | sed -r "s/$(date +%Y-%m-%d) //g; s/[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}/ID/g; s/[0-9a-z]{32}/ID/g"
 * migrate to stow
