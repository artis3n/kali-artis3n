# artis3n/kali

A kalilinux/kali-rolling container with extra juice.

[![Deploy Docker Image](https://github.com/artis3n/kali-artis3n/actions/workflows/cron.yml/badge.svg)](https://github.com/artis3n/kali-artis3n/actions/workflows/cron.yml)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/artis3n/kali-artis3n)](https://github.com/artis3n/kali-artis3n/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/artis3n/kali)](https://hub.docker.com/r/artis3n/kali)
![GitHub last commit](https://img.shields.io/github/last-commit/artis3n/kali-artis3n)
![GitHub](https://img.shields.io/github/license/artis3n/kali-artis3n)
[![GitHub followers](https://img.shields.io/github/followers/artis3n?style=social)](https://github.com/artis3n/)
[![Twitter Follow](https://img.shields.io/twitter/follow/artis3n?style=social)](https://twitter.com/Artis3n)

The [kalilinux/kali-rolling](https://www.kali.org/docs/containers/official-kalilinux-docker-images/) container comes with no pre-installed services.
It is meant to be lightweight and clocks in around 118 MB.
You must configure every service and tool you need from that base image.

This container, uncompressed, is around 4.7 GB (or 2.4 GB without wordlists).
It installs and pre-configures a number of frequently uses Kali tools.
It is meant to allow you to quickly get up and running with a Kali environment on an ephemeral host.
Don't spend time configuring and tweaking - pull, run, execute, pwn.

## Wordlists

A premium is placed on keeping this image as small as is reasonable given its intended purpose.
For example, `searchploit` is installed in this image but `exploitdb-papers` is not installed because this increases the image size by 6GB.

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

<small>Last checked: 2022-02-18</small>

The container is not meant for a persistent attacker environment.
The intention is for a quick environment to run attacks and document the results outside of the container.
The container does not expect a mounted volume for persistent storage - although, like any container, storage inside the container will remain until you `docker rm` and you may set up volumes as you prefer.

## Usage

Download the image:

- [Docker Hub](https://hub.docker.com/r/artis3n/kali)
- [GitHub Container Registry](https://github.com/artis3n/kali-artis3n/pkgs/container/kali)

```bash
docker pull artis3n/kali:latest
docker pull artis3n/kali:latest-no-wordlists
# or
docker pull ghcr.io/artis3n/kali:latest
docker pull ghcr.io/artis3n/kali:latest-no-wordlists
```

Run the container:

```bash
docker run --name kali -it --rm artis3n/kali:latest
# Or detach the container and run commands through it
docker run --name kali -id artis3n/kali:latest
docker exec -t kali nmap -p- 127.0.0.1
```

**Suggested**: Alias a command to the container, run commands through the container from your terminal with ease:

```bash
alias kali="docker exec -it kali"
kali sqlmap -u ...
```

![Docker Exec](/resources/docker-exec.png)

![Docker Exec AutoRecon](/resources/docker-exec-autorecon.png)

Get a terminal if you backgrounded the container:

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

## Contributions

Missing a tool you would like pre-configured? File a ticket and I will add it.
A pull request is also welcome.

For any new tools, you must add validation tests to `.github/workflows/ci.yml`. Use the existing tests as a baseline.
These tests ensure the tools are installed and pre-configured correctly.

### Recognition

Thanks [Anit Gandhi](https://github.com/anitgandhi) for help optimizing the Dockerfile and build images.
