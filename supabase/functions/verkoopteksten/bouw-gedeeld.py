"""Plakt gedeeld.js tussen de markeringen in index.ts en in de app (index.html).
Gebruik vanuit de projectmap: python3 supabase/functions/verkoopteksten/bouw-gedeeld.py"""
import pathlib, re, sys

hier = pathlib.Path(__file__).resolve().parent
project = hier.parents[2]
blok = (hier / "gedeeld.js").read_text().strip()
app = next(p for p in (project / "verkooppraat-live.html", project / "index.html") if p.exists())
doelen = [hier / "index.ts", app]
patroon = re.compile(r"/\* GEDEELD-START \*/.*?/\* GEDEELD-EINDE \*/", re.S)
for pad in doelen:
    tekst = pad.read_text()
    if not patroon.search(tekst):
        sys.exit(f"Markeringen ontbreken in {pad}")
    tekst = patroon.sub(lambda m: "/* GEDEELD-START */\n" + blok + "\n/* GEDEELD-EINDE */", tekst)
    pad.write_text(tekst)
    print("bijgewerkt:", pad.name)
