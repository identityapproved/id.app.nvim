#!/usr/bin/env python3
"""
Concurrent request harness for race-condition testing.
"""

from __future__ import annotations

from concurrent.futures import ThreadPoolExecutor, as_completed

from security_common import build_session, parser_common, request


def fire_once(session, target: str, endpoint: str, data: dict[str, str]) -> tuple[int, str]:
    response = request(session, "POST", target, endpoint, data=data)
    return response.status_code, response.text[:120]


def main() -> None:
    parser = parser_common("Race condition template")
    parser.add_argument("--endpoint", default="/redeem")
    parser.add_argument("--workers", type=int, default=10)
    parser.add_argument("--data", nargs="*", default=[], help="k=v pairs")
    args = parser.parse_args()

    session = build_session(args.proxy, args.verify, args.timeout)
    data = dict(item.split("=", 1) for item in args.data)

    with ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = [
          executor.submit(fire_once, session, args.target, args.endpoint, data)
          for _ in range(args.workers)
        ]
        for future in as_completed(futures):
            status, snippet = future.result()
            print(status, snippet)


if __name__ == "__main__":
    main()
