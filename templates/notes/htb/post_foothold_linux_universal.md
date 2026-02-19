## Post-Foothold Linux (Universal)

> Goal: move from initial code execution to stable shell, local privilege escalation, and high-value loot collection.

### 0) Shell stabilization

```bash
python3 -c 'import pty; pty.spawn("/bin/bash")'
export TERM=xterm-256color
stty rows 40 cols 140
```

### 1) Fast situational awareness

```bash
id
uname -a
cat /etc/os-release
hostname
ip a
ss -lntup
ps aux --sort=-%mem | head
ps aux --sort=-%cpu | head
```

Notes:

* current user/context:
* high-value local services:
* unusual processes:

### 2) Service context check

```bash
ps aux | grep -Ei '<service-name>|<process-name>' | head -n 50
systemctl status '<service-name>*' 2>/dev/null
systemctl list-units --type=service | grep -Ei '<service-name>|<process-name>'
```

If systemd unit exists, inspect service files:

```bash
systemctl cat '<service-name>*' 2>/dev/null
ls -la /etc/systemd/system | grep -Ei '<service-name>|<process-name>'
ls -la /lib/systemd/system | grep -Ei '<service-name>|<process-name>'
```

Look for:

* writable unit files/scripts/env files
* root-owned services consuming writable files
* credential material in service arguments or env files

### 3) Config/data/credential hunt

```bash
sudo -n true 2>/dev/null; echo "sudo_nopass:$?"
ls -la /opt /usr/local /srv 2>/dev/null
find / -maxdepth 4 -type d -iname '*config*' -o -iname '*data*' 2>/dev/null
find / -maxdepth 5 -type f -iname '*.xml' -o -iname '*.db' -o -iname '*.sqlite*' -o -iname '*.env' 2>/dev/null
```

For interesting directories:

```bash
ls -la <dir>
find <dir> -type f -writable 2>/dev/null
```

Loot:

* credentials/password reuse candidates:
* tokens/keys:
* scripts/jobs consumed by privileged contexts:

### 4) Privilege escalation quick checks

#### sudo

```bash
sudo -l
```

#### SUID / SGID

```bash
find / -perm -4000 -type f 2>/dev/null
find / -perm -2000 -type f 2>/dev/null
```

#### Capabilities

```bash
getcap -r / 2>/dev/null
```

#### Cron / timers

```bash
ls -la /etc/cron* /var/spool/cron 2>/dev/null
systemctl list-timers --all 2>/dev/null | head -n 50
```

#### Writable paths in privileged contexts

```bash
env | grep -E 'PATH|LD_|PYTHONPATH'
find /etc -type f -writable 2>/dev/null | head
find /var -type f -writable 2>/dev/null | head
```

### 5) Group/permission edge cases

```bash
id
getent group | grep -E '<group1>|<group2>'
ls -la /dev | head
ls -la /dev/net/tun 2>/dev/null
getfacl -R /dev 2>/dev/null | head -n 50
```

Notes:

* risky group memberships:
* sensitive readable devices/files:
* controllable privileged interfaces:

### 6) Internal-only surface

```bash
ss -lntup
curl -sS http://127.0.0.1:<port>/ | head
```

Notes:

* localhost-only admin services:
* potential pivot/tunnel targets:

### 7) Evidence collection

Keep command logs and proof artifacts:

* `notes/` command transcript snippets
* `loot/` configs, creds, hashes
* `screens/` proof of foothold/privesc context

