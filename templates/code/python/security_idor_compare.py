#!/usr/bin/env python3
"""
IDOR / broken access control comparison template.
"""

from __future__ import annotations

from security_common import build_session, parser_common, request


def main() -> None:
    parser = parser_common("IDOR comparison template")
    parser.add_argument("--endpoint", default="/api/object/{id}")
    parser.add_argument("--id", required=True, dest="object_id")
    parser.add_argument("--cookie-a", required=True)
    parser.add_argument("--cookie-b", required=True)
    args = parser.parse_args()

    session_a = build_session(args.proxy, args.verify, args.timeout)
    session_b = build_session(args.proxy, args.verify, args.timeout)
    session_a.headers["Cookie"] = args.cookie_a
    session_b.headers["Cookie"] = args.cookie_b

    endpoint = args.endpoint.format(id=args.object_id)
    response_a = request(session_a, "GET", args.target, endpoint)
    response_b = request(session_b, "GET", args.target, endpoint)

    print(f"[i] A={response_a.status_code} len={len(response_a.text)}")
    print(f"[i] B={response_b.status_code} len={len(response_b.text)}")
    if response_a.status_code == 200 and response_b.status_code == 200 and response_a.text == response_b.text:
      print("[+] Potential IDOR / broken access control")
    else:
      print("[-] No obvious match")


if __name__ == "__main__":
    main()
