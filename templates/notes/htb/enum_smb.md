## Enumeration - SMB

- anonymous: <yes/no>
- shares:
- creds used:

```bash
smbclient -L //<ip>/ -N
crackmapexec smb <ip>
smbmap -H <ip> -u '<user>' -p '<pass>'
```

### Loot

* interesting files:
* password reuse candidates:
