## Recon

```bash
# fast all-ports
nmap -Pn -p- --min-rate 10000 -oX scans/nmap_full_tcp.xml <ip>

# targeted follow-up
nmap -Pn -sC -sV -p <ports> -oX scans/nmap_targeted.xml <ip>
```

## nmap

### Full TCP port scan (fast)

```bash
nmap -p- -T4 --min-rate 1000 <ip> -oX scans/nmap_full_tcp.xml
```

### Default scripts + version detection

```bash
nmap -sC -sV <ip> -oX scans/nmap_default.xml
```

### Aggressive scan

```bash
nmap -A <ip> -oX scans/nmap_aggressive.xml
```

### UDP top ports

```bash
nmap -sU --top-ports 100 <ip> -oX scans/nmap_udp_top.xml
```

### XML output (for tooling)

```bash
nmap -sC -sV <ip> -oX scans/nmap_tooling.xml
```

---

## nmap → metasploit

```bash
msfconsole
db_import scans/nmap_tooling.xml
services
hosts
```

---

## nmap → searchsploit

```bash
nmap -sV <ip> -oX scans/nmap_services.xml
searchsploit --nmap scans/nmap_services.xml
```

---

### Notes

* open ports:
* likely OS:
* weird banners:
