---
tags:
- hackthebox
- htb
- machine
- release-arena
---

[Back](Release-Arena.md)

# <machine-name>

## Status

* state: not started # not started | recon | foothold | privesc | post | complete
* platform: HackTheBox
* season: <season>
* arena: Release Arena
* difficulty: <unknown>
* started: <YYYY-MM-DD>
* last-updated: <YYYY-MM-DD>
* time-spent: <hh:mm>
* rating: <1-10>
* summary: <one-liner of what this box teaches>
* win-conditions:

  * user-flag: pending
  * root-flag: pending

---

## Scope

* target:

  * primary: <ip-or-url>
  * hostname(s): <add-to-hosts-if-needed>
  * notes: <NAT/VPN quirks, resets, instability>
* credentials:

  * initial: <user> / <pass>
  * discovered:

    * <service>: <user> / <pass or hash>
* constraints:

  * out-of-scope: <anything explicitly disallowed>
  * “noisy” actions: <rate limits, lockouts, WAF, etc>
* assumptions:

  * os: <unknown>
  * likely services: <guess after quick scan>

---

## Objectives

* Identify exposed services and attack surface
* Obtain foothold (user)
* Escalate privileges (root/system)
* Document:

  * entry vector + privesc vector
  * key artifacts (configs, creds, hashes)
  * reproducible steps + commands
  * flags + proof screenshots/outputs

---

## Workspace

* dirs:

  * `scans/`
  * `loot/`
  * `notes/`
  * `screens/`
* hosts entry:

  * `\<ip>  \<hostname>`
* session tracking:

  * vpn: connected
  * local-ip: <your tun0>
  * timestamps:

    * recon start: <time>
    * foothold: <time>
    * privesc: <time>

---

## Recon

### 0) Fast discovery

```bash
ping -c 1 <ip>
nmap -Pn -p- --min-rate 10000 -oX scans/nmap_full_tcp.xml <ip>
```

### 1) Targeted scan

```bash
nmap -Pn -sC -sV -p <ports> -oX scans/nmap_targeted.xml <ip>
```

### 2) UDP (only if needed)

```bash
sudo nmap -Pn -sU --top-ports 200 -oX scans/nmap_udp_top.xml <ip>
```

### Notes

* open ports: <list>
* service fingerprinting surprises:
* possible vulns (initial guesses):
* weird banners / headers:

---

## Enumeration

> Use this section as a **living checklist**. When you find something, paste the exact command + output snippet and link it to the next step.

### Web (HTTP/HTTPS)

* targets:

  * `http://<ip>:<port>/`
  * `https://<ip>:<port>/`
  * vhosts: <found?>
* quick info:

  * tech stack: <server, framework, CMS, headers>
  * auth: <none/basic/form/sso>
  * robots/sitemap: <notes>
  * interesting endpoints: <notes>

**Commands**

```bash
whatweb http://<ip>:<port>/
curl -i http://<ip>:<port>/
nikto -h http://<ip>:<port>/
```

**Content discovery**

```bash
ffuf -u http://<ip>:<port>/FUZZ -w /usr/share/wordlists/dirb/common.txt -fc 404
ffuf -u http://<ip>:<port>/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -fc 404
```

**VHost fuzz (if hostname hinted)**

```bash
ffuf -u http://<ip>/ -H "Host: FUZZ.<domain>" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt -fs <size>
```

**App notes**

* parameters:
* file upload points:
* JWT/session/cookies:
* error leaks / stack traces:
* creds discovered:
* RCE path hypothesis:

---

### SMB

* shares: <list>
* anonymous access: <yes/no>
* creds used:

**Commands**

```bash
smbclient -L //<ip>/ -N
crackmapexec smb <ip>
crackmapexec smb <ip> -u '<user>' -p '<pass>' --shares
smbmap -H <ip> -u '<user>' -p '<pass>'
```

**Loot / notes**

* interesting files:
* password reuse candidates:
* writable locations:

---

### LDAP / AD (if applicable)

* domain: <domain>
* dc: <ip/hostname>
* users/groups found:

**Commands**

```bash
ldapsearch -x -H ldap://<ip> -s base
# if you have creds:
ldapsearch -x -H ldap://<ip> -D '<user>@<domain>' -w '<pass>' -b 'DC=<a>,DC=<b>'
```

**Notes**

* kerberoastable:
* ASREPRoastable:
* ACL weirdness:
* GPO/SYSVOL:

---

### SSH

* auth methods: <password/key>
* banner:
* reachable users:

**Commands**

```bash
ssh -v <user>@<ip>
```

Notes:

* key files found:
* forced command / restricted shell:

---

### FTP

* anonymous: <yes/no>
* writable: <yes/no>

```bash
ftp <ip>
# or
nmap --script ftp-anon,ftp-syst -p21 <ip>
```

---

### DNS

* zone transfer possible: <yes/no>
* records:

```bash
dig @<ip> <domain> ANY
dig axfr @<ip> <domain>
```

---

### Databases (MySQL/Postgres/MSSQL)

* ports:
* creds:
* useful tables:

```bash
# MySQL
mysql -h <ip> -u <user> -p
# Postgres
psql -h <ip> -U <user>
# MSSQL
impacket-mssqlclient <user>:<pass>@<ip>
```

---

### “Other” Services

* <service>: <notes + commands>
* <service>: <notes + commands>

---

## Vulnerability Hypotheses

> Write down theories *before* you brute-force or go deep. Keeps you honest.

* hypothesis 1: <e.g., web login → SQLi → creds>

  * evidence:
  * test:
  * result:
* hypothesis 2:

  * evidence:
  * test:
  * result:

---

## Foothold

### Vector

* entry point: <service/endpoint>
* vuln class: <e.g., LFI, deserialization, misconfig, creds reuse>
* access obtained: <shell type + user>

### Steps (reproducible)

1. <step>
2. <step>
3. <step>

### Commands / Payload log

```bash
# paste exact commands used
```

### Stabilization / Upgrade

* shell: <nc/bash/powershell>
* tty upgrade:

```bash
python3 -c 'import pty; pty.spawn("/bin/bash")'
export TERM=xterm-256color
stty rows 40 columns 160
```

* persistence used (if any, and if allowed by scope): <notes>

### Proof

* user flag:

```text
<flag>
```

* evidence:

  * `screens/<timestamp>-user.png` (optional)
  * relevant command output snippet

---

## Post-Foothold Enumeration

### Host basics

```bash
id
whoami
uname -a
cat /etc/os-release
ip a
ss -lntup
ps aux
```

Notes:

* internal services:
* interesting users:
* cron/systemd jobs:
* mounted shares:

### Credential hunting

```bash
# common greps
grep -Rni "pass\|password\|token\|secret\|key" /etc /opt /var/www 2>/dev/null
find / -name "*.env" -o -name "config*.php" -o -name "settings*.py" 2>/dev/null
```

Loot:

* files:
* creds:
* hashes:

---

## Privilege Escalation

### Vector

* class: <sudo misconfig, SUID, kernel, service abuse, creds>
* target: root/system

### Quick checks (Linux)

```bash
sudo -l
id
getcap -r / 2>/dev/null
find / -perm -4000 -type f 2>/dev/null
cat /etc/crontab
ls -la /etc/cron* /var/spool/cron 2>/dev/null
```

### Quick checks (Windows)

```powershell
whoami /all
systeminfo
ipconfig /all
net user
net localgroup administrators
```

### Steps (reproducible)

1. <step>
2. <step>
3. <step>

### Commands / Payload log

```bash
# exact commands used for privesc
```

### Proof

* root/system flag:

```text
<flag>
```

* evidence:

  * `screens/<timestamp>-root.png` (optional)
  * output snippet showing elevated context (`id`, `whoami`)

---

## Artifacts

### Files

* `loot/<file>` — <why it matters>
* `loot/<file>` — <why it matters>

### Hashes / creds

* <user>: <hash>
* <service>: <token/api key>

### Indicators / Notes

* exploited endpoint(s):
* vulnerable versions:
* misconfig summary:

---

## Timeline

* <time> — started recon
* <time> — discovered <thing>
* <time> — foothold achieved as <user>
* <time> — privesc achieved via <vector>
* <time> — completed

---

## Lessons Learned

* What fooled me:
* What paid off:
* New technique / command to remember:
* “Next time I should…”:

---

## References

* <link>
* <link>
* <notes about relevant docs/blogs/tools>

---
