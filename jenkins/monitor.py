import random
import time
import os

while True:
    failure = random.choice([False, False, True])  # Simulate 33% failure chance This script simulates a random failure and triggers Jenkins failover job using a curl command.
    if failure:
        print(" FAILURE DETECTED! Triggering failover...")
        os.system("curl -X POST http://localhost:8080/job/failover/build?token=trigger")
        break
    else:
        print("✅ System healthy.")
    time.sleep(10)
