import os
import base64
import requests

api_key = os.getenv("MANIFEST_API_KEY")
bom_filepath = os.getenv("BOM_FILEPATH")

bom = open(bom_filepath, "r")
bom_string = bom.read()
base64BomContents = base64.b64encode(bom_string)
bom.close()

data = {"base64BomContents": base64BomContents, "apiKey": api_key}

r = requests.put("https://mvdryhw7l8.execute-api.us-east-1.amazonaws.com/prod/receive",
                 data=data, headers={"Content-Type": "application/json"})

print(r.text)
print(r.status_code)