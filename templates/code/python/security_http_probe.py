#!/usr/bin/env python3
"""
Generic HTTP probe template for web research.
"""

from __future__ import annotations

import argparse

import requests


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="HTTP probe template")
    parser.add_argument("target", help="Base URL, e.g. http://127.0.0.1:8000")
    parser.add_argument("--endpoint", default="/api")
    parser.add_argument("--method", default="POST", choices=["GET", "POST", "PUT", "PATCH", "DELETE"])
    parser.add_argument("--proxy", help="HTTP proxy, e.g. http://127.0.0.1:8080")
    parser.add_argument("--verify", action="store_true", help="Verify TLS certificates")
    parser.add_argument("--timeout", type=int, default=10)
    return parser.parse_args()


def build_session(args: argparse.Namespace) -> requests.Session:
    session = requests.Session()
    session.verify = args.verify
    session.headers.update({
      "User-Agent": "research-poc/1.0",
      "Content-Type": "application/json",
    })
    if args.proxy:
      session.proxies.update({ "http": args.proxy, "https": args.proxy })
    return session


def main() -> None:
    args = parse_args()
    session = build_session(args)
    url = f"{args.target.rstrip('/')}{args.endpoint}"
    payload = { "test": "value" }
    response = session.request(args.method, url, json=payload, timeout=args.timeout)
    print(f"[i] Status: {response.status_code}")
    print(response.text[:500])


if __name__ == "__main__":
    main()
