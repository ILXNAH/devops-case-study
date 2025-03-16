# Bezpečnost (Security)

## Co je a jak funguje SSL?
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

## Co je RBAC?  
RBAC (Role-Based Access Control) je bezpečnostní model používaný pro autorizaci koncových uživatelů na základě jejich nadefinovaných rolí.  
- Jeho využití zjednodušuje procesy a politiky IAM, zefektivňuje přiřazování práv, chrání citlivá data a pomáhá k dodržování požadavků na ochranu údajů daných legislativními předpisy.  

---

## Jaký je rozdíl mezi Secretem a ConfigMapou?  
### **ConfigMap:**  
- Uchovává běžná konfigurační data (např. URL, název služby, proměnné, CLI args) v plaintextové podobě.  
- Oddělení konfigurace slouží k jednodušší manipulaci a větší flexibilitě image, redukuje velikost image.  

### **Secret:**  
- Uchovává citlivá data (např. hesla, API klíče, certifikáty, tokeny) v textu zakódovaném base-64.  
- Oproti ConfigMap má limitaci velikosti na 1 MB (kvůli ukládání na etcd).  
- Možnost dodatečného zabezpečení: skrze politiku RBAC (role-based access control) a šifrování.  

---

## Jak řešit disaster recovery pro Kubernetes cluster včetně běžících aplikací v clusteru?  
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