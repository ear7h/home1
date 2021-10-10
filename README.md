# home

These are the nix files for my thonkpad

## TODO

* [ ] add `/etc/nixos/*` and related files
* [ ] merge with macOS and cloud server config

## Nix docs

* `man configuration.nix`
* `man home-configuration.nix`
* `nix-env -qa PACKAGE` - search on command line, slow
* https://search.nixos.org - search on web, fast

## Audio

* `pavucontrol` - audio gui

## WIFI

Adding a network via `sudo wpa_cli`:

```
scan
scan_results
add_network
set_network N ssid "SSID"
set_network N key_mgmt <NONE|WPA-EAP|WPA-PSK>

psk_passphrase 2 "psk"
# or
identity N "username"
password N "password"

enable N
save_config
```

## Sway

Display commands are similar to i3, here are some that might be hard to
remember:

| command               | keys            |
| --------------------- | --------------- |
| exit sway             | mod + shift + e |
| switch to tabs        | mod + w         |
| switch to bsp/rotate  | mod + e         |

