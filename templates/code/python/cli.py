#!/usr/bin/env python3
"""
CLI Tool: {{filename}}
"""

import argparse


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="CLI tool template")
    parser.add_argument("-t", "--target", help="Target host", required=True)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    print(f"Target: {args.target}")


if __name__ == "__main__":
    main()
