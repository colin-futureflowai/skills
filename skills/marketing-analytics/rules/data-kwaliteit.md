# Data Kwaliteit Regels

## Bronvermelding

Vermeld bij elke metric uit welke bron deze komt (Clarity MCP, Google Ads MCP,
handmatig aangeleverd, of vorig rapport). Dit maakt het rapport verifieerbaar
en helpt bij het opsporen van data-inconsistenties.

## Vergelijkingen

Vergelijk alleen data uit dezelfde bron en dezelfde periode-lengte. Een
30-dagen Clarity rapport vergelijken met een 7-dagen Google Ads export
geeft misleidende conclusies.

## Ontbrekende data

Vul geen data in die je niet hebt. Gebruik "n/b" (niet beschikbaar) in
tabellen en leg uit waarom de data ontbreekt. Gissingen presenteren als
feiten ondermijnt het vertrouwen in het hele rapport.

## Conversie-tracking verificatie

Als conversie-data 0 is over alle bronnen heen, behandel dit als een
tracking-probleem totdat het tegendeel bewezen is. Check:
1. Zijn GTM events correct geconfigureerd?
2. Worden smart events geregistreerd in Clarity?
3. Is de Google Ads conversie-tag actief?

## Trend-analyse

Gebruik minstens 2 datapunten voor trend-uitspraken. Een enkele meting
is een snapshot, geen trend. Wees expliciet over het aantal datapunten
waarop een trend-conclusie gebaseerd is.
