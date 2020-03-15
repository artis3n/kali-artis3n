FROM kalilinux/kali-rolling:latest
LABEL maintainer="Artis3n <dev@artis3nal.com>"

ENV TERM=xterm

RUN apt-get update \
    && apt-get install -y --no-install-recommends amass awscli curl \
    exploitdb file git hydra john less lsof man-db \
    metasploit-framework nmap python3 python3-pip python3-setuptools \
    python3-wheel ssh-client sslyze sqlmap systemd vim zip \
    # autorecon dependencies
    enum4linux gobuster nikto onesixtyone oscanner proxychains4 samba \
    smbclient smbmap smtp-user-enum snmpcheck sslscan tnscmd10g whatweb \
    # Has to run after systemd is installed
    # Needed for msfdb init
    && apt-get install -y --no-install-recommends systemctl \
    # Slim down layer size
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    # Remove apt-get cache from the layer to reduce container size
    && rm -rf /var/lib/apt/lists/*

RUN service postgresql start && msfdb init

# Install and configure AutoRecon
RUN mkdir /tools \
    && git clone --depth 1 https://github.com/Tib3rius/AutoRecon.git /tools/AutoRecon \
    && cd /tools/AutoRecon \
    && pip3 install -r requirements.txt \
    && ln -s /tools/AutoRecon/autorecon.py /usr/local/bin/autorecon

# Install Seclists
RUN mkdir -p /usr/share/seclists \
    # This clone takes a million years.
    # The apt-get install seclists command doesn't work from the Dockerfile, however.
    && git clone --depth 1 https://github.com/danielmiessler/SecLists.git /usr/share/seclists

# Prepare rockyou wordlist
RUN mkdir -p /usr/share/wordlists \
    && cp /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz /usr/share/wordlists/ \
    && cd /usr/share/wordlists \
    && tar -xzf rockyou.txt.tar.gz

# Need to start postgresql any time the container comes up
# systemctl enable postgresql doesn't seem to take effect
# I blame systemd, but this works at least
CMD service postgresql start && /bin/bash
