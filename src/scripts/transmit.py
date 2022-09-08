import os
import base64
import sys
import json
import urllib.request # It would be hard to make circle import requests

api_key = os.getenv("MANIFEST_API_KEY")
bom_filepath = os.getenv("BOM_FILEPATH")

print(api_key)

bom = open(bom_filepath, "r")
bom_string = bom.read()
base64BomContents = base64.b64encode(bom_string.encode("utf-8")).decode("utf-8")
bom.close()

data = json.dumps({"base64BomContents": base64BomContents, "apiKey": api_key})
url = "https://mvdryhw7l8.execute-api.us-east-1.amazonaws.com/prod/receive"
headers = {"Content-Type": "application/json"}

req = urllib.request.Request(url = url, data = bytes(data.encode("utf-8")), method = "PUT", headers = headers)

with urllib.request.urlopen(req) as resp:
    response_data = json.loads(resp.read().decode("utf-8"))
    print(response_data)
