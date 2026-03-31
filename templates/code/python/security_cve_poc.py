#!/usr/bin/env python3
"""
CVE PoC template for authorized testing and reproduction.
"""

from __future__ import annotations

import argparse

import requests


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="CVE PoC template")
    parser.add_argument("target", help="Base URL, e.g. http://127.0.0.1:8000")
    parser.add_argument("--proxy", help="HTTP proxy, e.g. http://127.0.0.1:8080")
    parser.add_argument("--verify", action="store_true", help="Verify TLS certificates")
    parser.add_argument("--timeout", type=int, default=10)
    parser.add_argument("--check", action="store_true", help="Run a non-destructive check")
    return parser.parse_args()


def build_session(args: argparse.Namespace) -> requests.Session:
    session = requests.Session()
    session.verify = args.verify
    session.headers.update({ "User-Agent": "research-poc/1.0" })
    if args.proxy:
        session.proxies.update({ "http": args.proxy, "https": args.proxy })
    return session


def check(session: requests.Session, target: str, timeout: int) -> bool:
    url = f"{target}/vulnerable_endpoint"
    response = session.get(url, timeout=timeout)
    if "vulnerable_marker" in response.text:
        print("[+] Target appears vulnerable")
        return True
    print("[-] Target does not show the expected marker")
    return False


def run_poc(session: requests.Session, target: str, timeout: int) -> None:
    url = f"{target}/vulnerable_endpoint"
    payload = { "input": "test_payload" }
    response = session.post(url, data=payload, timeout=timeout)
    print(f"[i] Status: {response.status_code}")
    print(response.text[:500])


def main() -> None:
    args = parse_args()
    session = build_session(args)
    if args.check:
        check(session, args.target, args.timeout)
    else:
        run_poc(session, args.target, args.timeout)


if __name__ == "__main__":
    main()
