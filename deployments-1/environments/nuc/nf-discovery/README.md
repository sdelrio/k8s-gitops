
# How to get PCI class/vendor

Get the pci id of your device with `lspci`.

## Samples

### VGA

* Get the PCI id with lspci

```bash
$ lspci -nn |grep VGA
00:02.0 VGA compatible controller [0300]: Intel Corporation Device [8086:5a85] (rev 0b)
```

```
00:02.0 VGA compatible controller [class]: Intel Corporation Device [vendor:device] (rev 0b)
```

### SD Card Reader


* Get the PCI id with lspci

```bash
$ lspci -nn |grep -i reader
01:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5229 PCI Express Card Reader [10ec:5229] (rev 01)
```

```
01:00.0 Unassigned class [class]: Realtek Semiconductor Co., Ltd. RTS5229 PCI Express Card Reader [vendor:device] (rev 01)
```

## Info

* https://kubernetes-sigs.github.io/node-feature-discovery/v0.6/get-started/index.html
* https://github.com/kubernetes-sigs/node-feature-discovery/blob/master/nfd-worker.conf.example
* https://www.systutorials.com/docs/linux/man/8-lspci/