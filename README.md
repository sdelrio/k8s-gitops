# K8s GitOps
<!-- TOC -->

- [K8s GitOps](#k8s-gitops)
- [:notebook:&nbsp;Usage](#notebooknbspusage)
- [Deployment-0](#deployment-0)
- [:wrench:&nbsp; Deployment Tools](#wrenchnbsp-deployment-tools)
- [:hammer:&nbsp; Tools install and configuration](#hammernbsp-tools-install-and-configuration)
    - [Kustomize](#kustomize)
    - [Mozilla SOPS](#mozilla-sops)
    - [Helmfile](#helmfile)
    - [helmify-kustomize](#helmify-kustomize)

<!-- /TOC -->
# :notebook:&nbsp;Usage

Enter into the deployment folder and execute helmfile with the envieronment (`dev` or `nuc` in this repo). Sample

```
helmfile --environment dev apply
```

# Deployment-0

For the incomming traffice it will install a metallb load balancer, 2 nginx ingress controler (one for LAN and one for WAN, this one also with a cert manager for ssl certs).

For storage will install OpenEBS for localPV and Longhorn for distributed storage, also velero for backups.

The passwords are stored under SOPS, helmfile will automatically decode it with PGP (if you are cloning the repo you would have to make your own secrets file with your own certificate).

<img src="https://raw.githubusercontent.com/sdelrio/k8s-gitops/master/doc/img/deployment-0.svg" width="20%" height="auto" />
---
# :wrench:&nbsp; Deployment Tools

Some tools used for the deployment

| Tool  | Small description|
|-------|------------------|
| [kustomize](https://kustomize.io) | Configuration management for k8s yaml files |
| [SOPS](https://github.com/mozilla/sops) | Secret management using PGP  |
| [helmfile](https://github.com/roboll/helmfile#helmfile--kustomize) | Deploy automation for depending on env using helm files |
| [helmify-kustomize](https://gist.github.com/mumoshu/f9d0bd98e0eb77f636f79fc2fb130690) | Using kustomize as a helm file |

# :hammer:&nbsp; Tools install and configuration

## Kustomize

* <https://kubernetes-sigs.github.io/kustomize/installation/>

```
brew install kustomize
```

## Mozilla SOPS

* <https://github.com/mozilla/sops>
```
brew install sops
```

Setting up SOPS with PGP:  https://gist.github.com/twolfson/01d515258eef8bdbda4f#setting-up-sops-with-pgp
Generate gpg key: `gpg --full-generate-key`

To encrypt or decrypt using PGP, specify the PGP fingerprint in the `-p` flag or in the `SOPS_PGP_FP` environment variable.
To add a new pgp key to the file and rotate the data key

```
$ sops -r -i --add-pgp '{{ fingerprint }}' example.yaml
```

## Helmfile

```
brew install helmfile
helm plugin install https://github.com/zendesk/helm-secrets 
```

Helm entrypoint even if using kustomize: <https://github.com/roboll/helmfile#helmfile--kustomize>

## helmify-kustomize

* <https://gist.github.com/mumoshu/f9d0bd98e0eb77f636f79fc2fb130690>
