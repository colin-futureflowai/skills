# Setup: Marketing Directory-structuur

## Eerste keer setup

Als `private/marketing/` niet bestaat of incompleet is:

### 1. Maak de volledige structuur aan

```
private/marketing/
├── README.md
├── gtm-datalayer.md
├── google-ads/
│   └── .gitkeep
├── microsoft-clarity/
│   └── .gitkeep
├── linkedin-ads/
│   └── .gitkeep
├── meta-ads/
│   └── .gitkeep
├── seo-analytics/
│   └── .gitkeep
├── optimizations/
│   └── .gitkeep
└── todo/
    ├── backlog.md
    ├── google-ads.md
    ├── microsoft-clarity.md
    ├── linkedin-ads.md
    ├── meta-ads.md
    ├── seo-analytics.md
    └── website-aanpassingen.md
```

### 2. Todo-template voor kanaal-bestanden

Gebruik dit template voor elke `todo/<kanaal>.md`:

```markdown
# [Kanaal] — Actiepunten

## Prioriteit Legenda
- **P0**: Kritiek — direct oppakken (deze week)
- **P1**: Hoog — komende 2 weken
- **P2**: Medium — deze maand
- **P3**: Laag — backlog

## Actiepunten

_Nog geen items. Worden geëxtraheerd uit rapporten._
```

### 3. Backlog-template

Gebruik dit voor `todo/backlog.md`:

```markdown
# Marketing Backlog — Cross-Channel Actiepunten

## Prioriteit Legenda
- **P0**: Kritiek — direct oppakken (deze week)
- **P1**: Hoog — komende 2 weken
- **P2**: Medium — deze maand
- **P3**: Laag — backlog

## Actiepunten

_Nog geen items. Worden geëxtraheerd uit cross-channel rapporten._
```

### 4. README.md

```markdown
# Marketing Data

Dit is de centrale plek voor alle marketing rapportages en analyses.

## Structuur

- `google-ads/` — Google Ads performance rapporten
- `microsoft-clarity/` — Website gedragsanalyses
- `linkedin-ads/` — LinkedIn Ads rapporten (optioneel)
- `meta-ads/` — Meta/Facebook Ads rapporten (optioneel)
- `seo-analytics/` — SEO analyses (optioneel)
- `optimizations/` — Cross-channel rapporten en optimalisatie-plannen
- `todo/` — Actiepunten per kanaal + cross-channel backlog

## Bestandsnamen

Rapporten: `report-YYYY-MM-DD.md`

## GTM DataLayer

Als het project GTM gebruikt, documenteer de event-structuur in `gtm-datalayer.md`.
Dit helpt bij het analyseren van conversie-tracking problemen.
```

### 5. Bevestig setup

Na het aanmaken, meld aan de gebruiker:
- Welke mappen zijn aangemaakt
- Stel voor om het eerste rapport te genereren
- Vraag of er een GTM DataLayer contract is om te documenteren
