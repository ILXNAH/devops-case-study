# Monitoring

## Obsah
1. [Prometheus](#prometheus)
2. [Zpracování logů v Kubernetes clusteru](#zpracování-logů-v-kubernetes-clusteru)
3. [Ukládání stavu aplikací v kontejnerech](#ukládání-stavu-aplikací-v-kontejnerech)
    - [Podle místa uložení](#podle-místa-uložení)
    - [Podle použitých prostředků](#podle-použitých-prostředků)

## Prometheus
**Prometheus** je open-source **monitorovací nástroj** vyvinutý firmou SoundCloud a aktuálně (stejně jako [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1)) spadá pod záštitu organizace CNCF (Cloud Native Computing Foundation).
- **Monitoruje cloud-native aplikace a infrastruktury v reálném čase** (sběr, ukládání, vizualizace a analýza dat).
- **Funguje autonomně**, bez závislosti na databázi.
- **Automatická detekce Kubernetes služeb a metrik.** Používá model proaktivního stahování dat (**pull-based**) přes HTTP.
- **Třídění a filtrování dat** pomocí časových řad a volitelných labelů. 
    - Pro pokročilé dotazování využívá flexibilní jazyk **PromQL**.
- **Podporuje vizualizaci dat do dashboardů**, například prostřednictvím integrace s nástrojem **Grafana**.
- V [Kubernetes](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#kubernetes-1) se typicky nasazuje pomocí [Helm Chartu](https://github.com/ILXNAH/devops-case-study/blob/main/cz/gitops-cz.md#nasazen%C3%AD-aplikace-pomoc%C3%AD-helmu).

---

## Zpracování logů v Kubernetes clusteru
- **Pro shromažďování a zpracování logů:**  Nasazení **Fluentd** jako `DaemonSet` na každém nodu (uzlu) clusteru.
- **Ukládání a indexování logů:** Odesílání logů například do Elasticsearch/ELK stacku (případně do AWS S3 nebo jiného úložiště, avšak s omezenějšími možnostmi).
- **Vizualizace logů:** Prostřednictvím Grafany (integrované s [Prometheem](#prometheus)) nebo Kibany (přímo v ELK stacku).

---

## Ukládání stavu aplikací v kontejnerech
### Podle místa uložení
1. **Uložení do externí databáze** (například managed služba AWS RDS).
2. **Uložení do cloudu (Google Cloud, Azure, AWS):**
    - Objektová úložiště (například AWS S3).
    - Síťové svazky (například AWS EFS).
3. **Uložení do síťového úložiště (NFS):** Vhodné pro sdílení dat mezi více pody a pro flexibilní připojení z různých serverů.
4. **Lokální uložení dat přímo na disk serveru, kde běží daný [pod](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#pod) (`hostPath`).**

### Podle použitých prostředků
1. **Využití nativních Kubernetes API objektů PV (`PersistentVolume`) a PVC (`PersistentVolumeClaim`):** Pro uchovávání trvalých dat, například databází. Konfigurace je součástí specifikace [podu](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#pod). Umožňuje připojení trvalého úložiště k [podům](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#pod). Nevýhodou je manuální správa replik a identit [podů](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#pod). PVC slouží k připojení [podu](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#pod) k PV.
2. **Využití kontroleru `StatefulSet`:** Pro automatizaci správy PV/PVC. Ideální pro stavové aplikace, například databáze.
3. **Připojení svazků (volumes) přes `volumeMounts`:** Konfigurace se definuje v manifestu [podu](https://github.com/ILXNAH/devops-case-study/blob/main/cz/kubernetes-cz.md#pod). Kromě PV/PVC lze využít i dočasné svazky (`emptyDir`, `ConfigMap`, `Secret`, `hostPath`).