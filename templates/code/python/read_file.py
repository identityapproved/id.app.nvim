#!/usr/bin/env python3
"""
File: {{filename}}
Author: {{author}}
Description:
    Read all lines from an input file and print them.
"""


def main() -> None:
    with open("input.txt", "r", encoding="utf-8") as f:
        lines = f.read().strip().splitlines()

    print("All input lines:")
    for line in lines:
        print(line)


if __name__ == "__main__":
    main()
