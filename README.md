# artis3n/kali

A kalilinux/kali-rolling container with extra juice.

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/artis3n/kali-artis3n/Docker%20Image%20CI)](https://github.com/artis3n/kali-artis3n/actions)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/artis3n/kali-artis3n)](https://github.com/artis3n/kali-artis3n/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/artis3n/kali)](https://hub.docker.com/r/artis3n/kali)
![GitHub last commit](https://img.shields.io/github/last-commit/artis3n/kali-artis3n)
![GitHub](https://img.shields.io/github/license/artis3n/kali-artis3n)
[![GitHub followers](https://img.shields.io/github/followers/artis3n?style=social)](https://github.com/artis3n/)
[![Twitter Follow](https://img.shields.io/twitter/follow/artis3n?style=social)](https://twitter.com/Artis3n)

The [kalilinux/kali-rolling](https://www.kali.org/docs/containers/official-kalilinux-docker-images/) container comes with no pre-installed services.
It is meant to be lightweight and clocks in around 118 MB.
You must configure every service and tool you need from that base image.

This container, uncompressed, is around 3.5 GB (or 2.0 GB without wordlists).
It installs and pre-configures a number of frequently uses Kali tools.
It is meant to allow you to quickly get up and running with a Kali environment on an ephemeral host.
Don't spend time configuring and tweaking - pull, run, execute, pwn.

## Wordlists

A premium is placed on keeping this image as small as is reasonable given its intended purpose.
For example, `searchploit` is installed in this image but `searchsploit -u` is not run to install exploitdb-papers because this increases the image size by 6GB.

Seclists and Rockyou are pre-installed by default in the `latest` and semver tags, e.g. `1`, `1.2`, `1.2.0`. This increases the image size by 1.5 GB. Therefore, if you do not need wordlists, you can use the `<tagname>-no-wordlists` tag. For example:

```bash
docker pull artis3n/kali:latest-no-wordlists
```

Currently, only `latest` is built without wordlists, as `latest-no-wordlists`. The semver tags (e.g. `1`, `1.2`, `1.2.0`) are built with wordlists.

## Image efficiency (Dive)

![Docker Image Size (tag)](https://img.shields.io/docker/image-size/artis3n/kali/latest?label=Full%20image%2C%20compressed)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/artis3n/kali/latest-no-wordlists?label=No%20wordlists%2C%20compressed)

Efficiency of the build image is checked with [dive](https://github.com/wagoodman/dive):

| Image condition | Image Size |
| --- | --- |
| With wordlists | ![Dive image with wordlists efficiency](resources/dive-efficiency-wordlists.png) |
| Without wordlists | ![Dive image without wordlists efficiency](resources/dive-efficiency-base.png) |

<small>Last checked: 2020-03-15</small>

The container is not meant for a persistent attacker environment.
The intention is for a quick environment to run attacks and document the results outside of the container.
The container does not mount a volume for persistent storage - although, like any container, storage inside the container will remain until you `docker rm`.

## Usage

Download the image:

- [Docker Hub](https://hub.docker.com/r/artis3n/kali)
- [GitHub Packages](https://github.com/artis3n/kali-artis3n/packages/143757)

```bash
docker pull artis3n/kali:latest
docker pull artis3n/kali:latest-no-wordlists
# or
docker pull docker.pkg.github.com/artis3n/kali-artis3n/kali:latest
docker pull docker.pkg.github.com/artis3n/kali-artis3n/kali:latest-no-wordlists
```

Run the container:

```bash
docker run --name kali -it --rm artis3n/kali:latest
# Or detach the container and run commands through it
docker run --name kali -id artis3n/kali:latest
docker exec -t kali nmap -p- 127.0.0.1
```

![Docker Exec](/resources/docker-exec.png)

![Docker Exec AutoRecon](/resources/docker-exec-autorecon.png)

Get a terminal for the backgrounded container:

```bash
docker exec -it kali /bin/bash
```

![Docker TTY](/resources/docker-tty.png)

Stop the backgrounded container, turn it back on whenever you need to run a command:

```bash
docker stop kali
docker start kali
```

Kill the backgrounded container:

```bash
docker stop kali && docker rm kali
```

Alias a command to your container, run commands through the container from your terminal:

```bash
alias kali="docker exec -it kali"
kali sqlmap -u ...
```

## Configured tools

- Amass
- [AutoRecon](https://github.com/Tib3rius/AutoRecon)
  - curl
  - enum4linux
  - **gobuster**
  - nbtscan
  - **nikto**
  - **nmap**
  - onesixtyone
  - oscanner
  - smbclient
  - smbmap
  - smtp-user-enum
  - snmpwalk
  - sslscan
  - svwar
  - tnscmd10g
  - whatweb
  - wkhtmltoimage
- Hydra
- [Impacket](https://github.com/SecureAuthCorp/impacket) scripts
- JohnTheRipper (jumbo)
- Metasploit / Meterpreter
  - PostgreSQL 12
- Proxychains4 ([proxychains-ng](https://github.com/rofl0r/proxychains-ng))
- Rockyou wordlist (/usr/share/wordlists/rockyou.txt)
  - Wordlists / Latest image only
- Searchsploit ([ExploitDB](https://www.exploit-db.com/searchsploit))
- Seclists wordlist (/usr/share/seclists)
  - Wordlists / Latest image only
- Socat
- SSLyze
- SQLMap

## Contributions

Missing a tool you would like pre-configured? File a ticket and I will add it.
A pull request is also welcome.

For any new tools, you must add validation tests to `.github/workflows/ci.yml`. Use the existing tests as a baseline.
These tests ensure the tools are installed and pre-configured correctly.

### Recognition

Thanks [Anit Gandhi](https://github.com/anitgandhi) for help optimizing the Dockerfile and build images.
