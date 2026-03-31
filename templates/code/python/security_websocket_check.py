#!/usr/bin/env python3
"""
WebSocket validation template for message-flow and auth testing.
"""

from __future__ import annotations

import argparse

import websocket


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="WebSocket validation template")
    parser.add_argument("url", help="ws:// or wss:// endpoint")
    parser.add_argument("--header", action="append", default=[])
    parser.add_argument("--message", default="ping")
    parser.add_argument("--timeout", type=int, default=10)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    connection = websocket.create_connection(args.url, header=args.header, timeout=args.timeout)
    connection.send(args.message)
    print(connection.recv())
    connection.close()


if __name__ == "__main__":
    main()
