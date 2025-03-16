# Kubernetes

## Co je kontejner a v čem se liší od VM?
### Kontejner:
= Balíček mikroslužeb společně s jejich závislostmi a konfiguracemi (jeden proces per kontejner).
- Obsahuje pouze aplikaci, ne celý OS.
- Je méně náročný na zdroje (sdílené s host OS).
- Je rychlejší a lépe škálovatelný – využívaný v mikroservisní architektuře (např. telco, banky).
- Osobní zkušenost: Docker a OpenShift (aplikační podpora + automatizace), méně Kubernetes (OpenShift je na Kubernetes založený).

### Virtuální stroj (VM):
- Má vlastní OS = vlastní přidělené zdroje (CPU, RAM, disk, síť přidělené hypervizorem).
- Běží na hypervizoru (např. VMware, VirtualBox, Hyper-V).
- Vhodnější pro plnohodnotnou izolaci (např. kyberbezpečnost, testování malwaru v Kali Linux).

Hybridní přístup: WSL (WSL 2 má vlastní kernel, ale využívá kontejnerové funkce namespaces a cgroups).

---

## Co jsou Kubernetes?
- Open-source orchestrátor kontejnerů.
- Automatizuje nasazování, škálování a správu kontejnerizovaných aplikací.
- Původně navrženo Googlem, nyní pod CNCF.

---

## Co je kubelet, kubectl?
### Kubectl:
= CLI nástroj pro interakci s K8s clustery.
- Slouží jako primární interface pro správu a kontrolu K8s zdrojů.
- Používá se pro nasazování aplikací, škálování zátěží, monitoring, diagnostiku a administraci.
- Uživatel má lokálně uložený konfigurační soubor umožňující přepínání mezi clustery.

### Kubelet:
= Agent běžící na každém nodu (= server, kde běží kontejnery, základní výpočetní jednotka clusteru).
- Řídí kontejnery a zajišťuje jejich požadovaný stav.
- Vytváří a řídí jednotlivé pody a interaguje s kontejnerovým runtime (např. Docker, containerd) přes API (CRI = Container Runtime Interface).
    - **Pod** = nejmenší K8s jednotka obsahující jeden či více kontejnerů; 
        - seskupení může sloužit k:
            - logickému uspořádání sdílených zdrojů (IP adresa, úložiště), 
            - nastavení systému orchestrace (nasazování atd.),
            - logování,
            - zabezpečení (IP masking přes proxy server),
            - formátování dat atd.

---

## Vyjmenujte a popište součásti Kubernetes Control Plane.
### kube-apiserver:
- Centrální bod pro interakci s clusterem přes HTTP API.
- Spravuje autentifikaci, autorizaci a validaci požadavků.

### etcd:
- Nerelační databáze pro uložení konfigurace a metadat clusteru.
- Zajišťuje konzistenci a dostupnost stavu clusteru.
- Kritická komponenta pro obnovu a správu clusteru.

### kube-scheduler:
- Rozhoduje o umístění podů na konkrétní nodes.
- Vyhodnocuje dostupné zdroje a pravidla.

### kube-controller-manager:
- Spravuje kontrolery pro logiku K8s API (správa replik podů, škálování, nasazení, monitoring, dostupnost podů při selhání).

### cloud-controller-manager:
- Integrace s cloudovými poskytovateli (např. správa externích load balancerů, síťových adres, úložišť).

---

## Co je etcd a k čemu slouží v Kubernetes?  
etcd je distribuovaná databáze používaná v Kubernetes k ukládání stavu clusteru a jeho konfigurace.  
- Při vytvoření nového podu nebo jiného objektu v K8s apiserver zapíše změnu do etcd.  
- Controller a scheduler čtou informace z etcd (skrze apiserver) a provádějí na základě toho příslušné akce (např. správa replik a secrets, node monitoring, přiřazení podů na nody, vyvážení zátěže mezi nody).  
- Běží jako cluster s více nody, kde je jeden leader a ostatní followers, které synchronizují data (je nutné zajistit HA/prevenci SPoF, protože apiserver závísí na etcd a nemohl by bez něj provádět žádné změny – škálování, nasazování, aktualizace).  

---

## Co je namespace?
- Logické rozdělení clusteru pro oddělení aplikací (např. vývoj, test, produkce).
- Může obsahovat vlastní pody, služby, ConfigMapy a další objekty.

---

## Vyjmenujte základní objekty v Kubernetes.
- Pod, Deployment, ReplicaSet, StatefulSet, DaemonSet, PersistentVolume, Service, Namespace, ConfigMap, Secret, Job.

---

## Popište typy service v Kubernetes.
- **ClusterIP:** Interní IP pro komunikaci uvnitř clusteru.
- **NodePort:** Přístup k aplikaci zvenčí přes pevně daný port každé node.
- **LoadBalancer:** Externí Load Balancer s vlastní IP.
- **ExternalName:** Překlad na externí DNS název bez proxy/load balancingu.

---

## Co je ephemeral storage?
- Úložiště existující pouze po dobu životního cyklu podu.
- Po smazání nebo restartování podu je úložiště vyčištěno.
- Používá se pro logy, cache nebo dočasné soubory.

---

## Jaký je rozdíl mezi anotací a labelem?
- **Labely:** Identifikace a organizace objektů, např. pro nasazení, škálování.
- **Anotace:** Ukládají metadata, např. časová razítka, verze, odkazy.

---

## Jaký je rozdíl mezi secretem a configmapou?
### ConfigMap:
- Uchovává běžná konfigurační data (např. URL, název služby, proměnné, CLI args) v plaintextové podobě.
- Umožňuje oddělení konfigurace pro větší flexibilitu.

### Secret:
- Uchovává citlivá data (hesla, API klíče, certifikáty, tokeny) zakódovaná v base64.
- Má limit velikosti 1 MB (kvůli ukládání v etcd).
- Možnost dodatečného zabezpečení přes RBAC a šifrování.

---

## Jaký je rozdíl mezi podpem a kontejnerem?
- **Pod** je nejmenší nasaditelná jednotka v Kubernetes.
- **Pod** může obsahovat jeden nebo více kontejnerů.
- **Kontejner** je běžící instance image v rámci podu.

---

## Jak byste postupovali při instalaci Kubernetes clusteru v on-premise prostředí?
- Instalace kubeadm, kubelet, kubectl.
- Inicializace clusteru (kubeadm init).
- Konfigurace síťování (CNI pluginy jako Calico, Flannel).
- Připojení worker nodes (kubeadm join).

---

## Jak byste postupovali při upgradu Kubernetes clusteru v on-premise prostředí?
- Záloha etcd a aplikačních dat.
- Postupná aktualizace kubeadm, kubelet a kubectl.
- Restart kubelet na všech nodech.
- Otestování a monitoring clusteru po aktualizaci.