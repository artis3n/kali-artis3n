FROM kalilinux/kali-rolling:latest
LABEL maintainer="Artis3n"

RUN apt-get update && apt-get full-upgrade -y --no-install-recommends \
    && apt-get install -y --no-install-recommends systemd seclists python3 python3-pip \
    python3-wheel python3-setuptools git gcc make build-essential sudo curl less vim \
    metasploit-framework nmap ssh-client manpages file zip john hydra lsof \
    # autorecon dependencies
    samba gobuster nikto whatweb onesixtyone oscanner enum4linux smbclient \
    proxychains4 smbmap smtp-user-enum snmpcheck sslscan tnscmd10g \
    # Has to run after systemd is installed
    # Needed for msfdb init
    && apt-get install -y --no-install-recommends systemctl \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    # Remove apt-get cache from the layer to reduce container size
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /tools \
    && git clone --depth 1 https://github.com/Tib3rius/AutoRecon.git /tools/AutoRecon \
    && cd /tools/AutoRecon && pip3 install -r requirements.txt \
    && ln -s /tools/AutoRecon/autorecon.py /usr/local/bin/autorecon

# For some reason it doesn't start on the first init but does on the second
RUN service postgresql start && msfdb init && msfdb init

WORKDIR /tools
CMD /bin/bash
