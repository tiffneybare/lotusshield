#  <img src="https://cdn.purplelotus.agency/saas/lotusshield-icon.png" width="60" alt="LotusShield Logo"> LotusShield
### Zero Cost ECC Wildcard SSL Automation for cPanel + Cloudflare
#### By Purple Lotus

LotusShield provides an elegant, automated solution for managing SSL certificates on cPanel hosting environments. It issues, renews, and installs wildcard ECC certificates for unlimited domains using Cloudflare DNS, acme.sh, and the cPanel UAPI.

You configure it once. LotusShield handles everything after that.

---

## Features

- ECC Only Security (EC-256) for modern performance
- Zero Cost Let’s Encrypt Wildcard Certificates
- Full Automation for renewal and installation
- Wildcard Support for *.domain.com
- Multi Domain Compatible
- cPanel UAPI Integration
- Cloudflare Integration using DNS-01
- Cron Ready
- Lightweight pure Bash scripts
- Purple Lotus branded for consistency across the ecosystem

---

## Repository Structure

```
lotus-shield/
  bin/
    ssl-issue-all.sh
    ssl-sync.sh
  config/
    domains.txt
  .env.example
  README.md
  LICENSE
```

---

## Quick Start

### 1. Install acme.sh

```bash
curl https://get.acme.sh | sh
source ~/.bashrc
```

Or if you use Zsh:

```bash
source ~/.zshrc
```

---

### 2. Clone LotusShield

```bash
git clone https://github.com/<your-handle>/lotus-shield.git
cd lotus-shield
```

---

### 3. Configure .env

```bash
cp .env.example .env
nano .env
```

Add:

- CPANEL_SERVER (example: https://cpanel.examplehost.com)
- CPANEL_USER
- CPANEL_TOKEN
- CF_Token
- CF_Account_ID

---

### 4. Add Domains

Edit:

```
config/domains.txt
```

Example:

```
example.com
demoapp.net
myagency.dev
sampleproject.org
```

---

### 5. Issue Certificates (One Time Setup)

```bash
./bin/ssl-issue-all.sh
```

This creates wildcard ECC certs inside:

```
~/.acme.sh/example.com_ecc/
```

---

### 6. Sync, Renew, and Install

```bash
./bin/ssl-sync.sh
```

This will:

- Renew any certificate expiring in 2 days or less
- Install certificates directly into cPanel
- Output results for each domain

---

## Automation Using Cron

Add this to your user cron:

```bash
crontab -e
```

```
0 2 * * * /path/to/lotus-shield/bin/ssl-sync.sh >> /var/log/lotusshield.log 2>&1
```

LotusShield now runs every night at 2 a.m.

---

## Why ECC

LotusShield standardizes on EC-256 because it is:

- Faster
- More secure per byte
- Lighter on CPUs
- Smaller in size
- Ideal for modern devices and browsers

ECC at EC-256 has strength equivalent to RSA 3072 while being significantly more efficient.

---

## Roadmap

LotusShield will continue to expand across several phases.

### Phase 1 - Core Automation (Complete)
- ECC wildcard issuance
- Renew and install workflow
- Multi domain support

### Phase 2 - LotusShield API
A small REST API layer to allow:

- GET /domains
- GET /status
- POST /sync
- POST /domain

This will enable remote management and integration into other apps.

### Phase 3 - LotusShield UI (React)
A modern dashboard for:

- Domain overview
- Certificate expiration visualization
- Add domain wizard
- Manual sync
- Logs
- Settings

### Phase 4 - LotusShield Agent
A one line installer that sets up LotusShield on new machines with automatic provisioning.

### Phase 5 - Additional Providers
Future support for:

- Other DNS providers
- Other hosting panels
- Direct NGINX or Apache deployment

---

## Example Use Cases

LotusShield is ideal for:

### Developers and Agencies
Manage SSL for multiple client domains with zero manual work.

### SaaS Builders
Wildcard certificates reduce complexity and improve onboarding.

### Entrepreneurs
Eliminate the cost of SSL and automate security.

### Home Lab Users
Add enterprise style automation to cPanel based home servers.

---

## Purple Lotus Philosophy

LotusShield reflects the Purple Lotus vision of clarity, simplicity, and empowerment.
Tools should work quietly in the background, remove friction, and elevate your technical ecosystem with elegance and intention.

---

## Contributing

Pull requests are welcome. Please submit issues for:

- Bugs
- Feature requests
- Documentation improvements

---

## Maintained By

**Purple Lotus**
Guided by clarity. Crafted with intention.

---

## License

[MIT](https://choosealicense.com/licenses/mit/)
