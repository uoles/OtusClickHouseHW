#!/usr/bin/python3
import sys

if __name__ == '__main__':
  for line in sys.stdin:
    arg1, arg2, arg3 = line.split('\t')

    result = '';
    if (float(arg1) * int(arg2)) > int(arg3):
      result = "HIGH"     # Высокоценная
    else:
      result = "LOW"      # Малоценная
    print(result)

    sys.stdout.flush()
