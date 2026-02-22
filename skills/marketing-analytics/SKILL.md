---
name: marketing-analytics
user-invokable: true
description: "Genereer marketing rapportages, analyseer campagne-performance en website-gedrag, en koppel advertentiedata aan gebruikersgedrag voor concrete verbeterpunten. Gebruik deze skill wanneer de gebruiker vraagt om: marketing rapporten, ads rapporten, Clarity rapporten, campagne-analyses, heatmap/sessie-analyses, conversie-checks, cross-channel inzichten, of website-optimalisaties op basis van marketing data. Ook triggeren bij: marketing rapport, ads report, clarity report, campagne analyse, hoe presteren de ads, marketing update, generate report, pull marketing data, conversion check, rapportage, performance overzicht, wat doen bezoekers op de site, waarom converteert het niet, ad spend analyse, hoe gaat het met de campagnes, website analytics, gedragsanalyse."
---

# Marketing Analytics

Unified marketing analytics skill die rapportages genereert, inzichten extraheert en
actiepunten beheert op basis van advertentie-data en website-gedragsdata.

De kracht van deze skill zit in het **kruisen van databronnen**: advertentie-performance
(clicks, kosten, conversies) koppelen aan wat bezoekers daadwerkelijk doen op de site
(scroll depth, sessieduur, rage clicks). Dat levert inzichten op die je uit geen van
beide bronnen apart kunt halen.

---

## Databronnen & MCP Servers

Deze skill werkt het best met MCP-koppelingen voor live data. Zonder MCP kan de
gebruiker handmatig data aanleveren (exports, screenshots, of metrics in de chat).

### Microsoft Clarity (primaire gedragsdata)

**Standaard MCP**: `@microsoft/clarity-mcp-server`

Als een andere MCP-server Clarity-data levert (bijv. via Zapier), gebruik die dan —
zolang je dezelfde soort data kunt ophalen. De skill werkt met elke bron die
gebruikerssessies, scroll depth, rage clicks en smart events kan leveren.

**Beschikbare tools**:

| Tool | Doel | Aandachtspunten |
|------|------|-----------------|
| `query-analytics-dashboard` | Metrics ophalen | Simpele queries, 1 metric per call, altijd tijdrange meegeven |
| `list-session-recordings` | Sessie-opnames | Max 250/call, sorteer op `SessionDuration_DESC` of `SessionClickCount_DESC` |
| `query-documentation-resources` | Clarity docs | Voor feature-vragen |

**Standaard queries voor een rapport** (voer parallel uit waar mogelijk):

```
# Verkeer
"Distinct users and sessions for the last 30 days"
"Device type breakdown (mobile vs desktop) for the last 30 days"
"Traffic sources breakdown for the last 30 days"

# Pagina-performance (per landing page)
"Average scroll depth for [URL] last 30 days"
"Average session duration for [URL] last 30 days"
"Dead clicks on [URL] last 30 days"

# Core Web Vitals
"Largest contentful paint for the last 30 days"
"Cumulative layout shift for the last 30 days"

# Conversies
"Smart events for the last 30 days"

# Gedragsproblemen
"Rage clicks for the last 30 days"
"Quick backs for the last 30 days"
```

**Sessie-opnames** — haal de langste en meest-geklikte sessies op voor gedragsanalyse:
```json
{ "sortBy": "SessionDuration_DESC", "count": 10 }
{ "sortBy": "SessionClickCount_DESC", "count": 10 }
```

### Google Ads (advertentie-performance)

**Via Zapier MCP** (als geconfigureerd):

| Tool | Doel |
|------|------|
| `google_ads_create_report` | Campagne-rapportage genereren met metrics |
| `google_ads_find_campaign_by_name` | Specifieke campagne opzoeken |
| `google_ads_find_campaign_by_id` | Campagne opzoeken op ID |

**Rapport ophalen via Zapier**:
```
google_ads_create_report:
  instructions: "Campaign performance report for last 30 days"
  resource: "campaign"
  datePreset: "LAST_30_DAYS"
  output_hint: "campaign name, impressions, clicks, CTR, cost, conversions, cost per conversion, CPC"
```

**Zonder MCP** — vraag de gebruiker om data:
> "Ik heb geen directe toegang tot Google Ads. Kun je de data delen?
> 1. Export uit Google Ads dashboard (laatste 30 dagen)
> 2. Metrics doorgeven: impressies, clicks, CTR, kosten, conversies per campagne
> 3. Of ik gebruik het vorige rapport als baseline en jij geeft updates"

### Aanvullende kanalen (optioneel)

Als er MCP-koppelingen beschikbaar zijn voor LinkedIn Ads of Meta Ads (via Zapier),
gebruik die dan met dezelfde aanpak. De rapportage-templates in `references/templates.md`
hebben secties voor deze kanalen.

### Handmatige data-aanlevering

Als er geen MCP beschikbaar is voor een databron, accepteer dan:
- CSV/Excel exports
- Screenshots van dashboards
- Metrics die de gebruiker typt in de chat
- Eerdere rapporten in `private/marketing/`

Behandel handmatig aangeleverde data met dezelfde analyse-diepte als MCP-data.

---

## Cross-referentie: de kern van deze skill

De echte waarde zit in het combineren van bronnen. Zoek altijd naar deze patronen:

| Advertentie-data | Gedragsdata | Inzicht |
|-----------------|-------------|---------|
| Hoge CTR campagne | Lage scroll depth op landing page | Goede ads, slechte pagina |
| Hoge CPC zoekwoorden | Korte sessieduur | Verkeerde zoekintentie |
| Budget uitgegeven, 0 conversies | 0 smart events | Tracking kapot OF pagina converteert niet |
| Campagne per device | Device-specifiek gedrag | Device-specifieke optimalisatie nodig |
| Ad group budget-verdeling | Pageviews per landing page | Budget vs. daadwerkelijk verkeer |

Wanneer je data uit beide bronnen hebt, maak dan altijd een cross-channel analyse.
Dit is wat deze skill onderscheidt van losse rapporten.

---

## Workflow

Deze skill werkt met subagents per kanaal. Elk kanaal heeft een eigen agent
(`agents/*.md`) die parallel kan draaien. De hoofdagent coördineert.

### Stap 1: Voorbereiding

1. Check of `private/marketing/` bestaat — zo niet, run setup (`references/setup.md`)
2. Zoek eerdere rapporten: `Glob private/marketing/*/report-*.md`
3. Bepaal welke databronnen beschikbaar zijn (MCP, handmatige data, eerdere rapporten)
4. Bepaal welke kanaal-agents nodig zijn op basis van het verzoek

### Stap 2: Kanaal-agents parallel spawnen

Spawn een subagent per kanaal **tegelijkertijd** via de Task tool. Omdat subagents
geen toegang hebben tot de skill-directory, moet je het agent-bestand **zelf lezen**
en de volledige inhoud meesturen als instructies in de Task prompt.

**Voor elke kanaal-agent**:
1. Lees het agent-bestand (bijv. `agents/microsoft-clarity.md`)
2. Lees het relevante template uit `references/templates.md`
3. Spawn een Task met de inhoud van beide bestanden plus de parameters

**Microsoft Clarity agent** — lees `agents/microsoft-clarity.md`, dan spawn:
```
[Plak hier de volledige inhoud van agents/microsoft-clarity.md]
[Plak hier het Clarity template uit references/templates.md]

Parameters:
- Periode: [laatste 30 dagen of door gebruiker opgegeven]
- Focus pagina's: [URLs als opgegeven]
- Vorig rapport: [pad naar meest recente rapport in private/marketing/microsoft-clarity/]
- Output pad: private/marketing/microsoft-clarity/report-YYYY-MM-DD.md
```

**Google Ads agent** — lees `agents/google-ads.md`, dan spawn:
```
[Plak hier de volledige inhoud van agents/google-ads.md]
[Plak hier het Google Ads template uit references/templates.md]

Parameters:
- Periode: [laatste 30 dagen of door gebruiker opgegeven]
- Databron: [mcp/handmatig/vorig-rapport]
- Handmatige data: [als de gebruiker data heeft aangeleverd]
- Vorig rapport: [pad naar meest recente rapport in private/marketing/google-ads/]
- Output pad: private/marketing/google-ads/report-YYYY-MM-DD.md
```

Beide agents draaien parallel. Als de gebruiker maar één kanaal wil, spawn alleen
die agent en sla de cross-channel stap over.

**Uitbreidbaarheid**: Om een nieuw kanaal toe te voegen (bijv. Meta Ads, LinkedIn Ads),
maak een nieuw agent-bestand in `agents/` en voeg het toe aan deze stap. De
cross-channel agent pakt nieuwe kanalen automatisch op.

### Stap 3: Cross-channel agent spawnen

Zodra de kanaal-agents klaar zijn, lees `agents/cross-channel.md` en het
cross-channel template, en spawn de agent met de resultaten:

```
[Plak hier de volledige inhoud van agents/cross-channel.md]
[Plak hier het Cross-Channel template uit references/templates.md]

Parameters:
- Kanaal-rapporten: [paden naar de zojuist gegenereerde rapporten]
- Kanaal-actiepunten: [P0/P1 items van elke kanaal-agent]
- Landing pages: [URLs uit de Google Ads agent]
- Vorig cross-channel rapport: [pad als beschikbaar]
- Output pad: private/marketing/optimizations/report-YYYY-MM-DD.md
```

Sla deze stap over als er maar één kanaal is geanalyseerd.

### Stap 4: Actiepunten verwerken

Verwerk de todo-items van de cross-channel agent (of kanaal-agents als er geen
cross-channel is) in de juiste bestanden:

- `todo/google-ads.md` — Google Ads specifieke items
- `todo/microsoft-clarity.md` — Clarity specifieke items
- `todo/website-aanpassingen.md` — Website changes uit cross-channel inzichten
- `todo/backlog.md` — Cross-channel items

Formaat: `- [ ] [P0] Actie — verwacht resultaat`

Check eerst of items al bestaan — geen duplicaten toevoegen.

### Stap 5: Samenvatting presenteren

Geef de gebruiker een beknopte samenvatting:
- Belangrijkste metrics met trend-indicators
- Top 3 problemen
- Top 3 aanbevelingen
- Verwijzing naar gegenereerde rapportbestanden

Als conversie-data 0 is over alle bronnen, meld dit expliciet als mogelijke
tracking-issue en stel voor om de GTM configuratie te controleren.

---

## Directory-structuur

Alle marketing data leeft in `private/marketing/`. Als deze map niet bestaat,
maak hem aan met de volledige structuur. Zie `references/setup.md` voor het
complete setup-proces.

```
private/marketing/
├── README.md
├── gtm-datalayer.md              # GTM event contract (indien van toepassing)
├── google-ads/
│   └── report-YYYY-MM-DD.md
├── microsoft-clarity/
│   └── report-YYYY-MM-DD.md
├── linkedin-ads/
├── meta-ads/
├── seo-analytics/
├── optimizations/
│   └── report-YYYY-MM-DD.md      # Cross-channel rapporten
└── todo/
    ├── backlog.md                 # Cross-channel actiepunten
    ├── google-ads.md
    ├── microsoft-clarity.md
    ├── linkedin-ads.md
    ├── meta-ads.md
    ├── seo-analytics.md
    └── website-aanpassingen.md
```

**Bestandsnamen**: `report-YYYY-MM-DD.md` (ISO-datum in bestandsnamen)

**Altijd** bestaande rapporten lezen voordat je nieuwe genereert — ze bevatten
baselines, KPI-targets en historische context voor trendanalyse.

---

## Taal & Opmaak

- Rapporten in **Nederlands (nl-NL)**
- Valuta: EUR (€)
- Datum in tekst: DD-MM-YYYY
- Datum in bestandsnamen: YYYY-MM-DD
- Status-indicators: `Kritiek` / `Waarschuwing` / `Goed` / `Uitstekend`
- Prioriteiten: P0 (Kritiek), P1 (Hoog), P2 (Medium), P3 (Laag)

---

## Agents

Elke rapportage draait als subagent. **Lees het agent-bestand zelf** en stuur
de volledige inhoud mee in de Task prompt — subagents hebben geen toegang tot
de skill-directory.

- `agents/microsoft-clarity.md` — Clarity gedragsanalyse (MCP data ophalen + rapport)
- `agents/google-ads.md` — Google Ads performance (MCP/handmatig + rapport)
- `agents/cross-channel.md` — Combineert kanaal-rapporten tot cross-channel analyse

Stuur ook het relevante template uit `references/templates.md` mee, zodat de
subagent het juiste rapportformat gebruikt.

Nieuwe kanalen toevoegen? Maak een nieuw agent-bestand met dezelfde structuur
(input → data ophalen → analyseren → rapport schrijven → actiepunten teruggeven).

---

## Referenties

- `references/templates.md` — Volledige rapportage-templates (Google Ads, Clarity, Cross-channel)
- `references/setup.md` — Setup-instructies voor de directory-structuur en todo-templates

@rules/
