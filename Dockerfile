FROM kalilinux/kali-rolling:latest
LABEL maintainer="Artis3n"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-wheel python3-setuptools \
    metasploit-framework nmap ssh-client manpages john hydra exploitdb \
    file zip lsof curl vim sudo less \
    # autorecon dependencies
    samba gobuster nikto whatweb onesixtyone oscanner enum4linux smbclient \
    proxychains4 smbmap smtp-user-enum snmpcheck sslscan tnscmd10g seclists \
    # Slim down container size
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

# Install and configure AutoRecon
RUN mkdir /tools \
    && git clone --depth 1 https://github.com/Tib3rius/AutoRecon.git /tools/AutoRecon \
    && cd /tools/AutoRecon && pip3 install -r requirements.txt \
    && ln -s /tools/AutoRecon/autorecon.py /usr/local/bin/autorecon

# install dumb-init to use as PID1
RUN curl -L -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
    && chmod +x /usr/local/bin/dumb-init

RUN service postgresql start && msfdb init && service postgresql stop

ENV TERM=xterm

COPY docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "/bin/bash" ]
