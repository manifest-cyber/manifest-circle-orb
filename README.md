# Manifest Cyber Orb

<!---
[![CircleCI Build Status](https://circleci.com/gh/<organization>/<project-name>.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/<organization>/<project-name>) [![CircleCI Orb Version](https://badges.circleci.com/orbs/<namespace>/<orb-name>.svg)](https://circleci.com/orbs/registry/orb/<namespace>/<orb-name>) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/<organization>/<project-name>/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

--->

> Note: This is a legacy version of our Orb and is considered deprecated. This is still available for use (for now), but we recommend using our [updated Orb here](https://circleci.com/developer/orbs/orb/manifest/sbom). You do not need to be a Manifest customer to use our Orb for generating SBOMs, but if you'd like to learn more about Manifest, you can find us at [manifestcyber.com](https://manifestcyber.com).

This Orb is used to generate an SBOM and optionally publish to your Manifest account. This Orb uses the Manifest CLI, which wraps various SBOM generators, supports multiple formats, and provides a common interface for generating SBOMs. The Manifest CLI performs further cleanup on generated SBOMs (such as healing relationships & componentIds, asset names & versions, etc), and can also optionally publish your SBOM directly into your Manifest tenant.

---

## How to use this orb

This orb is meant to be used in conjunction with an SBOM generation tool such as CycloneDX. The orb will take the SBOM and send it to your Manifest Cyber account. Various generators are available for different languages and ecosystems. For more information on how to generate an SBOM, visit the [CycloneDX Github Org](https://github.com/CycloneDX/).

1. Add the orb to your project.
2. Generate an API Key in your Manifest Cyber account. This is done from the "Organizations" page, which you can reach by clicking on your account. 
3. Save that API key in CircleCI as an environment variable. The name of the environment variable is `MANIFEST_API_KEY`.

In the app build job, use your either use your SBOM generator to build an SBOM and save it to a file. 

5. Call `sbom-transmitter/install-syft` to install `syft` SBOM generator in your CI.
6. Call `sbom-transmitter/run-syft` to generate SBOM for your build.
7. In the app build job, call the `sbom-transmitter/transmit` command. Pass the path to the SBOM as the `sbom-file-path` parameter.



## Resources

[CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/manifest/sbom-transmitter) - The official registry page of this orb for all versions, executors, commands, and jobs described.

[CircleCI Orb Docs](https://circleci.com/docs/2.0/orb-intro/#section=configuration) - Docs for using, creating, and publishing CircleCI Orbs.

## Usage Example

```yaml
usage:
  version: 2.1
  orbs:
    manifest: manifest/sbom-transmitter@x.y.z

  jobs:
    build:
      docker:
        - image: cimg/node:lts
      steps:
        - checkout
        - run: npm ci
        - run: sbom-transmitter/install-syft
        - sbom-transmitter/run-syft:
            source: "./"
            file: "./sbom.json" # optional
            sbom-name: "demo-sbom" # optional
            sbom-version: "v1.0.0" # optional
            sbom-output: "cyclonedx-json" # optional
        - sbom-transmitter/transmit:
            sbom-file-path: "./sbom.json"
```
