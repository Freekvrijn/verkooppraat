# VerkoopPraat – Maak het verkoopbaar

Live: **https://freekvanrijn.nl/verkooppraat/**

VerkoopPraat helpt iemand die de marketing van een kleine webshop doet. Je vult een product in, kiest een doelgroep en een schrijfstijl, en krijgt een slogan, een Instagrambericht en een verkooppitch van 20 seconden. De teksten kun je aanpassen, kopiëren en bewaren.

Gemaakt door Freek van Rijn voor AI Skills Lab (minor AI Marketing & Salesadviseur), november 2026. Demo met verzonnen gegevens, zoals de webshop CampusFles.

## Hoe het werkt

```
Browser (GitHub Pages)
  │  publieke publishable key + anonieme login
  ▼
Supabase
  ├─ tabel histories   → bewaarde teksten; Row Level Security: iedereen ziet alleen eigen rijen
  └─ Edge Function     → bouwt de prompt en roept Google Gemini aan (gemini-3.7-flash, terugval op gemini-3.5-flash-lite)
                         de Gemini-sleutel staat alleen als Supabase-secret
```

- `index.html`: de hele app (HTML, CSS en JavaScript, geen build nodig).
- `supabase/schema.sql`: tabel, rechten en RLS-policies.
- `supabase/schema-planner.sql`: tabel `posts` voor de contentplanner (zelfde RLS-aanpak).
- `supabase/functions/verkoopteksten/index.ts`: de Edge Function voor de AI.
- `supabase/functions/verkoopteksten/gedeeld.js`: kanalen, tekenlimieten en prompts. Staat letterlijk in `index.html` en `index.ts`; plakken met `python3 supabase/functions/verkoopteksten/bouw-gedeeld.py`.

## Kanalen en contentplanner

Bij stap 4 kies je in een vinkjestabel per kanaal wat je wilt: slogan, post, pitch of advertentie. Alleen die combinaties worden gemaakt, in het formaat van het kanaal: Instagram, Facebook, LinkedIn, TikTok, X, Google Ads (koppen en beschrijvingen), Meta Ads (primaire tekst, kop en knop), e-mail (onderwerpregel en openingszin) en WhatsApp. Per kanaal kies je kort, middel of lang.

Elke tekst krijgt een kaart met een tekenteller. Die wordt oranje boven de aanbevolen lengte en rood boven de harde limiet van het platform. Met een datum en een status (concept, klaar of geplaatst) zet je de tekst in de contentplanner. Die wordt in de database bewaard. ‘Kopieer deze week’ en ‘Download deze week’ geven alle teksten van de huidige week in één keer.

De kosten van Gemini zijn begrensd met een maandlimiet van € 5. De publishable key in `index.html` is bedoeld voor de browser en geeft alleen toegang via RLS. Er staat geen geheime sleutel in deze repository.

## Regels voor de AI

De AI mag alleen feiten gebruiken die je zelf invult: product, sterke punten, prijs en merk. Geen verzonnen eigenschappen, kortingen, percentages of beloofde effecten. De pitch heeft maximaal 45 woorden. Woorden die op een verzonnen claim kunnen wijzen, markeert de app met een waarschuwing.

Als de AI niet bereikbaar is, schrijft een ingebouwde voorbeeldgenerator de teksten. De app laat altijd zien waar een tekst vandaan komt.

## Twee versies

| | GitHub-versie (deze) | Claude-artifact |
| --- | --- | --- |
| AI | Google Gemini 3.7 Flash via Supabase Edge Function | Claude, ingebouwd in het artifact |
| Database | Supabase | Database van het artifact (Supabase is daar geblokkeerd) |
| Openbaar | Ja | Nee, alleen binnen de organisatie |

Het proces, de tests en de fouten per iteratie staan in het schooldossier.
