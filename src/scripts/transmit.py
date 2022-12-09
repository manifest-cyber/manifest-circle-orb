import os
import base64
import sys
import json
import urllib.request # It would be hard to make circle import requests

api_key = os.environ.get('MANIFEST_API_KEY')
filepath = os.getenv("SBOM_FILEPATH")


sbom = open(filepath, "r")
sbom_string = sbom.read()
base64BomContents = base64.b64encode(sbom_string.encode("utf-8")).decode("utf-8")
sbom.close()

data = json.dumps({"base64BomContents": base64BomContents, "source": "circle-ci", "filename": filepath, "relationship": "first"})
url = "https://api.manifestcyber.com/v1/sbom/upload"
headers = {"Content-Type": "application/json", "Authorization": "Bearer " + api_key}

req = urllib.request.Request(url = url, data = bytes(data.encode("utf-8")), method = "PUT", headers = headers)

with urllib.request.urlopen(req) as resp:
    print(resp.status)
