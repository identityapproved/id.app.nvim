#!/usr/bin/env python3
"""
SSTI validation template with harmless render checks.
"""

from __future__ import annotations

from security_common import build_session, parser_common, request


def main() -> None:
    parser = parser_common("SSTI validation template")
    parser.add_argument("--endpoint", default="/preview")
    parser.add_argument("--param", default="template")
    parser.add_argument("--payload", required=True)
    parser.add_argument("--expected", required=True)
    args = parser.parse_args()

    session = build_session(args.proxy, args.verify, args.timeout)
    response = request(
      session,
      "POST",
      args.target,
      args.endpoint,
      data={ args.param: args.payload },
    )

    print(f"[i] Status: {response.status_code}")
    if args.expected in response.text:
      print("[+] Possible SSTI")
    else:
      print("[-] Expected render output not found")


if __name__ == "__main__":
    main()
