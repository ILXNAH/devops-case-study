# 🛡️ DevSecOps Case Study
![Last Commit](https://img.shields.io/github/last-commit/ILXNAH/devops-case-study?color=blueviolet)
![Status](https://img.shields.io/badge/status-always%20in%20progress-0a8f08)
![Made with Love](https://img.shields.io/badge/made%20with-%E2%9D%A4-ff4088)
![License](https://img.shields.io/github/license/ILXNAH/devops-case-study?color=0066cc)
![Repo Size](https://img.shields.io/github/repo-size/ILXNAH/devops-case-study?color=999999)

📌 This README is bilingual. **For the Czech version (WIP), scroll down or click [here](#česká-verze).** <br> 
⏳ The English version is **TBD** and will be added soon.

## Repository Overview
This repository presents a DevSecOps case study exploring key concepts and practical applications in areas such as containerization, networking, Kubernetes, GitOps, and infrastructure automation.

⚠ This repository includes repository-specific Git configuration files (`git-config`) that reference a specific GitHub account and email address. Before using them, update the values to match your own details.

## Table of Contents
- [Repository Structure](#repository-structure)
- [Case Study Chapters](#case-study-chapters)
- [Setting Up the Repository](#setting-up-the-repository)
  - [Clone the Repository](#1-clone-the-repository)
  - [Set Up Git Hooks](#2-set-up-git-hooks)
  - [Verify Configuration](#3-verify-configuration)
- [License](#license)
- [Czech Version / Česká verze](#česká-verze)

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
├── en/           
│   ├── README.md           
│   ├── gitops.md
│   ├── kubernetes.md
│   ├── monitoring.md
│   ├── networking.md
│   ├── security.md
│   ├── sources.md
```

## Case Study Chapters
- [Case Study Navigation](en/README.md)
- [GitOps](en/gitops.md)
- [Kubernetes](en/kubernetes.md)
- [Monitoring](en/monitoring.md)
- [Networking](en/networking.md)
- [Security](en/security.md)
- [Sources](en/sources.md)

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

> *Git hooks are scripts that run automatically at specific points in the Git workflow.  
> In this repository, the `post-checkout` hook ensures that after switching branches or checking out the repository, the correct Git configuration is applied.*  

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

## License
This project is licensed under the MIT License.

---

# Česká verze

## Přehled repozitáře
Tento repozitář představuje případovou studii DevSecOps, která zkoumá klíčové koncepty a praktické aplikace v oblastech jako je	kontejnerizace, sítě, Kubernetes, GitOps a automatizace infrastruktury.

⚠ Tento repozitář obsahuje specifické Git konfigurační soubory (`git-config`), které odkazují na konkrétní GitHub účet a e-mailovou adresu. Před jejich použitím si hodnoty upravte podle vlastních údajů.

## Obsah
- [Struktura repozitáře](#struktura-repozitáře)
- [Kapitoly případové studie](#kapitoly-případové-studie)
- [Jak nastavit repozitář](#jak-nastavit-repozitář)
  - [Naklonování repozitáře](#1-naklonování-repozitáře)
  - [Nastavení Git hooků](#2-nastavení-git-hooků)
  - [Ověření konfigurace](#3-ověření-konfigurace)
- [Licence](#licence)

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
│   ├── README.md
│   ├── bezpečnost.md
│   ├── gitops-cz.md
│   ├── kubernetes-cz.md
│   ├── monitoring-cz.md
│   ├── síťování.md       
│   ├── zdroje.md             
```

## Kapitoly případové studie
- [Navigace případovou studií](cz/README.md)
- [Bezpečnost](cz/bezpečnost.md)
- [GitOps](cz/gitops-cz.md)
- [Kubernetes](cz/kubernetes-cz.md)
- [Monitoring](cz/monitoring-cz.md)
- [Síťování](cz/síťování.md)
- [Zdroje](cz/zdroje.md)

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

> *Git hooky jsou skripty, které se automaticky spouštějí v určitých fázích Git workflow.  
> V tomto repozitáři `post-checkout` hook zajišťuje, že po přepnutí větve nebo klonování repozitáře bude správně nastavena Git konfigurace.*  

### 3. Ověření konfigurace
⚠ Pokud používáte tento repozitář, ujistěte se, že jste v souboru `git-config` aktualizovali údaje s vaším vlastním e-mailem a GitHub uživatelským jménem před odesláním změn. Pro ověření, že byla Git konfigurace úspěšně aplikována, spusťte:
```bash
git config --local --list
```
Měl by se zobrazit řádek podobný:
```
include.path=./git-config
```

## Licence
Tento projekt je licencován pod MIT licencí.