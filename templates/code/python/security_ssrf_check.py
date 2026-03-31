#!/usr/bin/env python3
"""
SSRF validation template for controlled callback testing.
"""

from __future__ import annotations

from security_common import build_session, parser_common, request


def main() -> None:
    parser = parser_common("SSRF validation template")
    parser.add_argument("--endpoint", default="/fetch")
    parser.add_argument("--param", default="url")
    parser.add_argument("--callback-url", required=True, help="Controlled callback URL")
    args = parser.parse_args()

    session = build_session(args.proxy, args.verify, args.timeout)
    response = request(
      session,
      "POST",
      args.target,
      args.endpoint,
      data={ args.param: args.callback_url },
    )

    print(f"[i] Status: {response.status_code}")
    if any(token in response.text.lower() for token in ["connection refused", "invalid url", "timeout"]):
      print("[+] Target appears to process remote URLs")
    else:
      print("[i] Manual review needed")


if __name__ == "__main__":
    main()
