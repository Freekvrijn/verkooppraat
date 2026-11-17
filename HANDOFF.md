# HANDOFF.md – technische overdracht VerkoopPraat

Bijgewerkt: 17 november 2026 (na iteratie 008). Lees eerst `AGENTS.md`.

## Wat is klaar

| Onderdeel | Waar | Getest |
| --- | --- | --- |
| App (invoer, vaste teksten, kanalen, planner) | `verkooppraat-live.html` = `repo/index.html` | Ja, in Safari (iteratie 007) |
| Live site | https://freekvanrijn.nl/verkooppraat/ (GitHub Pages, repo `Freekvrijn/verkooppraat`, branch `main`) | Ja |
| Claude-artifact | https://claude.ai/artifact/ToEHgrCNwsBVXQYTuW1B87 (privé, versie 8, capabilities sample/db/user/downloads) | Deels; planner in het artifact niet getest |
| Supabase-project | `oznirspodtzyqtbmzhlf` (‘VerkoopPraat’, organisatie AI Skills Lab, gratis laag) | Ja |
| Tabellen | `histories` (`supabase/schema.sql`) en `posts` (`supabase/schema-planner.sql`), RLS: alleen eigen rijen | Ja, met twee anonieme gebruikers |
| Auth | Anonieme login aan; de sessie staat in localStorage (`vp_sb_session`) | Ja |
| Edge Function | `verkoopteksten` (`supabase/functions/verkoopteksten/index.ts`); onderdelen `all`/`slogan`/`insta`/`pitch` en `kanalen` | Ja |
| AI | Gemini 3.7 Flash, terugval op 3.5 Flash Lite. Sleutel ‘VerkoopPraat’ in Google AI Studio (Default Gemini Project, Tier 1). Maandlimiet € 5 | Ja |
| Documentatie | `docs/PRD.md`, `docs/proceslog.md`, `docs/bewijs/iteratie-001` t/m `007` | – |

## Wat werkt nog niet of is onbekend

- **Nog niet gebouwd (uit de feedbackrollen):** een CAPTCHA op anonieme aanmelding, het opruimen van oude anonieme accounts, een AI-vermelding bij het kopiëren en het automatisch inkorten van te lange teksten.
- **PWA:** installeren op een echte telefoon is nog niet getest.
- **Lengte ‘kort’:** de AI houdt ‘kort’ niet altijd aan (Instagram kort: 130 in plaats van 125). De teller maakt dat zichtbaar.
- **Rate limit:** de limiet in de Edge Function (20 per 10 minuten) geldt per functie-instantie en is dus niet waterdicht.
- **Onbekend:** de planner in het Claude-artifact (versie 8) en de app op een echte telefoon.
- **Screenshots:** die van iteratie 002 tot en met 007 ontbreken; Freek maakt ze zelf.

## Klaar in iteratie 008

- **PWA:** `manifest.webmanifest`, `sw.js` en `pwa/`.
- **Feedbackrollen:** review door vier subagents, met verbeteringen; zie `docs/bewijs/iteratie-008/`.
- **Documenten:** `docs/PRD.md`, `AGENTS.md` en dit bestand.

## Volgende stappen

1. Feedback van een ander groepje ophalen (les 2-2) en verwerken.
2. Bevindingen uit de feedbackrollen oppakken die hoog scoren.
3. Later: bol.com-productgegevens inlezen, met N8N inplannen en publiceren, en resultaten terugmeten.

## Handig om te weten

- **Gedeelde regels:** pas `gedeeld.js` aan en draai dan `python3 supabase/functions/verkoopteksten/bouw-gedeeld.py`. Kopieer de app daarna naar `repo/index.html`.
- **Lokaal testen:** `python3 -m http.server 8765` in deze map, dan `http://127.0.0.1:8765/verkooppraat-live.html`. Supabase staat 127.0.0.1:8765 toe als herkomst.
- **Edge Function deployen:** in het dashboard verschijnt na ‘Deploy updates’ nog een bevestigingsvenster. Zonder bevestiging blijft de oude versie draaien.
