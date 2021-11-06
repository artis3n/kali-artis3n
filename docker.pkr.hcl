variable "upstream_image" {
  type    = string
  default = "kalilinux/kali-rolling:latest"
}

variable "final_image_name" {
  type    = string
  default = "artis3n/kali"
}

packer {
  required_plugins {
    docker = {
      version = ">= 1.0.3"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "kali-base" {
  image  = var.upstream_image
  pull   = true
  commit = true
  changes = [
    "LABEL maintainer='Artis3n <dev@artis3nal.com>'",
    "ENV TERM=xterm-256color",
    "ENTRYPOINT /bin/bash",
  ]
}

build {
  name = "kali-base"
  sources = [
    "source.docker.kali-base",
  ]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
    ]
    inline = [
      "apt-get update",
      "apt-get install -y --no-install-recommends apt-utils",
      "apt-get install -y --no-install-recommends amass awscli curl dotdotpwn exploitdb file finger git hydra impacket-scripts john less locate lsof man-db metasploit-framework netcat-traditional nmap python3 python3-pip python3-setuptools python3-wheel socat ssh-client sqlmap tmux vim zip enum4linux gobuster nikto onesixtyone oscanner proxychains4 samba smbclient smbmap smtp-user-enum snmpcheck sslscan tnscmd10g whatweb",
      "apt-get autoremove -y",
      "apt-get autoclean -y",
      "rm -rf /var/lib/apt/lists/*",
    ]
  }

  provisioner "shell" {
    inline = [
      "mkdir /tools",
      "git clone --depth 1 https://github.com/Tib3rius/AutoRecon.git /tools/AutoRecon",
      "cd /tools/AutoRecon",
      "pip3 install -r requirements.txt",
      "chmod +x /tools/AutoRecon/autorecon.py",
      "ln -s /tools/AutoRecon/autorecon.py /usr/local/bin/autorecon",
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = var.final_image_name
      tag        = ["base"]
    }
  }
}

source "docker" "kali-final" {
  image  = "${var.final_image_name}:base"
  commit = true
  pull   = false
  changes = [
    "LABEL maintainer='Artis3n <dev@artis3nal.com>'",
    "ENV TERM=xterm-256color",
    "ENTRYPOINT /bin/bash",
  ]
}

build {
  name = "kali-final"

  sources = [
    "source.docker.kali-final",
  ]

  provisioner "shell" {
    inline = [
      "mkdir -p /usr/share/seclists",
      "git clone --depth 1 https://github.com/danielmiessler/SecLists.git /usr/share/seclists",
    ]
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /usr/share/wordlists",
      "cp /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz /usr/share/wordlists/",
      "cd /usr/share/wordlists",
      "tar -xzf rockyou.txt.tar.gz",
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = var.final_image_name
      tags = [
        "wordlists",
        "latest",
      ]
    }
  }
}
