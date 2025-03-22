# Síťování (Networking)

## Obsah
1. [iptables](#iptables)
2. [DNS záznamy (A, AAAA, SOA, MX, PTR)](#dns-záznamy-a-aaaa-soa-mx-ptr)
3. [Ingress](#ingress)
4. [Egress](#egress)
5. [NetworkPolicy](#networkpolicy)
6. [LoadBalancer](#loadbalancer)
7. [On-prem externí loadbalancing](#on-prem-externí-loadbalancing)
8. [CNI (Container Network Interface)](#cni-container-network-interface)

## iptables
- `iptables` je nástroj pro operační systémy Linux a Unix, který slouží ke správě síťové komunikace, síťového provozu a implementaci firewallu.
- Stejně jako u ACL (Access Control Lists), i v `iptables` **záleží na pořadí definovaných pravidel** pro správné zpracování síťových paketů. Pořadí pravidel je klíčové.
- Mezi **tři základní typy tabulek** v `iptables` se řadí:
1. `filter`: Tato tabulka slouží k definování firewallových pravidel, která povolují nebo blokují síťový provoz.
2. `nat`: Tabulka určená pro směrování paketů a modifikace IP adres a portů. Zahrnuje:
    - **SNAT/maškaráda**: Využívá se pro sdílení internetového připojení (aplikuje se až po směrování).
    - **DNAT**: Slouží pro port forwarding, vyvažování zátěže (loadbalancing) a přesměrování externího provozu do interní sítě.
3. `mangle`:  Tabulka se používá pro pokročilou manipulaci s metadaty síťových paketů v jejich hlavičce. Příklady použití:
    - **TOS (Type of Service)**: Nastavení prioritizace a minimalizace latence (nízkého zpoždění) podle typů služeb.
    - **MARK**: Označování paketů za účelem:
        - **Traffic shaping**: Kontrola a řízení rychlosti síťového připojení.
        - **QoS (Quality of Service)**: Prioritizace paketů a označení jejich priority pro další zpracování nástrojem tc (traffic control).
    - **TTL (Time to Live)**: Nastavení životnosti síťových paketů, například pro obcházení omezení poskytovatele internetového připojení (ISP).

---

## DNS záznamy (A, AAAA, SOA, MX, PTR)
DNS záznamy slouží k překladu doménových jmen na IP adresy.
- **A záznam (Address Record):** Překládá doménové jméno na IPv4 adresu serveru, který hostuje danou doménu.
- **AAAA záznam:** Překládá doménové jméno na IPv6 adresu serveru.
- **SOA záznam (Start Of Authority):** Obsahuje autoritativní informace o DNS zóně, včetně:
    - Názvu primárního DNS serveru pro zónu.
    - Kontaktní e-mailové adresy správce zónového souboru (s tečkou namísto znaku "@").
    - Verze zónového souboru (prostřednictvím sériového čísla).
    - Tří časovačů pro intervaly mezi kontrolami sériového čísla (Refresh, Retry, Expire).
    - TTL (Time To Live) pro negativní cachování (doba, po kterou si cachovací DNS servery pamatují, že nějaký záznam neexistuje).
- **MX záznam (Mail Exchange):** Určuje adresu poštovního serveru (mail serveru) spojeného s danou doménou.
    - Používá se k zajištění směrování všech příchozích e-mailů na správný poštovní server.
- **PTR záznam (Pointer Record):** Reverzní záznam sloužící k provádění reverzních DNS dotazů.
    - Umožňuje překlad z IP adresy zpět na odpovídající doménové jméno.

---

## Ingress
- API objekt [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1) pro **řízení externího HTTP/HTTPS přístupu** ke službám clusteru.
- **Funguje jako reverzní proxy**.
- Konfigurace se implementuje pomocí **Ingress controlleru** (což je server, např. Nginx, Istio).
    - **Ingress controller** je zodpovědný za **zpracování a směrování** HTTP/HTTPS požadavků na základě pravidel definovaných v objektu Ingress.
    - **Ingress controller řídí** a **konfiguruje** reverzní proxy server pro směrování požadavků na odpovídající služby v clusteru.
    - **Ingress controller** **zajišťuje** funkce jako loadbalancing, SSL/TLS terminace, bezpečnostní filtrování (včetně ochrany proti DDoS útokům), caching aj.
    - **Směruje internetový provoz** na interní služby a **slouží jako prostředník**.

---

## Egress
- **Egress** označuje **odchozí síťový provoz** z [podů](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#pod) ven — typicky do jiných [podů](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#pod) v clusteru, do jiných služeb v síti nebo do internetu.
- **Řízení egress provozu** je důležité z hlediska **bezpečnosti, kontroly přístupu a dodržení pravidel síťového provozu**.
- V prostředí [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1) lze egress omezovat pomocí objektu [NetworkPolicy](#networkpolicy).
- Příklady využití egress politik:
    - Zabránění přímému přístupu podů na internet (např. kvůli bezpečnostním hrozbám).
    - Omezení komunikace na konkrétní IP adresy, CIDR rozsahy nebo domény (např. přístup pouze na db server nebo API bránu).
    - Implementace **"default deny" egress politiky** a následné povolení pouze specifických cílových adres.
- Pro složitější scénáře egress řízení (např. DNS resolving, proxy, nebo auditování provozu) může být potřeba použít další nástroje – např. Cilium, Calico, nebo dedikovaný egress gateway.
- **Egress** je opakem **[ingress](#ingress)** a obě tyto oblasti jsou důležité pro **síťovou bezpečnost** a **řízení provozu** v [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1) clusteru.

---

## NetworkPolicy
- Je to objekt [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1), který definuje pravidla pro řízení **síťové komunikace mezi [pody](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#pod)** v rámci jednoho clusteru.
- Slouží k omezení a přesnému nastavení toho, **kdo může komunikovat s kým** – na základě **pod selectoru, [namespace](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#jmenn%C3%BD-prostor-namespace), portu** a směru provozu (ingress/egress).
- NetworkPolicy může definovat:
    - **Příchozí provoz ([Ingress](#ingress))** – kdo se smí připojit k podu (např. povolit komunikaci pouze z podů ve stejném [namespace](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#jmenn%C3%BD-prostor-namespace)).
    - **Odchozí provoz ([Egress](#egress))** – kam se smí pod připojovat (např. jen na konkrétní externí API).
- Výchozí chování:
    - Pokud **není definována žádná NetworkPolicy**, je **komunikace mezi všemi pody povolena**.
    - Pokud **existuje alespoň jedna NetworkPolicy pro [pod](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#pod)**, tak se **aplikuje whitelistový model** – je povoleno **jen to, co je explicitně specifikováno**.
- NetworkPolicy funguje pouze tehdy, pokud je nasazen **[síťový plugin](#cni-container-network-interface)**, který tyto pravidla podporuje.
- Omezení:
    - NetworkPolicy funguje pouze na vrstvě IP a portů – neumožňuje filtrování na základě doménových jmen (např. `example.com`).
    - Nepodporuje L7 pravidla (např. HTTP metody nebo URI) – k tomu slouží pokročilejší nástroje jako Istio nebo Cilium.

---

## LoadBalancer
= komponenta na síti, která je zodpovědná za rozdělování provozu příp. bezvýpadkové škálování
- rozložení zátěže na servery, optimalizace výkonu aplikací, zvýšení dostupnosti, spolehlivosti
- často zařízení kombinuje další funkce, např. webový server (nginx, apache), firewall (F5, Citrix)

---

## On-prem externí loadbalancing
- **Nativní [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1) řešení**: 
    - **MetalLB**, který umožňuje vystavení externí IP adresy v on-premise prostředí,
    - **Kubernetes Ingress kontroler**.
- **Externí loadbalancing z hlediska umístění**: Může být realizován například cloudovou službou (AWS ELB, GCP LB, atd.).
- **Externí on-prem řešení**: Alternativně lze využít externí softwarové nebo hardwarové loadbalancery (například F5, Citrix).
- **Výběr řešení**: Typ loadbalanceru by měl být zvolen s ohledem na danou architekturu a požadavky na implementaci (škálovatelnost, komplexitu, požadované funkce).

---

## CNI (Container Network Interface)
- CNI je standard pro síťové pluginy, které umožňují [kontejnerům](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kontejner) komunikovat s ostatními [kontejnery](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kontejner) a s externí sítí.
- Je to také framework poskytující standardizované síťové rozhraní, které slouží ke kontrole sítí v [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1), komunikaci a napojení [kontejnerů](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kontejner) na různé síťové technologie a topologie.
- Umožňuje **propojení různých síťových řešení s různými systémy pro správu kontejnerů a runtime prostředí**, **virtuální segmentaci sítě** a **napojení na fyzickou síť**.
- Implementace CNI se realizuje prostřednictvím pluginů, například: Weave Net, Canal, Flannel, Calico a Cilium.