# dotfiles TODO
 * branch per linux dist?
 * systemctl is-system-running needs dbus and prompt fails without it
 * smart alias for telnet=telnet or nc -v
 * ask systemctl what services are enabled and stopped (this is not ideal and buggy):
        sudo systemctl -a list-units | awk '{print $1}' | grep service | while read unit; do sudo systemctl is-enabled $unit > /dev/null 2>&1 || sudo systemctl is-active $unit > /dev/null || echo $unit; done | grep -v systemd-readahead
 * auu for yum/dnf
 * tomstatus reboot required
 * https://cfenollosa.com/misc/tricks.txt
 * https://github.com/Bash-it/bash-it
 * openstack tail: tail -f /var/log/nova/*log | sed -r "s/$(date +%Y-%m-%d) //g; s/[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}/ID/g; s/[0-9a-z]{32}/ID/g"
 * migrate to stow
 * alias ssl='sudo ss -H -A inet -ln -p | column -t'
 #https://www.citusdata.com/blog/2019/07/17/postgres-tips-for-average-and-power-user/
