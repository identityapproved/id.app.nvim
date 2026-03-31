#!/usr/bin/env python3
"""
Reusable helper for web vulnerability research templates.
"""

from __future__ import annotations

import argparse
from urllib.parse import urljoin

import requests


def parser_common(description: str) -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument("target", help="Base URL, e.g. http://127.0.0.1:8000")
    parser.add_argument("--proxy", help="HTTP proxy, e.g. http://127.0.0.1:8080")
    parser.add_argument("--verify", action="store_true", help="Verify TLS certificates")
    parser.add_argument("--timeout", type=int, default=10, help="Request timeout in seconds")
    return parser


def build_session(proxy: str | None = None, verify: bool = False, timeout: int = 10) -> requests.Session:
    session = requests.Session()
    session.verify = verify
    session.headers.update({ "User-Agent": "research-poc/1.0" })
    session.request_timeout = timeout
    if proxy:
        session.proxies.update({ "http": proxy, "https": proxy })
    return session


def request(session: requests.Session, method: str, target: str, endpoint: str, **kwargs) -> requests.Response:
    timeout = kwargs.pop("timeout", getattr(session, "request_timeout", 10))
    url = urljoin(target, endpoint)
    return session.request(method, url, timeout=timeout, **kwargs)
