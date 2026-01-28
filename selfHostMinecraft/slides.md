# Self Hosting

> You've finally got your own home-server! Be it an old computer given new life, or a purpose built powerhouse, you probably want to do something with it. But how? In this showcase, we'll demonstrate from start to finish setting up and configuring a Minecraft server. Along the way we'll discuss several tools and terms (watch for wget, systemd services and NAT forwarding) to power up your self-hosting experience.

---

# Self Hosting

How to host a Minecraft server:

1. download the server
2. install java
3. make a system user to run the server
4. configure the world (Minecraft specific)
5. make a systemd service
6. be really cool (but understandable) while we do it

---

# Download the server file `server.jar` with wget

`wget` is a useful tool for (among other things) downloading things without needing a browser.

```
wget [OPTION]... [URL]...
```

```
wget https://piston-data.mojang.com/v1/objects/64bb6d763bed0a9f1d632ec347938594144943ed/server.jar
```

---

# install java on server

Minecraft 1.21 requires java 20. Apt only has up to jdk (java development kit) 17? I needed to add the experimental branch "sid" to find `openjdk-21-jdk-headless`.
(If you use apt and need this, feel free to ask about this step at #tech-support!)

```
apt search openjdk
sudo apt install openjdk-21-jdk-headless
```

Always a good idea to verify the version that `java` points to. 

```
java --version
```

---
# Making a User For Our Service

We could run the server under `samuel`, but then `trongle` has a harder time managing it. We could also run it under `root` since Samuel and Trongle both have `sudo` access, but that's scary. Instead let's make a new user.

```bash
sudo useradd -rmd /srv/minecraft minecraft
```
- `-r` make a system user
- `-m` make the home directory (even though this is a system user)
- `-d DIR` change the default home directory (instead of `/home/USERNAME`)

We can switch to being the `minecraft` user.
```bash
sudo -su minecraft
```
Note that `cd` now takes us to `/srv/minecraft`

We can delete this user in the future with
```bash
sudo userdel -r minecraft
```

---

# What is Systemd?

Systemd (not a typo) is likely your system's `init` program. What's that?

In simple terms, the Kernel (Linux) is responsible for executing programs, but the only program it starts is `init` (systemd, unless you know it's something else). `init` is in turn responsible for starting all of the other programs on your machine, ranging from low level tasks like wireless communications (wifi and bluetooth) to high level programs like your desktop and terminal. Once these programs have started, `init` continues running and managing programs, restarting them or starting new ones as needed.

For more info, check out `man 1 systemd` and `man 5 systemd.services`.

We want to tell systemd that minecraft is a program we want to start when the computer turns on, and to restart whenever it stops running.

---

# An Example (Silly) Systemd Service

Can you guess what this service does? (We place it in `/etc/systemd/system/annoying-file.service`)

```
[Unit]
Description= annoying-file service

[Service]
ExecStart=/usr/local/bin/annoying_file.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Where `/usr/local/bin/annoying_file.sh` contains:
```bash
#!/bin/bash
echo "This is a real nusance" >> /home/xeyler/ANNOYINGFIEL
```

---
# Managing Systemd Services

We can start or stop systemd services, which is immediate and temporary.
```
sudo systemctl start SERVICE_NAME.service
sudo systemctl stop SERVICE_NAME.service
sudo systemctl restart SERVICE_NAME.service
```
We can also enable or disable services to tell them to try to always be running.
```
sudo systemctl enable SERVICE_NAME.service
sudo systemctl disable SERVICE_NAME.service
```
The key is that enabled services will start when the computer turns on, even if you stoped the service in a previous session.

---
# Minecraft Systemd Service

`/etc/systemd/system/fslc-minecraft-server.service`
```
[Unit]
Description= fslc-minecraft-server service
After=network.target
Wants=network.target
StartLimitBurst=5
StartLimitIntervalSec=120

[Service]
User=minecraft
WorkingDirectory=/srv/minecraft/
ExecStart=/srv/minecraft/start.sh
Restart=always
RestartSec=5
Type=exec

[Install]
WantedBy=multi-user.target
```

Where `/srv/minecraft/start.sh` contains:
```bash
#!/bin/bash
java -Xmx8192M -Xms4096M -jar /srv/minecraft/server.jar nogui
```

---

# Port Forwarding, But Not How to Do It ):

*Fun Fact!:* There are approximately 28 IPv4 IP addresses per square kilometer on earth's land.

*Fun Fact!:* USU pretty much fits in a square kilometer.

*Problem:* There are *way* too many computers (with IP addresses) for the internet to work.

*Solution:* Your router has one IP address, and all of your devices connected to it are not on the internet. They talk to your router which in turn talks to the internet. 

*Problem:* Nobody on the internet (including yourself) can find your computer (and your server).

*Solution:* Network Address Translation (NAT) and Port Forwarding. It looks pretty much the same for every router on the planet, but slightly different for pretty much every router on the planet.


