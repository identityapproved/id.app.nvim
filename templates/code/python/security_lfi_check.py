#!/usr/bin/env python3
"""
LFI / path traversal check template using a lab marker file.
"""

from __future__ import annotations

from security_common import build_session, parser_common, request


def main() -> None:
    parser = parser_common("LFI/path traversal template")
    parser.add_argument("--endpoint", default="/download")
    parser.add_argument("--param", default="file")
    parser.add_argument("--probe", default="../../../../tmp/lab_marker.txt")
    parser.add_argument("--expected-marker", default="LAB_FILE_MARKER")
    args = parser.parse_args()

    session = build_session(args.proxy, args.verify, args.timeout)
    response = request(
      session,
      "GET",
      args.target,
      args.endpoint,
      params={ args.param: args.probe },
    )

    print(f"[i] Status: {response.status_code}")
    if args.expected_marker in response.text:
      print("[+] Possible file inclusion / traversal")
    else:
      print("[-] Marker not found")


if __name__ == "__main__":
    main()
