# GitOps

## Co je GitOps?
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

## Co je Helm?
**Helm** je správce balíčků pro Kubernetes, který zjednodušuje a standardizuje nasazování aplikací do clusteru.

- **Automatizuje nasazení a správu Kubernetes aplikací** pomocí tzv. **Helm Charts**.
- **Umožňuje snadné verzování a rollback** aplikací.
- **Podporuje parametrizaci a šablonování konfigurací**, což usnadňuje opakovatelné nasazení aplikací v různých prostředích.
- Původně vyvinutý společností **Deis**, dnes součást Microsoftu.

---

## Co je Argo CD?
**Argo CD** je **nástroj pro kontinuální nasazování (CD) v Kubernetes**, který automatizuje nasazování aplikací **podle GitOps principů**.

- **Automatická synchronizace aplikací** s definovaným stavem v Git repozitáři (**Git jako zdroj pravdy**).
- **Podpora Helm, Kustomize, Jsonnet a plain YAML manifestů**.
- **RBAC (Role-Based Access Control) pro řízení přístupů**.
- **Rozhraní přes CLI i web**, umožňující snadnou správu nasazení.
- **Monitoring a alerting** (dashboardy, health checks, webhooks, napojení na Grafanu, Prometheus, ELK apod.).
