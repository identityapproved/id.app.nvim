#!/usr/bin/env python3
"""
File upload validation template for labs.
"""

from __future__ import annotations

from pathlib import Path

from security_common import build_session, parser_common, request


def main() -> None:
    parser = parser_common("File upload validation template")
    parser.add_argument("--endpoint", default="/upload")
    parser.add_argument("--field", default="file")
    parser.add_argument("--file", required=True)
    parser.add_argument("--mime", default="text/plain")
    args = parser.parse_args()

    session = build_session(args.proxy, args.verify, args.timeout)
    filepath = Path(args.file)
    with filepath.open("rb") as handle:
      response = request(
        session,
        "POST",
        args.target,
        args.endpoint,
        files={ args.field: (filepath.name, handle, args.mime) },
      )

    print(f"[i] Status: {response.status_code}")
    print(response.text[:500])


if __name__ == "__main__":
    main()
