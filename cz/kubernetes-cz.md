# Kubernetes

## Co je kontejner a jak se liší od virtuálního stroje (VM)?
### Kontejner
- Kontejner je balíček obsahující mikroslužbu spolu s jejími závislostmi a konfiguracemi. 
    - Typicky je navržen tak, aby v kontejneru běžel jeden proces.
- Obsahuje pouze aplikaci a nezahrnuje celý operační systém.
- Má menší nároky na systémové zdroje, které jsou sdílené s hostitelským operačním systémem.
- Je charakteristický rychlostí a dobrou škálovatelností, díky čemuž je hojně využíván v mikroservisních architekturách (například v telekomunikacích nebo bankovnictví).
- Osobní zkušenost: Docker a OpenShift (aplikační podpora + automatizace), méně Kubernetes (OpenShift je platforma postavená na Kubernetes).

### Virtuální stroj (VM)
- Má vlastní OS = vlastní přidělené zdroje (CPU, RAM, disk, síť přidělené hypervizorem).
- Běží na hypervizoru (např. VMware, VirtualBox, Hyper-V).
- Vhodnější pro plnohodnotnou izolaci (např. kyberbezpečnost, testování malwaru v Kali Linux).

Hybridní přístup: WSL (WSL 2 má vlastní kernel, ale využívá kontejnerové funkce namespaces a cgroups).

---

## Co je Kubernetes?
- Kubernetes je open-source platforma pro orchestraci kontejnerů.
- Automatizuje procesy nasazování, škálování a správy kontejnerizovaných aplikací.
- Původně byl Kubernetes navržen společností Google a v současnosti je spravován pod záštitou organizace CNCF (Cloud Native Computing Foundation).

---

## Co je Kubectl a Kubelet?
### Kubectl
- Kubectl je nástroj příkazové řádky (CLI) určený pro interakci s Kubernetes clustery.
- Slouží jako primární rozhraní pro správu a kontrolu zdrojů Kubernetes.
- Běžně se používá k nasazování aplikací, škálování zátěží, monitorování, diagnostice a administraci clusteru.
- Uživatel má k dispozici lokálně uložený konfigurační soubor, který umožňuje snadné přepínání mezi různými clustery.

### Kubelet
- Kubelet je agent, který běží na každém nodu (uzlu), což je server, na kterém běží kontejnery a představuje základní výpočetní jednotku clusteru.
- Kubelet řídí kontejnery a aktivně usiluje o dosažení a udržení jejich požadovaného stavu.
- Kubelet komunikuje s řídicí rovinou (Control Plane) a zajišťuje, že kontejnery jsou spuštěny a běží správně.
- Vytváří a spravuje jednotlivé pody a komunikuje s kontejnerovým runtime (například Docker, containerd) prostřednictvím API rozhraní (CRI – Container Runtime Interface).
    - **Pod:** Pod je nejmenší adresovatelná jednotka v Kubernetes, která může obsahovat jeden nebo více kontejnerů.

---

## Součásti řídicí roviny Kubernetes (Control Plane)
### kube-apiserver
- Představuje centrální bod pro interakci s clusterem prostřednictvím HTTP API.
- Zajišťuje správu autentizace, autorizace a validaci příchozích požadavků.
- Ukládá informace o stavu clusteru do etcd.

### etcd
- Jedná se o nerelační databázi, která slouží k ukládání všech dat clusteru, včetně jeho konfigurace, aktuálního stavu, politik a metadat.
- Zajišťuje konzistentní a dostupný stav clusteru.
- Je to kriticky důležitá komponenta pro obnovu a celkovou správu clusteru.

### kube-scheduler
- Komponenta zodpovědná za rozhodování o umístění podů na konkrétní nody.
- Vyhodnocuje výběr nejvhodnější node na základě dostupných zdrojů, definovaných politik a pravidel.

### kube-controller-manager
- Spravuje kontrolery, které implementují řídicí logiku chování Kubernetes API. Mezi typické funkce patří například:
      - Správa počtu replik podů.
      - Nasazování aplikací, verzování a škálování.
      - Správa, monitorování, kontrola a aktualizace stavu nodů, zajištění dostupnosti podů (včetně migrace při selhání nodu).

### cloud-controller-manager
- Slouží k zajištění integrace Kubernetes s cloudovými poskytovateli (CSP) – volitelná komponenta.
- Spravuje cloudové zdroje, jako jsou load balancery, disky a síťové adresy.

---

## Role etcd v Kubernetes
etcd je distribuovaná databáze, která se v Kubernetes používá k ukládání stavu clusteru a jeho konfigurace.
- Při vytvoření nového podu nebo jiného objektu v Kubernetes API server zapíše tuto změnu do etcd.
- Řadiče (Controllers) a plánovač (Scheduler) čtou informace z etcd (prostřednictvím API serveru) a na základě těchto informací provádějí příslušné akce (například správa replik a Secretů, monitorování nodů, přiřazování podů k nodům, vyvažování zátěže mezi nody).
- etcd běží jako cluster s více nody, kde jeden node funguje jako leader a ostatní jako followeři, kteří synchronizují data. 
    - Je nezbytné zajistit vysokou dostupnost (HA) a prevenci selhání jednoho bodu (SPoF), protože API server je závislý na etcd a bez něj by nemohl provádět žádné změny v clusteru – například škálování, nasazování nebo aktualizace.

---

## Co je to Namespace (Jmenný prostor)?
- Namespace je jednotka seskupení v rámci Kubernetes clusteru, která slouží k logickému rozdělení prostředí.
    - Například podle aplikace, týmu, typu prostředí (vývojové, testovací, produkční) nebo pro organizaci objektů.
- Jedná se o logické rozdělení clusteru pro izolaci aplikací (například vývojových, testovacích a produkčních prostředí).
- Namespace může obsahovat vlastní prostředky, jako jsou Pody, Služby, ConfigMapy a další objekty (například ReplicaSet, Secret, Ingress a další).

---

## Základní objekty v Kubernetes
- Pod, Deployment, ReplicaSet, StatefulSet, DaemonSet, PersistentVolume, Service, Namespace, ConfigMap, Secret, Job ...

---

## Typy Service (Služeb) v Kubernetes
- **ClusterIP:** Zpřístupnění aplikace na interní IP adrese. Vhodné pro interní služby, dostupné pouze uvnitř clusteru.
- **NodePort:** Kromě ClusterIP přidává možnost externího přístupu přes statický port na IP adrese každé node v clusteru (`IP:static_port`).
- **LoadBalancer:** Zpřístupnění přes externí Load Balancer s vlastní veřejnou IP adresou. Ideální pro produkční aplikace s vysokým provozem.
- **ExternalName:** Překlad na externí DNS název bez proxy nebo load balancingu. Používá se pro připojení ke službám mimo Kubernetes cluster (například externí služby nebo služby hostované jinde). Provoz je směrován přímo na externí hostname prostřednictvím CNAME záznamu poskytovaného DNS serverem Kubernetes.

---

## Ephemeral storage (Dočasné úložiště)
- Úložiště, které existuje pouze po dobu životního cyklu podu.
- Po smazání nebo restartování podu se toto úložiště vymaže.
- Používá se pro data, u kterých není vyžadováno dlouhodobé uchování, například procesní logy, cache nebo dočasné soubory obsahující tajné klíče či konfigurační data.
- Obvykle je uloženo v lokálním úložišti příslušné node (například na disku fyzického serveru).
- Specifikace se provádí v `Pod spec`
- Jednotlivé typy `emptyDir`, `configMap`, `downwardAPI` a `secret` jsou spravovány kubeletem na každé node.

---

## Anotace vs. Labely
- **Labely:**
    - Labely se používají k identifikaci a organizaci objektů v Kubernetes (zejména pro účely výběru a filtrování).
    - Selekce objektů na základě label je užitečná pro operace, jako je nasazování, aktualizace nebo škálování aplikací.
- **Anotace:**
    - Anotace slouží k ukládání podrobných metadat, například časových razítek, verzí nebo odkazů na externí zdroje.
    - Anotace poskytují rozšířený kontextuální informace o objektu, ale nemají vliv na selekci objektů (podů, služeb, jmenných prostorů, Secretů, ConfigMap apod.).

---

## Pod vs. Kontejner
- **Pod** je nejmenší nasaditelná jednotka v systému Kubernetes.
    - **Pod** může obsahovat jeden či více kontejnerů.
    - **Pod** je spravován komponentou kubelet, což je agent běžící na každém nodu (uzlu) v clusteru.
- **Kontejner** je běžící instance image, která je součástí podu.
- Seskupení kontejnerů v podu je výhodné pro:
    - Logické uspořádání a sdílení zdrojů (například IP adresy a úložiště).
    - Konfiguraci systému orchestrace (například pro účely nasazování aplikací).
    - Zajištění centralizovaného logování.
    - Implementaci zabezpečení (například maskování IP adres pomocí proxy serveru).
    - Potřeby formátování dat a podobné účely.

---

## Postup instalace Kubernetes clusteru v on-premise prostředí
- Instalace kubeadm, kubelet, kubectl.
- Inicializace clusteru (kubeadm init).
- Konfigurace síťování (CNI pluginy jako Calico, Flannel).
- Připojení worker nodes (kubeadm join).

---

## Postup upgradu Kubernetes clusteru v on-premise prostředí
- Záloha etcd a aplikačních dat.
- Postupná aktualizace kubeadm, kubelet a kubectl.
- Restart kubelet na všech nodech.
- Otestování a monitoring clusteru po aktualizaci.