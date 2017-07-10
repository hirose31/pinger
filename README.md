<p align="center">
  <!-- a href="https://github.com/hirose31/pinger/releases/latest"><img alt="Release" src="https://img.shields.io/github/release/hirose31/pinger.svg?style=flat-square"></a -->
  <a href="/LICENSE.md"><img alt="Software License" src="https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square"></a>
  <a href="https://travis-ci.org/hirose31/pinger"><img alt="Travis" src="https://img.shields.io/travis/hirose31/pinger.svg?style=flat-square"></a>
  <a href="https://codecov.io/gh/hirose31/pinger"><img alt="Codecov branch" src="https://img.shields.io/codecov/c/github/hirose31/pinger/master.svg?style=flat-square"></a>
  <a href="https://goreportcard.com/report/github.com/hirose31/pinger"><img alt="Go Report Card" src="https://goreportcard.com/badge/github.com/hirose31/pinger?style=flat-square"></a>
  <a href="http://godoc.org/github.com/hirose31/pinger"><img alt="Go Doc" src="https://img.shields.io/badge/godoc-reference-blue.svg?style=flat-square"></a>
</p>

# Pinger

Pinger helps you to monitor many hosts using ICMP ECHO_REQUEST.

<p align="center">
  <img src="./doc/pinger.gif">
</p>

# Installation

Download from [release page](https://github.com/hirose31/pinger/releases).

# Usage

```
pinger HOSTNAME_OR_IPADDR [HOSTNAME_OR_IPADDR ...]
```

`pinger` sends ICMP packets using raw socket, so requires root privileges.

- sudo pinger ...
- run by root
- `chown root pinger; chmod 4755 pinger` and run by normal user
- `setcap cap_net_raw=ep pinger` and run by normal user (Linux only)

You can write failed history to a file by redirecting stderr to a file.

```
$ sudo pinger example.com example.net 192.0.2.1 192.0.2.2 192.0.2.3 2> pinger.log
```

Two numerical numer are RTT and average of RTT (max latest 10 samples).


Push `ESC` or `C-c` to exit.

