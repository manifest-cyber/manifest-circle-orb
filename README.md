# Manifest Cyber Orb

<!---
[![CircleCI Build Status](https://circleci.com/gh/<organization>/<project-name>.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/<organization>/<project-name>) [![CircleCI Orb Version](https://badges.circleci.com/orbs/<namespace>/<orb-name>.svg)](https://circleci.com/orbs/registry/orb/<namespace>/<orb-name>) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/<organization>/<project-name>/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

--->

This orb is used to send an SBOM to your Manifest Cyber account.

---

## 

## Resources

[CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/manifest/manifest-circle-orb) - The official registry page of this orb for all versions, executors, commands, and jobs described.

[CircleCI Orb Docs](https://circleci.com/docs/2.0/orb-intro/#section=configuration) - Docs for using, creating, and publishing CircleCI Orbs.

## Usage Example

```yaml
usage:
  version: 2.1
  orbs:
    manifest: manifest/manifest-circle-orb@x.y.z

  jobs:
    build:
      docker:
        - image: cimg/node:lts
      steps:
        - checkout
        - run: npm ci
        - run: npm run build:bom
        - manifest-circle-orb/transmit:
            apiKey: $MANIFEST_API_KEY
            bomFilePath: "./bom.json"
```