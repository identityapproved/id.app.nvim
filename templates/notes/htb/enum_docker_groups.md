## Enumeration - Docker Groups / `sg`

- user:
- current groups:
- interesting groups:
- docker socket:
- `sg` present:
- working group switch:
- impact:

### Why `sg` matters

`sg` runs a command with a different group ID.

The useful question is not:

> "Am I already effectively root?"

It is:

> "Can I run a command under a group that owns a sensitive socket, device, or file?"

If that group can talk to `docker.sock`, `lxd`, a database admin socket, or another privileged control surface, that is the real boundary crossing.

### Core checks

```bash
which sg
id
groups
getent group docker
getent group operator
getent group adm
ls -l /var/run/docker.sock /run/docker.sock 2>/dev/null
```

### Test group-switched execution

```bash
sg docker -c 'id; groups'
sg docker -c 'docker ps'
sg docker -c 'docker images'
```

### Compare normal shell vs `sg`

Normal shell:

```bash
id
groups
docker ps
```

Using `sg`:

```bash
sg docker -c 'id; groups; docker ps'
```

### High-signal pattern

```text
Can I run a command under a more useful group?
-> Does that group own a socket, device, or file I care about?
-> Does access to that resource lead to code execution or privilege escalation?
```

### Sensitive group examples

- `docker` -> Docker daemon socket
- `lxd` -> LXD/LXC control socket
- backup / monitoring / admin groups -> privileged sockets under `/run` or `/var/run`
- service-owned groups -> config, keys, or writable root-consumed files

### Docker-specific follow-up

```bash
sg docker -c 'docker ps -a'
sg docker -c 'docker images'
sg docker -c 'docker info'
sg docker -c 'docker image inspect <image> --format "{{json .Config.Entrypoint}} {{json .Config.Cmd}} {{json .Config.User}}"'
```

### Notes

- socket ownership:
- command that worked:
- container/image behavior:
- why the boundary crossing matters:
- privesc path:
