# GitOps

## GitOps - definice a funkce
GitOps je jedna z metodologií řízení **DevOps** (vývoje softwaru a provozu aplikací), která je založená na principu **Everything as Code**.  
Celý stav infrastruktury a aplikací (**konfigurace, manifesty Kubernetes, Infrastructure as Code**) je popsán a uložen v open-source verzovacím systému (**VCS**) **Git**, tedy v Git repozitáři, který slouží jako jediný zdroj pravdy (**SSOT – Single Source of Truth**).
- GitOps umožňuje **rychlejší a efektivnější nasazení**, vyšší bezpečnost a spolehlivost.
- Základním cílem je mít úložiště v Gitu, které obsahuje popis infrastruktury vč. všech změn, které jsou:
  - **auditovatelné,** 
  - **verzované,**
  - **automaticky testovatelné,** 
  - **podléhající kódovým revizím**.
- V Kubernetes funguje **GitOps operátor** (např. **Argo CD**), který sleduje repozitář a **automaticky aplikuje změny** na cluster nebo spustí nasazení (**pull request → review → schválení**), případně upozorní na manuální změny a vrátí je zpět.

---

## Helm a jeho využití  
**Helm** je správce balíčků pro Kubernetes, který zjednodušuje a standardizuje nasazování, správu a aktualizaci aplikací v Kubernetes clusterech. Usnadňuje orchestraci komplexních aplikací a umožňuje jejich deklarativní nasazení.
- Deklarativní přístup: definuje cílový stav bez konkretizace a popisu jednotlivých kroků.

### Funkce a výhody Helmu
- **Zjednodušuje nasazení:** Automatizuje nasazení aplikací v Kubernetes pomocí balíčků **Helm Charts**.
- **Umožňuje verzování a rollback:** Snadno verzuje nasazení aplikací a umožňuje rychlý rollback na předchozí verze.
- **Podporuje konfiguraci napříč prostředími:** Parametrizace a šablonování konfigurací pro opakovatelné nasazení v různých prostředích.
- **Zjednodušuje správu komplexních aplikací:** Spravuje složité aplikace s více závislostmi jako jeden celek.
- **Usnadňuje sdílení a spolupráci:** Využití a sdílení hotových Helm Charts z veřejné knihovny.
- **Integrace s GitOps:** Podpora automatizovaného nasazování s nástroji jako ArgoCD a FluxCD.
- **Efektivní správa závislostí:** Jednoduchá správa závislostí a připojování externích služeb.

### Struktura Helmu
Každý Helm Chart obsahuje několik základních souborů:  
```plaintext
my-chart/
│── charts/          # Závislosti (jiné Helm Charts)
│── templates/       # Kubernetes YAML šablony
│── values.yaml      # Konfigurační soubor (přepsání defaultních hodnot)
│── Chart.yaml       # Metadata chartu
│── README.md        # Dokumentace k chartu
```
- **`values.yaml`** – definuje konfigurační hodnoty aplikace, které lze snadno měnit při nasazení.  
- **`templates/`** – obsahuje Kubernetes manifesty ve formě šablon, které jsou vyplňovány podle `values.yaml`.  
- **`Chart.yaml`** – definuje metadata chartu (název, verzi, popis).  

### Praktické využití Helmu
#### Nasazení aplikace pomocí Helmu
```bash
helm install moje-aplikace ./my-chart --namespace default
```
- **`install`** – příkaz k nasazení aplikace  
- **`moje-aplikace`** – název aplikace  
- **`./my-chart`** – cesta k Helm Chartu  

#### Aktualizace aplikace pomocí Helmu
```bash
helm upgrade moje-aplikace ./my-chart
```
- **`upgrade`** – provede aktualizaci aplikace na základě nové konfigurace v chartu  

#### Odstranění aplikace spravované Helmem
```bash
helm uninstall moje-aplikace
```
- **`uninstall`** – odstraní nasazenou aplikaci a uvolní přidělené zdroje  

---

## ArgoCD a jeho role v CI/CD pipeline
**Argo CD** je **nástroj pro kontinuální nasazování (CD) v Kubernetes**, který automatizuje nasazování aplikací **podle GitOps principů**.
- **Automatická synchronizace aplikací** s definovaným stavem v Git repozitáři (**Git jako zdroj pravdy**).
- **Podpora Helm, Kustomize, Jsonnet a plain YAML manifestů**.
- **RBAC (Role-Based Access Control) pro řízení přístupů**.
- **Rozhraní přes CLI i web**, umožňující snadnou správu nasazení.
- **Monitoring a alerting** (dashboardy, health checks, webhooks, napojení na Grafanu, Prometheus, ELK apod.).