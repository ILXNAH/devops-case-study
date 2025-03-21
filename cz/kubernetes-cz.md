# Kubernetes

## Obsah
1. [Kontejner, virtuální stroj (VM) a rozdíly mezi nimi](#kontejner-virtuální-stroj-vm-a-rozdíly-mezi-nimi)
2. [Kubernetes](#kubernetes-1)
3. [Základní objekty v Kubernetes](#základní-objekty-v-kubernetes)
4. [Image vs. Kontejner](#image-vs-kontejner)
5. [Pod vs. Kontejner](#pod-vs-kontejner)
6. [Jmenný prostor (Namespace)](#jmenný-prostor-namespace)
7. [Dočasné úložiště (Ephemeral storage)](#dočasné-úložiště-ephemeral-storage)
8. [Anotace vs. Labely](#anotace-vs-labely)
9. [Kubectl a Kubelet](#kubectl-a-kubelet)
10. [Součásti řídicí roviny Kubernetes (Control Plane)](#součásti-řídicí-roviny-kubernetes-control-plane)
11. [Custom Resource Definitions (CRD)](#custom-resource-definitions-crd)
12. [Kubernetes operátory a jejich funkce](#kubernetes-operátory-a-jejich-funkce)
13. [Typy Služeb (Service)](#typy-služeb-service) 
14. [Instalace clusteru v on-prem prostředí](#instalace-clusteru-v-on-prem-prostředí)
15. [Upgrade clusteru v on-prem prostředí](#upgrade-clusteru-v-on-prem-prostředí)

---

## Kontejner, virtuální stroj (VM) a rozdíly mezi nimi
### Kontejner
Kontejner je balíček obsahující mikroslužbu spolu s jejími závislostmi a konfiguracemi. 
- Typicky je navržen tak, aby v kontejneru běžel jeden proces.
- Obsahuje pouze aplikaci a nezahrnuje celý operační systém.
- Má menší nároky na systémové zdroje, které jsou sdílené s hostitelským operačním systémem.
- Je charakteristický rychlostí a dobrou škálovatelností, díky čemuž je hojně využíván v mikroservisních architekturách (například v telekomunikacích nebo bankovnictví).
- Osobní zkušenost: <br> Docker a OpenShift (aplikační podpora + automatizace), méně Kubernetes (OpenShift = platforma postavená na Kubernetes).

### Virtuální stroj (VM)
- Má vlastní OS = vlastní přidělené zdroje (CPU, RAM, disk, síť přidělené hypervizorem).
- Běží na hypervizoru (např. VMware, VirtualBox, Hyper-V).
- Vhodnější pro plnohodnotnou izolaci (např. kyberbezpečnost, testování malwaru v Kali Linux).

Hybridní přístup: WSL (WSL 2 má vlastní kernel, ale využívá kontejnerové funkce namespaces a cgroups).

---

## Kubernetes
- Kubernetes je open-source platforma pro orchestraci kontejnerů.
- Automatizuje procesy nasazování, škálování a správy kontejnerizovaných aplikací.
- Původně navržen společností Google, v současnosti spravován pod záštitou organizace CNCF (Cloud Native Computing Foundation).

---

## Základní objekty v Kubernetes
- Pod, Deployment, ReplicaSet, StatefulSet, DaemonSet, PersistentVolume, Service, Namespace, ConfigMap, Secret, Job ...

---

## Image vs. Kontejner
### Image
- Statická šablona pro vytvoření kontejneru. 
- Obsahuje informace jako je konfigurace, knihovny a aplikace.
### Kontejner
- Běžící instance image, živý proces.
- Kontejner lze spustit, zastavit a odstranit - na rozdíl od image.

---

## Pod vs. Kontejner
### Pod
je nejmenší nasaditelná jednotka v systému Kubernetes.
- **Pod** může obsahovat jeden či více kontejnerů.
- **Pod** je spravován komponentou kubelet, což je agent běžící na každém nodu (uzlu) v clusteru.

### Kontejner
je běžící instance image, která je součástí podu. <br> 
Seskupení kontejnerů v podu je výhodné pro:
- Logické uspořádání a sdílení zdrojů (například IP adresy a úložiště).
- Konfiguraci systému orchestrace (například pro účely nasazování aplikací).
- Zajištění centralizovaného logování.
- Implementaci zabezpečení (například maskování IP adres pomocí proxy serveru).
- Potřeby formátování dat a podobné účely.

---

## Jmenný prostor (Namespace)
- Namespace je jednotka seskupení v rámci Kubernetes clusteru, která slouží k logickému rozdělení prostředí.
    - Například podle aplikace, týmu, typu prostředí (vývojové, testovací, produkční) nebo pro organizaci objektů.
- Jedná se o logické rozdělení clusteru pro izolaci aplikací (například vývojových, testovacích a produkčních prostředí).
- Namespace může obsahovat vlastní prostředky, jako jsou Pody, Služby, ConfigMapy a další objekty (například ReplicaSet, Secret, Ingress a další).

---

## Dočasné úložiště (Ephemeral storage)
- Úložiště, které existuje pouze po dobu životního cyklu podu.
- Po smazání nebo restartování podu se toto úložiště vymaže.
- Používá se pro data, u kterých není vyžadováno dlouhodobé uchování, například procesní logy, cache nebo dočasné soubory obsahující tajné klíče či konfigurační data.
- Obvykle je uloženo v lokálním úložišti příslušného uzlu (například na disku fyzického serveru).
- Specifikace se provádí v `Pod spec`.
- Jednotlivé typy `emptyDir`, `configMap`, `downwardAPI` a `secret` jsou spravovány kubeletem na každém uzlu.

---

## Anotace vs. Labely
- **Labely:**
    - Labely se používají k identifikaci a organizaci objektů v Kubernetes (zejména pro účely výběru a filtrování).
    - Selekce objektů na základě labelů je užitečná pro operace jako je nasazování, aktualizace nebo škálování aplikací.
- **Anotace:**
    - Anotace slouží k ukládání podrobných metadat, například časových razítek, verzí nebo odkazů na externí zdroje.
    - Anotace poskytují rozšířené kontextuální informace o objektu, ale nemají vliv na selekci objektů (podů, služeb, jmenných prostorů, Secretů, ConfigMap apod.).

---

## Kubectl a Kubelet
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
### 1. kube-apiserver
- Představuje centrální bod pro interakci s clusterem prostřednictvím HTTP API.
- Zajišťuje správu autentizace, autorizace a validaci příchozích požadavků.
- Ukládá informace o stavu clusteru do etcd.

### 2. etcd
- Jedná se o nerelační databázi, která slouží k ukládání všech dat clusteru, včetně jeho konfigurace, aktuálního stavu, politik a metadat.
- Zajišťuje konzistentní a dostupný stav clusteru.
- Je to kriticky důležitá komponenta pro obnovu a celkovou správu clusteru.

#### Role `etcd` v Kubernetes
etcd je distribuovaná databáze, která se v Kubernetes používá k ukládání stavu clusteru a jeho konfigurace.
- Při vytvoření nového podu nebo jiného objektu v Kubernetes API server zapíše tuto změnu do etcd.
- Řadiče (Controllers) a plánovač (Scheduler) čtou informace z etcd (prostřednictvím API serveru) a na základě těchto informací provádějí příslušné akce (například správa replik a Secretů, monitorování nodů, přiřazování podů k nodům, vyvažování zátěže mezi nody).
- etcd běží jako cluster s více uzly, kde jeden uzel funguje jako leader a ostatní jako followeři, kteří synchronizují data. 
    - Je nezbytné zajistit vysokou dostupnost (HA) a prevenci selhání jednoho bodu (SPoF), protože API server je závislý na etcd a bez něj by nemohl provádět žádné změny v clusteru – například škálování, nasazování nebo aktualizace.

### 3. kube-scheduler
- Komponenta zodpovědná za rozhodování o umístění podů na konkrétní nody.
- Vyhodnocuje výběr nejvhodnější uzel (node) na základě dostupných zdrojů, definovaných politik a pravidel.

### 4. kube-controller-manager
Spravuje kontrolery, které implementují řídicí logiku chování Kubernetes API. Mezi typické funkce patří například:
- Správa počtu replik podů.
- Nasazování aplikací, verzování a škálování.
- Správa, monitorování, kontrola a aktualizace stavu nodů, zajištění dostupnosti podů (včetně migrace při selhání nodu).

### 5. cloud-controller-manager
- Slouží k zajištění integrace Kubernetes s cloudovými poskytovateli (CSP) – volitelná komponenta.
- Spravuje cloudové zdroje, jako jsou load balancery, disky a síťové adresy.

---

## Custom Resource Definitions (CRD)
- Slouží k rozšíření Kubernetes o vlastní typy zdrojů **bez nutnosti zásahu do kódu**. Umožňují definovat a spravovat vlastní objekty.
- Definice CRD se provádí vytvořením manifestu ve formátu YAML a následným nasazením pomocí příkazu `kubectl apply -f crd.yaml`.
- Správa vlastních objektů probíhá **stejnými příkazy jako u standardních objektů Kubernetes**, například `kubectl get`, `kubectl describe`, `kubectl delete` a další.

---

## Kubernetes operátory a jejich funkce
**Kubernetes operátor** je speciální druh **aplikačně specifického kontroleru**, který umožňuje **automatizaci správy aplikací a zdrojů** v Kubernetes.  
- **Hlavní účel** operátorů je zajistit **soulad aktuálního stavu aplikace v clusteru s požadovaným stavem**, který je definován v konfiguraci.  
- Operátoři **rozšiřují funkcionalitu Kubernetes API** přidáním **vlastních kontrolerů a Custom Resource Definitions (CRD)**.  
- Typické **funkce operátorů** zahrnují:
  - **Automatizovanou správu stavových aplikací** (např. databází, message brokering systémů).
  - **Automatické škálování, aktualizace a migrace aplikací**.
  - **Automatizaci CI/CD pipeline** pro nasazování aplikací v GitOps workflow.
  - **Monitorování a samoopravu aplikací** (detekce selhání, restart, predefinovaná náprava).
  - **Správu zálohování a obnovy aplikací** (např. databázových instancí).
  - **Přidání specifických API a zajištění konzistence** aplikací běžících v clusteru.

### Příklady operátorů
- **Prometheus Operator** – správa [monitoringu](https://github.com/ILXNAH/devops-case-study/blob/main/cz/monitoring-cz.md) a metrik.
- **Cert-Manager Operator** – automatizace správy [TLS](https://github.com/ILXNAH/devops-case-study/blob/main/cz/bezpe%C4%8Dnost.md#definice-a-mechanismus-ssltls) certifikátů.
- **Istio Operator** – správa [Service Mesh](https://github.com/ILXNAH/devops-case-study/blob/main/cz/bezpe%C4%8Dnost.md#service-mesh-s%C3%AD%C5%A5-slu%C5%BEeb) řešení.
- **PostgreSQL Operator** – automatizovaná správa databází PostgreSQL v Kubernetes.

---

## Typy Služeb (Service)
- **ClusterIP:** Zpřístupnění aplikace na interní IP adrese. Vhodné pro interní služby, dostupné pouze uvnitř clusteru.
- **NodePort:** Kromě ClusterIP přidává možnost externího přístupu přes statický port na IP adrese každém uzlu v clusteru (`IP:static_port`).
- **LoadBalancer:** Zpřístupnění přes externí Load Balancer s vlastní veřejnou IP adresou. Ideální pro produkční aplikace s vysokým provozem.
- **ExternalName:** Překlad na externí DNS název bez proxy nebo load balancingu. Používá se pro připojení ke službám mimo Kubernetes cluster (například externí služby nebo služby hostované jinde). Provoz je směrován přímo na externí hostname prostřednictvím CNAME záznamu poskytovaného DNS serverem Kubernetes.

---

## Instalace clusteru v on-prem prostředí
Pro instalaci [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1) clusteru v on-premise prostředí postupujte podle následujících kroků:
### 1. **Přípravné kroky**:
- Aktualizujte systémové balíčky na všech uzlech clusteru.
- Nainstalujte container runtime, například Docker nebo containerd.
- Nainstalujte [nástroje](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubectl-a-kubelet) `kubeadm`, `kubelet` a `kubectl` na všech uzlech.

### 2. **Inicializace řídícího uzlu (Master Node)**: <br> 
Na řídícím uzlu inicializujte Kubernetes cluster pomocí příkazu:

```bash
kubeadm init
```

### 3. **Konfigurace `kubectl`**: <br> 
Pro konfiguraci nástroje `kubectl` zkopírujte konfigurační soubor administrátora a nastavte správná oprávnění:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 4. **Konfigurace síťování (CNI pluginy)**:
- Nakonfigurujte síťové rozhraní clusteru. Doporučená řešení zahrnují: Calico, Flannel, Weave Net. <br> 
Postup instalace CNI se liší v závislosti na zvoleném řešení.

### 5. **Připojení pracovních uzlů (Worker Nodes)**:
- Na pracovních uzlech se připojte ke clusteru pomocí příkazu `kubeadm join`. Příkaz `kubeadm join` se generuje po úspěšné inicializaci řídícího uzlu (`kubeadm init`) v unikátním formátu:
    - adresa řídícího uzlu + token pro autorizaci + hash CA certifikátu.
- Po připojení uzlů ověřte funkčnost clusteru pomocí nástroje kubectl z řídícího uzlu:

    ```bash
    kubectl get nodes
    kubectl get pods --all-namespaces
    ```

### 6. **Instalace volitelných nástrojů**: <br> 
Pro rozšíření funkcionality clusteru nainstalujte volitelné nástroje, jako například:
- [Monitoring](https://github.com/ILXNAH/devops-case-study/blob/main/cz/monitoring-cz.md) ([Prometheus](https://github.com/ILXNAH/devops-case-study/blob/main/cz/monitoring-cz.md#prometheus), Grafana)
- Logování (Elasticsearch, Fluentd, Kibana - EFK stack)
- Ingress kontrolery (nginx-ingress-controller, Traefik)

### 7. **Nasazení aplikace**: <br> 
Pro nasazení aplikace do clusteru:
- Vytvořte Deployment definici a aplikujte ji pomocí `kubectl create deployment`:

    ```bash
    kubectl create deployment <název-deploymentu> --image=<jméno-image>
    ```
- Vytvořte službu pro zpřístupnění Deploymentu a exponujte ji na požadovaném portu pomocí `kubectl expose deployment`: 

    ```bash
    kubectl expose deployment <název-deploymentu> --port=<port> --target-port=<cílový-port> --type=LoadBalancer (nebo ClusterIP/NodePort)
    ```

### 8. **Konfigurace clusteru**: <br> 
Nakonfigurujte další aspekty clusteru dle vašich požadavků, například:
- Bezpečnostní politiky (NetworkPolicies, PodSecurityPolicies)
- Centralizované logování
- Strategie zálohování a obnovy ([Disaster Recovery](https://github.com/ILXNAH/devops-case-study/blob/main/cz/bezpe%C4%8Dnost.md#zotaven%C3%AD-po-hav%C3%A1rii-disaster-recovery-pro-kubernetes-cluster)) clusteru
- [Monitoring](https://github.com/ILXNAH/devops-case-study/blob/main/cz/monitoring-cz.md) a alerting

---

## Upgrade clusteru v on-prem prostředí
Pro upgrade [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1) clusteru v on-premise prostředí postupujte podle následujících kroků:
### 1. **Ověření aktuální verze a kompatibility:** <br>
Zjistěte aktuálně nainstalovanou verzi Kubernetes clusteru pomocí příkazu:

```bash
kubectl version
```
Ujistěte se, že nová verze Kubernetes je kompatibilní se stávající konfigurací a komponentami, jako jsou `kubeadm`, `kubelet`, `kubectl`, pluginy, kontrolery a další. Prostudujte si dokumentaci k upgradu pro danou verzi.

### 2. **Záloha etcd a aplikačních dat:**
- **Zálohujte etcd databázi:** <br>
Etcd uchovává veškerý stav vašeho Kubernetes clusteru. Záloha etcd je klíčová pro obnovu v případě problémů během upgradu. Postup zálohy etcd se liší v závislosti na vaší instalaci.
- **Zálohujte aplikační data a externí úložiště:** <br>
Pokud aplikace používají perzistentní data nebo externí db, ujistěte se, že máte funkční zálohy i těchto dat.
- **Export manifestů kritických aplikací:** <br>
Pro snadnější obnovu klíčových aplikací exportujte jejich manifesty:
    
    ```bash
    kubectl get all -A -o yaml > cluster-backup.yaml
    ```

### 3. **Upgrade řídících uzlů (Master Nodes):**
- **Upgradujte `kubeadm`:** <br>
Na každém řídícím uzlu postupně upgradujte nástroj `kubeadm` na cílovou verzi.
- **Upgradujte `kubelet` a `kubectl`:** <br>
Následně na stejném řídícím uzlu upgradujte balíčky `kubelet` a `kubectl`.
- **Restartujte `kubelet`:** <br>
Po upgradu restartujte službu `kubelet` na řídícím uzlu.
- **Kroky provádějte postupně:** <br>
Opakujte tyto kroky pro všechny řídící uzly clusteru, ideálně po jednom, abyste zajistili kontinuitu řízení clusteru.

### 4. **Upgrade pracovních uzlů (Worker Nodes):**
- **Odstraňte uzel z provozu (Drain):** <br>
Před upgradem pracovního uzlu doporučuje se ho bezpečně odstranit z provozu, aby se na něj nepřesouvaly nové pody a stávající se mohly korektně ukončit nebo přesunout:
    
    ```bash
    kubectl drain <název-uzlu> --ignore-daemonsets --delete-local-data
    ```
- **Upgradujte `kubeadm`, `kubelet` a `kubectl`:** <br>
Na odpojeném pracovním uzlu upgradujte `kubeadm`, `kubelet` a `kubectl` na cílovou verzi, podobně jako u řídících uzlů.
- **Restartujte `kubelet`:** <br>
Restartujte službu `kubelet` na pracovním uzlu.
- **Vraťte uzel do clusteru (Uncordon):** <br>
Po upgradu vraťte uzel zpět do clusteru:

    ```bash
    kubectl uncordon <název-uzlu>
    ```
- **Kroky provádějte postupně:** <br>
Opakujte tyto kroky pro všechny pracovní uzly clusteru.

### 5. **Ověření funkčnosti po upgradu:**
- **Zkontrolujte stav uzlů a podů:** <br>
Ujistěte se, že všechny uzly jsou ve stavu `Ready` a všechny kritické pody (včetně systémových podů) jsou ve stavu `Running`:
    
    ```bash
    kubectl get nodes
    kubectl get pods --all-namespaces
    ```
- **Prohlédněte logy:** <br>
Zkontrolujte logy klíčových komponent (apiserver, scheduler, kube-controller-manager) a logy aplikací pro příp. chyby nebo varování.

### 6. **Upgrade ostatních komponent a nástrojů:**
- **CNI plugin:** <br>
Upgradujte CNI plugin (např. Calico, Flannel) podle dokumentace daného pluginu, aby byl kompatibilní s novou verzí Kubernetes.
- **Ingress kontrolery:** <br>
Upgradujte Ingress kontrolery (např. nginx-ingress-controller, Traefik).
- **Monitoring a logovací systémy:** <br> 
Upgradujte systémy pro monitoring (Prometheus, Grafana) a logování (EFK stack, atd.).
- **Další nástroje a operátory:** <br>
Upgradujte všechny další nástroje, operátory a Custom Resource Definitions (CRDs), které používáte v clusteru, a ujistěte se o jejich kompatibilitě s novou verzí Kubernetes.

**Pozn.:** <br> 
Upgrade clusteru je *komplexní proces*. Před provedením upgradu v produkci si prostudujte oficiální dokumentaci pro danou verzi a důkladně **otestujte upgrade v testovacím prostředí**.