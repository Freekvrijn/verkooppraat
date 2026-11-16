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
  └─ Edge Function     → bouwt de prompt en roept Google Gemini aan (gratis laag)
                         de Gemini-sleutel staat alleen als Supabase-secret
```

- `index.html`: de hele app (HTML, CSS en JavaScript, geen build nodig).
- `supabase/schema.sql`: tabel, rechten en RLS-policies.
- `supabase/functions/verkoopteksten/index.ts`: de Edge Function voor de AI.

De publishable key in `index.html` is bedoeld voor de browser en geeft alleen toegang via RLS. Er staat geen geheime sleutel in deze repository.

## Regels voor de AI

De AI mag alleen feiten gebruiken die je zelf invult: product, sterke punten, prijs en merk. Geen verzonnen eigenschappen, kortingen, percentages of beloofde effecten. De pitch heeft maximaal 45 woorden. Woorden die op een verzonnen claim kunnen wijzen, markeert de app met een waarschuwing.

Als de AI niet bereikbaar is, schrijft een ingebouwde voorbeeldgenerator de teksten. De app laat altijd zien waar een tekst vandaan komt.

## Twee versies

| | GitHub-versie (deze) | Claude-artifact |
| --- | --- | --- |
| AI | Google Gemini via Supabase Edge Function | Claude, ingebouwd in het artifact |
| Database | Supabase | Database van het artifact (Supabase is daar geblokkeerd) |
| Openbaar | Ja | Nee, alleen binnen de organisatie |

Het proces, de tests en de fouten per iteratie staan in het schooldossier.
