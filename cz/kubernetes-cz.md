# Kubernetes

## Kontejner, virtuální stroj (VM) a rozdíly mezi nimi
### Kontejner
- Kontejner je balíček obsahující mikroslužbu spolu s jejími závislostmi a konfiguracemi. 
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

## Image vs. Kontejner
- **Image:** 
    - Statická šablona pro vytvoření kontejneru. 
    - Obsahuje informace jako je konfigurace, knihovny a aplikace.
- **Kontejner:**
    - Běžící instance image, živý proces.
    - Kontejner lze spustit, zastavit a odstranit - na rozdíl od image.

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

## Jmenný prostor (Namespace)
- Namespace je jednotka seskupení v rámci Kubernetes clusteru, která slouží k logickému rozdělení prostředí.
    - Například podle aplikace, týmu, typu prostředí (vývojové, testovací, produkční) nebo pro organizaci objektů.
- Jedná se o logické rozdělení clusteru pro izolaci aplikací (například vývojových, testovacích a produkčních prostředí).
- Namespace může obsahovat vlastní prostředky, jako jsou Pody, Služby, ConfigMapy a další objekty (například ReplicaSet, Secret, Ingress a další).

---

## Základní objekty v Kubernetes
- Pod, Deployment, ReplicaSet, StatefulSet, DaemonSet, PersistentVolume, Service, Namespace, ConfigMap, Secret, Job ...

---

## Custom Resource Definitions (CRD)
- Slouží k rozšíření Kubernetes o vlastní typy zdrojů **bez nutnosti zásahu do kódu**. Umožňují definovat a spravovat vlastní objekty.
- Definice CRD se provádí vytvořením manifestu ve formátu YAML a následným nasazením pomocí příkazu `kubectl apply -f crd.yaml`.
- Správa vlastních objektů probíhá **stejnými příkazy jako u standardních objektů Kubernetes**, například `kubectl get`, `kubectl describe`, `kubectl delete` a další.

---

## Kubernetes operátory a jejich funkce
- **Kubernetes operátor** je speciální druh **aplikačně specifického kontroleru**, který umožňuje **automatizaci správy aplikací a zdrojů** v Kubernetes.  
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
- **NodePort:** Kromě ClusterIP přidává možnost externího přístupu přes statický port na IP adrese každé node v clusteru (`IP:static_port`).
- **LoadBalancer:** Zpřístupnění přes externí Load Balancer s vlastní veřejnou IP adresou. Ideální pro produkční aplikace s vysokým provozem.
- **ExternalName:** Překlad na externí DNS název bez proxy nebo load balancingu. Používá se pro připojení ke službám mimo Kubernetes cluster (například externí služby nebo služby hostované jinde). Provoz je směrován přímo na externí hostname prostřednictvím CNAME záznamu poskytovaného DNS serverem Kubernetes.

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

## Instalace clusteru v on-prem prostředí
Pro instalaci [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1) clusteru v on-premise prostředí postupujte podle následujících kroků:
1. **Přípravné kroky**:
    - Aktualizujte systémové balíčky na všech uzlech clusteru.
    - Nainstalujte container runtime, například Docker nebo containerd.
    - Nainstalujte [nástroje](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubectl-a-kubelet) `kubeadm`, `kubelet` a `kubectl` na všech uzlech.

2. **Inicializace řídícího uzlu (Master Node)**:
    - Na řídícím uzlu inicializujte Kubernetes cluster pomocí příkazu:
        ```bash
        kubeadm init
        ```

3. **Konfigurace `kubectl`**:
    - Pro konfiguraci nástroje `kubectl` zkopírujte konfigurační soubor administrátora:
        ```bash
        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
        ```

4. **Konfigurace síťování (CNI pluginy)**:
    - Nakonfigurujte síťové rozhraní clusteru (CNI). Doporučené řešení zahrnují:
        - Calico
        - Flannel
        - Weave Net
    - Postup instalace CNI se liší v závislosti na zvoleném řešení.

5. **Připojení pracovních uzlů (Worker Nodes)**:
    - Na pracovních uzlech se připojte ke clusteru pomocí příkazu `kubeadm join`. <br> Příkaz `kubeadm join` se vygeneruje po úspěšné inicializaci řídícího uzlu (`kubeadm init`).
    - Po připojení uzlů ověřte funkčnost clusteru pomocí nástroje kubectl z řídícího uzlu:
        ```bash
        kubectl get nodes
        kubectl get pods --all-namespaces
        ```

6. **Instalace volitelných nástrojů**:
    - Pro rozšíření funkcionality clusteru nainstalujte volitelné nástroje, jako například:
        - [Monitoring](https://github.com/ILXNAH/devops-case-study/blob/main/cz/monitoring-cz.md) ([Prometheus](https://github.com/ILXNAH/devops-case-study/blob/main/cz/monitoring-cz.md#prometheus), Grafana)
        - Logování (Elasticsearch, Fluentd, Kibana - EFK stack)
        - Ingress kontrolery (nginx-ingress-controller, Traefik)

7. **Nasazení aplikace**:
    - Pro nasazení aplikace do clusteru:
        - Vytvořte Deployment definici a aplikujte ji pomocí `kubectl create deployment`:
            ```bash
            kubectl create deployment <název-deploymentu> --image=<jméno-image>
            ```
        - Vytvořte službu pro zpřístupnění Deploymentu a exponujte ji na požadovaném portu pomocí `kubectl expose deployment`: 
            ```bash
            kubectl expose deployment <název-deploymentu> --port=<port> --target-port=<cílový-port> --type=LoadBalancer (nebo ClusterIP/NodePort)
            ```

8. **Konfigurace clusteru**:
    - Nakonfigurujte další aspekty clusteru dle vašich požadavků, například:
        - Bezpečnostní politiky (NetworkPolicies, PodSecurityPolicies)
        - Centralizované logování
        - Strategie zálohování a obnovy ([Disaster Recovery](https://github.com/ILXNAH/devops-case-study/blob/main/cz/bezpe%C4%8Dnost.md#zotaven%C3%AD-po-hav%C3%A1rii-disaster-recovery-pro-kubernetes-cluster)) clusteru
        - [Monitoring](https://github.com/ILXNAH/devops-case-study/blob/main/cz/monitoring-cz.md) a alerting

---

## Upgrade clusteru v on-prem prostředí
- Záloha etcd a aplikačních dat.
- Postupná aktualizace kubeadm, kubelet a kubectl.
- Restart kubelet na všech nodech.
- Otestování a monitoring clusteru po aktualizaci.