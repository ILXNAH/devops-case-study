# DevOps Case Study

📌 This README is bilingual. **For the Czech version, scroll down or click [here](#česká-verze).**

## Repository Overview
This repository contains a case study for a DevOps role, including various questions and answers related to containerization, networking, Kubernetes, GitOps, and infrastructure automation.

⚠ This repository includes repository-specific Git configuration files (`git-config`) that reference a specific GitHub account and email address. Before using them, update the values to match your own details.

## Table of Contents
- [Setting Up the Repository](#setting-up-the-repository)
  - [Clone the Repository](#1-clone-the-repository)
  - [Set Up Git Hooks](#2-set-up-git-hooks)
  - [Verify Configuration](#3-verify-configuration)
- [Repository Structure](#repository-structure)
- [License](#license)
- [Czech Version / Česká verze](#česká-verze)
  - [Jak nastavit repozitář](#jak-nastavit-repozitář)
  - [Struktura repozitáře](#struktura-repozitáře)
  - [Licence](#licence)

## Setting Up the Repository
To ensure the repository-specific Git configuration is applied automatically, follow these steps:

### 1. Clone the Repository
```bash
git clone https://github.com/ILXNAH/devops-case-study.git
cd devops-case-study
```

### 2. Set Up Git Hooks
Since Git does not track the `.git/hooks/` directory, you need to run the following setup script to install the required Git hooks:

```bash
./setup-hooks.sh
```

This script will:
- Copy the `post-checkout` hook from the `hooks/` directory to `.git/hooks/`.
- Ensure the script is executable.
- Apply the repository-specific Git configuration automatically.

### 3. Verify Configuration
⚠ If you use this repository, make sure to update `git-config` with your own email and GitHub username before committing any changes.
To confirm that the Git configuration was successfully applied, run:
```bash
git config --local --list
```
You should see a line similar to:
```
include.path=./git-config
```

## Repository Structure
```
devops-case-study/
├── .gitattributes
├── .gitignore
├── git-config
├── setup-hooks.sh
├── hooks/
│   └── post-checkout
├── README.md
├── cz/
├── en/                      
│   ├── kubernetes.md
│   ├── networking.md
│   ├── security.md
│   ├── gitops.md
│   ├── monitoring.md
```

## License
This project is licensed under the MIT License.

---

# Česká verze

## Přehled repozitáře
Tento repozitář obsahuje případovou studii pro roli DevOps, včetně různých otázek a odpovědí týkajících se kontejnerizace, sítí, Kubernetes, GitOps a automatizace infrastruktury.

⚠ Tento repozitář obsahuje specifické Git konfigurační soubory (`git-config`), které odkazují na konkrétní GitHub účet a e-mailovou adresu. Před jejich použitím si hodnoty upravte podle vlastních údajů.

## Obsah
- [Jak nastavit repozitář](#jak-nastavit-repozitář)
  - [Naklonování repozitáře](#1-naklonování-repozitáře)
  - [Nastavení Git hooků](#2-nastavení-git-hooků)
  - [Ověření konfigurace](#3-ověření-konfigurace)
- [Struktura repozitáře](#struktura-repozitáře)
- [Licence](#licence)

## Jak nastavit repozitář
Aby byla automaticky aplikována specifická Git konfigurace pro tento repozitář, postupujte následovně:

### 1. Naklonování repozitáře
```bash
git clone https://github.com/ILXNAH/devops-case-study.git
cd devops-case-study
```

### 2. Nastavení Git hooků
Protože Git standardně nesleduje adresář `.git/hooks/`, je nutné spustit následující skript pro instalaci požadovaných Git hooků:

```bash
./setup-hooks.sh
```

Tento skript:
- Zkopíruje hook `post-checkout` ze složky `hooks/` do `.git/hooks/`.
- Ujistí se, že je skript spustitelný.
- Automaticky aplikuje specifickou konfiguraci Git repozitáře.

### 3. Ověření konfigurace
⚠ Pokud používáte tento repozitář, ujistěte se, že jste v souboru `git-config` aktualizovali údaje s vaším vlastním e-mailem a GitHub uživatelským jménem před odesláním změn. Pro ověření, že byla Git konfigurace úspěšně aplikována, spusťte:
```bash
git config --local --list
```
Měl by se zobrazit řádek podobný:
```
include.path=./git-config
```

## Struktura repozitáře
```
devops-case-study/
├── .gitattributes
├── .gitignore
├── git-config
├── setup-hooks.sh
├── hooks/
│   └── post-checkout
├── README.md
├── cz/
│   ├── kubernetes-cz.md
│   ├── síťování.md
│   ├── bezpečnost.md
│   ├── gitops-cz.md
│   ├── monitoring-cz.md
├── en/                      
```

## Licence
Tento projekt je licencován pod MIT licencí.