import os
import base64
import sys
import json
import urllib

api_key = os.getenv("MANIFEST_API_KEY")
bom_filepath = os.getenv("BOM_FILEPATH")

bom = open(bom_filepath, "r")
bom_string = bom.read()
base64BomContents = base64.b64encode(bom_string)
bom.close()

data = json.dumps({"base64BomContents": base64BomContents, "apiKey": api_key})
url = "https://mvdryhw7l8.execute-api.us-east-1.amazonaws.com/prod/receive"
headers = {"Content-Type": "application/json", "Content-Length": str(sys.getsizeof(data))}

http = urllib.PoolManager()

r = http.request("PUT", url, headers=headers, body=data,)

print(r.text)
print(r.status_code)