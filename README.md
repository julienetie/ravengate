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
- Postfix: SMTP server
- MariaDB: Database
- Nginx: Reverse proxy and static file serving
- Go 1.23.2+: Backend runtime

### Install (Debian)

```bash 
sudo apt update
sudo apt install postfix postfix-mysql mariadb-server
```

Notes 
```
/etc/postfix/mail_accounts.cf

user = mailuser
password = mailpass
hosts = 127.0.0.1
dbname = mail_accounts
query = SELECT 1 FROM virtual_domains WHERE name='%s'

/etc/postfix/mail_accounts_map_emails_to_users.cf

user = mailuser
password = mailpass
hosts = 127.0.0.1
dbname = mail_accounts
query = SELECT 1 FROM virtual_domains WHERE name='%s'

/etc/postfix/mail_accounts_map_aliases.cf

user = mailuser
password = mailpass
hosts = 127.0.0.1
dbname = mail_accounts
query = SELECT 1 FROM virtual_domains WHERE name='%s'
```


Julien Etienne 2025