#!/usr/bin/env python3
import sys
import json
import traceback

def log_error(message):
    with open('/tmp/udf_error.log', 'a') as f:
        f.write(message + '\n')

try:
    for line in sys.stdin:
        try:
            log_error(f"Received input: {line.strip()}")
            data = json.loads(line.strip())
            
            result = [str(item).upper() for item in data]
            
            output = json.dumps(result)
            log_error(f"Returning output: {output}")
            print(output)
            sys.stdout.flush()
        except json.JSONDecodeError as e:
            log_error(f"JSON decode error: {str(e)}")
            sys.exit(1)
        except Exception as e:
            log_error(f"Processing error: {str(e)}\n{traceback.format_exc()}")
            sys.exit(1)
except Exception as e:
    log_error(f"Main loop error: {str(e)}\n{traceback.format_exc()}")
    sys.exit(1)