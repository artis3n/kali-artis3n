FROM kalilinux/kali-rolling:latest AS base
LABEL maintainer="Artis3n <dev@artis3nal.com>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y --no-install-recommends amass awscli curl \
    dotdotpwn file finger git hydra impacket-scripts john less locate \
    lsof man-db netcat-traditional nmap python3 python3-pip python3-setuptools \
    python3-wheel socat ssh-client sqlmap tmux vim zip \
    # autorecon dependencies
    enum4linux gobuster nikto onesixtyone oscanner proxychains4 samba \
    smbclient smbmap smtp-user-enum snmpcheck sslscan tnscmd10g whatweb \
    # Slim down layer size
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    # Remove apt-get cache from the layer to reduce container size
    && rm -rf /var/lib/apt/lists/*

# Second set of installs to slim the layers a bit
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    exploitdb metasploit-framework \
    # Slim down layer size
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    # Remove apt-get cache from the layer to reduce container size
    && rm -rf /var/lib/apt/lists*

# Install and configure AutoRecon
RUN mkdir /tools \
    && git clone --depth 1 https://github.com/Tib3rius/AutoRecon.git /tools/AutoRecon \
    && cd /tools/AutoRecon \
    && pip3 install -r requirements.txt \
    && chmod +x /tools/AutoRecon/autorecon.py \
    && ln -s /tools/AutoRecon/autorecon.py /usr/local/bin/autorecon

ENV TERM=xterm-256color

ENTRYPOINT ["/bin/bash"]

FROM base AS wordlists

ARG DEBIAN_FRONTEND=noninteractive

# Install Seclists
RUN mkdir -p /usr/share/seclists \
    # The apt-get install seclists command isn't installing the wordlists, so clone the repo.
    && git clone --depth 1 https://github.com/danielmiessler/SecLists.git /usr/share/seclists

# Prepare rockyou wordlist
RUN mkdir -p /usr/share/wordlists \
    && cp /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz /usr/share/wordlists/ \
    && cd /usr/share/wordlists \
    && tar -xzf rockyou.txt.tar.gz
