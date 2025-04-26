#!/usr/bin/python3
import sys

if __name__ == '__main__':
  for line in sys.stdin:
    arg1, arg2 = line.split('\t')

    result = float(arg1) * int(arg2)
    print(str(result))

    sys.stdout.flush()
