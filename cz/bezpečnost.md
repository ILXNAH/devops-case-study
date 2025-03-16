## Co je RBAC?  
RBAC (Role-Based Access Control) je bezpečnostní model používaný pro autorizaci koncových uživatelů na základě jejich nadefinovaných rolí.  
- Jeho využití zjednodušuje procesy a politiky IAM, zefektivňuje přiřazování práv, chrání citlivá data a pomáhá k dodržování požadavků na ochranu údajů daných legislativními předpisy.  

## Co je etcd a k čemu slouží v Kubernetes?  
etcd je distribuovaná databáze používaná v Kubernetes k ukládání stavu clusteru a jeho konfigurace.  
- Při vytvoření nového podu nebo jiného objektu v K8s apiserver zapíše změnu do etcd.  
- Controller a scheduler čtou informace z etcd (skrze apiserver) a provádějí na základě toho příslušné akce (např. správa replik a secrets, node monitoring, přiřazení podů na nody, vyvážení zátěže mezi nody).  
- Běží jako cluster s více nody, kde je jeden leader a ostatní followers, které synchronizují data (je nutné zajistit HA/prevenci SPoF, protože apiserver závísí na etcd a nemohl by bez něj provádět žádné změny – škálování, nasazování, aktualizace).  

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