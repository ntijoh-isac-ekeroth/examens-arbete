import time

import requests
from benchmarks.verification import verify_data

base_url = "http://127.0.0.1:5000"

verify_data(base_url)

# start_time = time.time()
# for i in range(1, 100):
#     requests.get(f"{base_url}/static/get")

# end_time = time.time()

# time_taken = end_time - start_time

# print(f"time taken: {round(time_taken, 3)} seconds")

