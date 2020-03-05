FROM kalilinux/kali-rolling:latest
LABEL maintainer="Artis3n"
ENV TERM=xterm

RUN apt-get update \
    && apt-get install -y --no-install-recommends systemd seclists \
    python3 python3-pip python3-wheel python3-setuptools \
    git curl less vim metasploit-framework nmap ssh-client \
    manpages file zip john hydra lsof exploitdb awscli sqlmap \
    # autorecon dependencies
    samba gobuster nikto whatweb onesixtyone oscanner enum4linux smbclient \
    proxychains4 smbmap smtp-user-enum snmpcheck sslscan tnscmd10g \
    # Has to run after systemd is installed
    # Needed for msfdb init
    && apt-get install -y --no-install-recommends systemctl \
    # Slim down container size
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    # Remove apt-get cache from the layer to reduce container size
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /tools \
    # Install and configure AutoRecon
    && git clone --depth 1 https://github.com/Tib3rius/AutoRecon.git /tools/AutoRecon \
    && cd /tools/AutoRecon && pip3 install -r requirements.txt \
    && ln -s /tools/AutoRecon/autorecon.py /usr/local/bin/autorecon

RUN service postgresql start && msfdb init

# Need to start postgresql any time the container comes up
# systemctl enable postgresql doesn't seem to take effect
# I blame systemd, but this works at least
CMD service postgresql start && /bin/bash
