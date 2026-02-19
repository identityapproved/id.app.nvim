## Enumeration - Web

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
