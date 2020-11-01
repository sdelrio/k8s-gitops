# K8s GitOps

# Tools

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

# Helmfile

```
brew install helmfile
helm plugin install https://github.com/zendesk/helm-secrets 
```

Helm entrypoint even if using kustomize: <https://github.com/roboll/helmfile#helmfile--kustomize>

## helmify-kustomize

* <https://gist.github.com/mumoshu/f9d0bd98e0eb77f636f79fc2fb130690>


