# Ravengate (WIP)
A modern high throughput Mail Storage Server without legacy debit.

### Features
- Virtual mailboxes and domains
- Email storage and metadata management
- Full-text search indexing and predictive text
- End to End encryption
- Open PGP support
- REST API for web client
- Static SPA web interface
- No protocols

### Dependencies
- Haraka: SMTP server
- FoundationDB: Database
- Nginx: Reverse proxy and static file serving
- Go: Backend runtime

### Install
First install [Just](https://github.com/casey/just)
#### Arch
```
sudo pacman -Syu just
```
#### Debian
```
wget https://github.com/casey/just/releases/download/1.40.0/just-1.40.0-x86_64.deb
sudo dpkg -i just-1.40.0-x86_64.deb
sudo apt-get install -f
```
#### MacOS 
```
brew install just
```

Verfiy install 
```
just --verify
```

Then cross your fingers and try to run the following from the project root.
View the `justfile` for more details. Respectively: 

`ex` makes the scripts executable.

`just install-nvm` Installs NVM and uses the lastest Node version.

`just haraka-install` Installs Haraka.

`haraka-init` Creates the Haraka service at ./mail-stack/haraka/service using default.

`haraka-init-1` Creates the Haraka service using the default project config, plugins and setup.

`haraka-run` 

`haraka-ssl` Generate SSL key and cert.

`email-in` Send a test inbound email locally

`install-nats-server` 

`nats-jetstream-setup` Setup NATS JetStream config 

`nats-jetstream-enable-services` 

`nats-cli-i` Install NATS cli

`nats-verify` Verify NATS cli

Julien Etienne 2025
