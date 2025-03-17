# Bezpečnost (Security)

## Definice a mechanismus SSL/TLS
**SSL** (= Secure Sockets Layer) je komunikační protokol/soubor pravidel a šifrovací standard z roku 1995, který vytváří bezpečné spojení mezi dvěma zařízeními nebo aplikacemi na síti.  

- Pro důvěryhodnost a autentifikaci protistrany a vytvoření šifrovaného komunikačního kanálu se používá proces **“handshaku”** (v případě **TLS** zkrácený oproti SSL) a ověření pomocí **digitálního certifikátu** vydaného **certifikační autoritou (CA)**.  
- Následně se **šifrují data mezi klientem a serverem**, aby se zabránilo odposlechu a manipulaci s daty, což zajišťuje **integritu dat**.  
- **Původní SSL je zastaralý** (kvůli existujícím zranitelnostem), jeho nástupcem je **TLS**.

### **Příklad:**
1. **Prohlížeč se připojí k webovému serveru** přes `https://...`
2. **Server odešle (TLS) certifikát**  
3. **Prohlížeč ho ověří** (expirace, autorita, doména)  
4. **Vytvoří se bezpečná šifrovaná relace**  
5. **Prohlížeč a server bezpečně komunikují**  
6. **Uživatel vidí ikonu zámku 🔒**, což potvrzuje bezpečnost spojení  

---

## RBAC (Řízení přístupu na základě rolí)
- RBAC (Role-Based Access Control) je bezpečnostní model, který **se používá pro autorizaci uživatelů** na základě jejich definovaných rolí.
- Využití RBAC **zjednodušuje procesy a politiky správy identit a přístupů (IAM)**, **zefektivňuje** přiřazování oprávnění, **chrání citlivá data** a **napomáhá dodržování legislativních požadavků na ochranu osobních údajů**, jako je například GDPR.

---

## ConfigMap vs. Secret
V Kubernetes je klíčové efektivně a bezpečně spravovat konfiguraci aplikací.  **ConfigMap** a **Secret** jsou dva základní objekty, které slouží k ukládání konfiguračních dat, avšak se **zásadními rozdíly v bezpečnostním provedení**.  Volba mezi nimi závisí na citlivosti ukládaných dat.

### **ConfigMap:**  
- Uchovává běžná konfigurační data (např. URL, název služby, proměnné, CLI args) v plaintextové podobě.  
- Oddělení konfigurace slouží k jednodušší manipulaci a větší flexibilitě image, redukuje velikost image.  
- Není určena pro citlivá data (data jsou nešifrovaná).

#### Výhody Oddělení ConfigMap od Aplikace (Kubernetes Best Practice)
- **Flexibilita a správa konfigurace**
    - Neměnný aplikační kód, flexibilní konfigurace – aplikace nemusí být znovu sestavena při změně konfigurace.
    - Podpora více prostředí (dev/test/prod) bez nutnosti měnit image aplikace.
    - Podpora sdílené konfigurace mezi více aplikacemi.
    - Možnost verzování konfigurace → snadná integrace s GitOps (ArgoCD, FluxCD).
    - Podpora rollbacku a rolloutu při změně konfigurace.
- **Rolling Updates a Hot Reload**
    - Podpora rolling updates – při změně ConfigMap lze provést postupnou aktualizaci podů bez výpadku služby.
    - Podpora hot reload → změna konfigurace bez restartu aplikace (pokud aplikace podporuje).
    - Možnost rollbacku na předchozí verzi konfigurace bez restartu aplikace.
- **CI/CD a testování**
    - Automatizace nasazení v CI/CD pipeline.
    - Podpora testování (unit testy, integrační testy).
    - Podpora monitoringu a logování → auditní stopa změn konfigurace.
- **Efektivní správa konfigurace**
    - Možnost používat stejný image v různých prostředích bez úpravy kódu (jen změna ConfigMap).
    - Možnost sdílení ConfigMap mezi více aplikacemi.
    - Vhodné pro ukládání proměnných prostředí, názvů služeb, URL a dalších parametrů.

### **Secret:**  
- Uchovává citlivá data (např. hesla, API klíče, certifikáty, tokeny) v textu zakódovaném base64 (základní úroveň ochrany, ale nešifrovaná).  
- Oproti ConfigMap má limitaci velikosti na 1 MB (kvůli ukládání na etcd).  
- Možnost dodatečného zabezpečení: skrze politiku RBAC (role-based access control) a šifrování.  

---

## Service Mesh (Síť služeb) – co to je a jaké známe?
- Konfigurovatelná softwarová vrstva pro architektury mikroslužeb.
- Řídí a spravuje konektivitu mezi mikroslužbami, čímž zajišťuje jejich správnou funkčnost a celkovou funkčnost aplikace.
- Poskytuje klíčové funkce, jako jsou:
    - Zabezpečená komunikace: (maskování IP adres, šifrování pomocí mTLS).
    - Vyhledávání služeb.
    - Vyvažování zátěže (Load Balancing).
    - Autentizace a autorizace služeb.
- Klíčovou součástí je proxy server, který se obvykle nasazuje společně s každou mikroslužbou (**sidecar model**).
- Často je integrován na kontejnerové orchestrátory (například Kubernetes).
- Mezi nejrozšířenější nástroje v kontextu Kubernetes patří: **Istio**, **Linkerd**, **Consul**.

---

## Disaster Recovery pro Kubernetes cluster
- Hlavní je zálohování etcd a manifestů aplikací.  
- Automatizace záloh etcd je možná přímo v K8s vytvořením ConfigMapy pro zálohovací **sh** skript a **CronJobu**, který bude zálohovat např. do AWS S3 nebo NFS.  
- Manifesty se mohou automaticky zálohovat přes **GitOps** nebo open-source nástroj **Velero** (např. do AWS S3), který má podporu pro plánované zálohy.  
- Záloha **perzistentních dat PV/PVC a externích služeb** (v případě externího uložiště je třeba zapnout v cloudu snapshotování); pro plnou zálohu clusteru včetně **perzistentních dat** je možné nainstalovat a použít nástroje jako **Velero, Kasten K10** apod.  
- Za předpokladu použití metodiky **GitOps** je specifický stav nasazení automaticky uložený v **Git repozitářích** (může být včetně **Secrets** a **ConfigMaps**).  
- Pro nastavení správné strategie zotavení po havárii je třeba specifikovat parametry pro:  
  - Maximální dobu obnovy (RTO),  
  - Maximální datovou ztrátu (RPO),  
  - Navolení typu zálohy **aktivní-aktivní** nebo **aktivní-pasivní**,  
  - Lokace úložišť záloh a jejich zabezpečení (šifrování),  
  - Definice nutné dostupnosti (High Availability).  
- Je možná **automatizace obnovy/nasazení** zálohovaných dat clusteru přes **ArgoCD**.