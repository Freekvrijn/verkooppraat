# PRD – VerkoopPraat voor bol.com-verkooppartners

Product requirement document · versie 1.0 · 17 november 2026
Groep: Freek van Rijn, Jorn Leemkuil, Joep van den Akker · AI Skills Lab

> **Status:** dit PRD is achteraf opgesteld. Er stonden al zeven iteraties (zie `docs/bewijs/`). Het legt vast wat er is, wat de eisen zijn en wat de volgende fases zijn. Vanaf nu is dit document leidend: nieuwe bouwopdrachten verwijzen naar de eisen hieronder (F1, N2, enzovoort).

## 1. Doel

Een verkooppartner van bol.com maakt in een paar minuten kloppende, pakkende verkoopteksten voor al zijn kanalen, en plant wanneer hij wat plaatst.

**Succes betekent:**

- **Snel:** binnen 1 minuut teksten voor minstens 3 kanalen.
- **Binnen de limieten:** geen tekst over de harde limiet van het kanaal, en anders ziet de gebruiker dat direct.
- **Geen verzinsels:** geen verzonnen producteigenschappen. Waar de AI toch iets riskants noemt, waarschuwt de app.

## 2. Context

bol.com is een online winkel in Nederland en België waar ook externe verkopers (verkooppartners) producten aanbieden. Partners moeten hun aanbod zelf promoten op social media, in advertenties en per e-mail. Er is **geen afspraak met bol.com**; dit is een schoolcase. De demo gebruikt verzonnen gegevens (CampusFles, drinkfles van 750 ml, € 19,95).

## 3. Gebruikers

| Persona | Situatie | Behoefte |
| --- | --- | --- |
| **Sanne, verkooppartner** (eenmanszaak, verkoopt via bol.com en een eigen webshop) | Doet ‘de marketing er bij’, weinig tijd, geen copywriter | Snel bruikbare teksten per kanaal, binnen de regels, en overzicht over wat er deze week geplaatst moet worden |
| **Contentmedewerker bij bol.com** | Bereidt posts voor acties en categorieën voor | Varianten per doelgroep en kanaal, plannen en status bijhouden |

De **doelgroep van de teksten** (studenten, ouders, ouderen, enzovoort) kiest de gebruiker per keer.

## 4. Probleem

1. **Lege pagina:** elke tekst begint opnieuw.
2. **Andere regels per kanaal:** X 280 tekens, Google Ads-koppen 30, Instagram maximaal 5 hashtags.
3. **Verzonnen claims:** AI-teksten beloven snel iets wat niet klopt, met een risico op misleidende reclame.
4. **Geen overzicht:** posts raken verspreid en de status is onduidelijk.

## 5. Functionele eisen

| ID | Eis | Prioriteit | Stand |
| --- | --- | --- | --- |
| F1 | Invoer: product (verplicht), doelgroep (lijst of eigen), stijl (lijst of eigen), en optioneel sterke punten, prijs, merk, toon en emoji's | Must | Klaar |
| F2 | Vaste teksten: slogan (≤ 10 woorden), Instagrambericht en pitch van 20 seconden (4 delen, ≤ 45 woorden) | Must | Klaar |
| F3 | Elke tekst is bewerkbaar en te kopiëren; ‘Nieuw’ per onderdeel | Must | Klaar |
| F4 | De bron is zichtbaar: ‘Gemaakt door AI’ of ‘Voorbeeldgenerator’, en welk AI-model actief is | Must | Klaar |
| F5 | Stap 4: vinkjestabel kanaal × soort (slogan, post, pitch, advertentie) met kort, middel of lang; alleen gekozen combinaties worden gemaakt | Must | Klaar |
| F6 | Kaart per kanaal: velden in het formaat van het kanaal, tekenteller (oranje boven advies, rood boven limiet), call-to-action en kopieerknop | Must | Klaar |
| F7 | Contentplanner: datum en status (concept, klaar, geplaatst) opslaan in de database; weergave ‘Deze week’ of ‘Alles’ | Must | Klaar |
| F8 | ‘Kopieer deze week’ en ‘Download deze week’ (.txt) | Should | Klaar |
| F9 | Waarschuwing bij woorden of getallen die niet in de invoer staan (korting, gratis, %, enzovoort) | Must | Klaar voor de vaste teksten; **nog niet voor kanaalteksten** |
| F10 | Doelgroepvergelijking: hetzelfde product voor andere doelgroepen | Could | Klaar |
| F11 | Bewaarde teksten terugzetten (database en browsergeschiedenis) | Should | Klaar |
| F12 | Installeerbaar op de telefoon (PWA) | Should | Fase 8 |
| F13 | Productgegevens ophalen uit het bol.com-partneraanbod | Later | Niet gepland |
| F14 | Rechtstreeks inplannen of publiceren via sociale-media-API's, bijvoorbeeld met N8N | Later | Les 3 (N8N) |

## 6. Niet-functionele eisen

| ID | Eis |
| --- | --- |
| N1 | **Taal:** alle tekst in de app en in de uitvoer in correct Nederlands. |
| N2 | **Privacy:** iedere gebruiker ziet alleen de eigen gegevens (Supabase RLS, anonieme login). Geen persoonsgegevens nodig; alleen verzonnen of zakelijke productgegevens. |
| N3 | **Veiligheid:** geen geheime sleutels in de browser of op GitHub. De AI-sleutel staat alleen als Supabase-secret. De Edge Function bouwt zelf de prompt (geen open AI-proxy). |
| N4 | **Kosten:** AI-kosten begrensd (maandlimiet € 5 in Google AI Studio en maximaal 20 aanvragen per gebruiker per 10 minuten). |
| N5 | **Snelheid:** vaste teksten binnen ±10 s, teksten per kanaal binnen ±45 s (ook na een koude start). |
| N6 | **Mobiel:** bruikbaar vanaf 375 px breed, zonder horizontaal scrollen; licht en donker thema. |
| N7 | **Uitval:** valt de AI weg, dan maakt de voorbeeldgenerator de teksten en meldt de app dat; valt de database weg, dan meldt de app dat en blijft het genereren werken. |

## 7. AI-regels (samenvatting van `gedeeld.js`)

- **Feiten:** alleen uit product, sterke punten, prijs en merk. Het directe gevolg van een eigenschap mag (‘lekvrij → geen natte tas’), nieuwe onderdelen of getallen niet.
- **Geen lege of misleidende woorden:** geen ‘handig’, ‘perfect’, ‘slechts’, geen kortingen, levertijden of gezondheidsclaims.
- **Stijl en humor:** de stijl bepaalt de toon. Bij ‘grappig’ en ‘speels’ gaat humor voor, via de situatie en zonder clichés.
- **Lengte:** ‘kort’, ‘middel’ en ‘lang’ zijn harde bovengrenzen. De limieten per kanaal staan in `gedeeld.js` (gecontroleerd 17 november 2026).

## 8. Schermen en flow

1. **Invoer (links):** product → doelgroep → stijl → stap 4 kanalen → meer details → ‘Maak de verkoopteksten’.
2. **Teksten (rechts):** invoercontrole, slogan, Instagram, pitch met timer, knoppen, kaarten per kanaal, opgeslagen teksten en browsergeschiedenis.
3. **Contentplanner (onder):** week of alles, per dag gegroepeerd, met status en datum per tekst, kopiëren en downloaden.

## 9. Gegevens

| Tabel / pad | Inhoud |
| --- | --- |
| `histories` (Supabase) of `data/users/<id>/` (artifact) | Bewaarde sets met de vaste teksten |
| `posts` (Supabase) of `data/users/<id>/planner/posts` (artifact) | Teksten per kanaal: kanaal, soort, velden, call-to-action, status, datum en product |

## 10. Acceptatiecriteria (testbaar)

1. **Lege invoer:** een leeg product of alleen spaties geeft een foutmelding en zet de focus op het productveld.
2. **Drinkflestest:** de vaste invoer (CampusFles, studenten) levert teksten zonder verzonnen eigenschappen en met de prijs ‘€ 19,95’.
3. **Google Ads:** koppen ≤ 30 tekens, beschrijvingen ≤ 90; een X-post ≤ 280.
4. **Teller:** een tekst boven de limiet maakt de teller rood, boven het advies oranje.
5. **Planner:** ‘Alles in planner’ → herladen → de teksten en hun status staan er nog. Een datum buiten deze week verdwijnt uit ‘Deze week’.
6. **Privé:** een tweede (anonieme) gebruiker ziet de rijen van de eerste niet.
7. **Mobiel:** op 390 px breed staat alles in één kolom en scrolt niets horizontaal.
8. **Uitval:** zonder AI verschijnen voorbeeldteksten met een melding.

## 11. Fases

| Fase | Inhoud | Stand |
| --- | --- | --- |
| 1 | Verbeteren van het gedeelde artifact (claims, score, pitch) | Klaar (iteratie 001) |
| 2 | Echte AI en database | Klaar (002–003) |
| 3 | Betere teksten: model en prompt | Klaar (004) |
| 4 | Rustige, overzichtelijke vormgeving | Klaar (005–006) |
| 5 | Kanalen en contentplanner | Klaar (007) |
| 6 | PWA, feedbackrollen, waarschuwingen ook bij de kanaalteksten | Bezig (008) |
| 7 | Feedback van een ander groepje verwerken | Les 2-2 |
| Later | bol.com-productdata, N8N-automatisering, publiceren via API | Na sprint 1 |

## 12. Open vragen

- Accepteert de docent GitHub Pages in plaats van Netlify of Vercel?
- Mogen we de naam bol.com in een openbare demo gebruiken? (Nu wel, met de melding dat er geen afspraak is.)
- Willen we inloggen met e-mail, zodat de planner op meerdere apparaten werkt? (Nu anoniem per browser.)
