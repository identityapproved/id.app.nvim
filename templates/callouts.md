So here is the **complete, honest list** — no mythology, no hidden keywords.

---

## The full set of GitLab-native callout conventions

These all work because they are just **blockquotes + emphasis**. GitLab does not style them; *you do*.

### Core, universally understood

```markdown
> **Note**
>
> Informational context.
```

```markdown
> **Tip**
>
> A helpful trick.
```

```markdown
> **Important**
>
> Must not be missed.
```

```markdown
> **Warning**
>
> Risky behavior ahead.
```

```markdown
> **Danger**
>
> High-impact failure possible.
```

---

### Security / CTF-friendly (also safe)

These are not “special”, but they are idiomatic and render perfectly:

```markdown
> **Info**
>
> Background information.
```

```markdown
> **Caution**
>
> May break the exploit chain.
```

```markdown
> **Pitfall**
>
> Common mistake during enumeration.
```

```markdown
> **Gotcha**
>
> Looks safe. Isn’t.
```

```markdown
> **Heads-up**
>
> Environment-specific behavior.
```

```markdown
> **Reminder**
>
> Disable ASLR first.
```

---

### Strong emphasis variants

Useful when scanning long pages:

```markdown
> **⚠ Warning**
>
> This will crash the service.
```

```markdown
> **🚨 Danger**
>
> Root shell detected by IDS.
```

```markdown
> **💡 Tip**
>
> Use `--noconfig` with sudo.
```

Emojis are fully supported by GitLab and render cleanly.

---

### Section-label style (clean + minimal)

```markdown
> **Exploit Path**
>
> LFI → log poisoning → RCE
```

```markdown
> **Privilege Escalation**
>
> Misconfigured sudo rule.
```

```markdown
> **Enumeration**
>
> Check `/etc/crontab`.
```

This style is excellent for CTF notes because it behaves like a visual subheading.

---

## What GitLab does *not* support (important)

These **do not render as callouts** on GitLab:

```markdown
!!! note
    MkDocs only
```

```markdown
> [!NOTE]
> Obsidian only
```

```markdown
:::warning
Not supported
:::
```

GitLab will show them as raw text.

---

## Canonical “safe set” (recommended standard)

If you want a **clean, disciplined vocabulary**, stick to:

* Note
* Tip
* Important
* Warning
* Danger
* Caution
* Info

This maps cleanly to MkDocs / Obsidian later if you ever convert.

---

## One subtle power move

Standardize casing and spelling **globally**:

```markdown
> **Warning**
```

not

```markdown
> **WARNING**
> **Warn**
> **⚠️ warning**
```

Consistency is what makes callouts scannable under time pressure.

---

## Final truth, stated plainly

GitLab has **zero built-in callouts**.
Everything you see working is **just Markdown behaving well**.

The blockquote is the UNIX pipe of documentation:
simple, composable, indestructible.

If you want, I can give you:

* a linting rule to enforce callout consistency
* a conversion map to MkDocs admonitions
* a CTF-optimized callout taxonomy (enum / exploit / privesc / opsec)

The notes should read clearly even when the renderer doesn’t care.

