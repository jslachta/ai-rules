# AI-asistovaný vývoj — pravidla pro projekty (sloučený draft)

Interní směrnice (závazná část A) + best practices (část B) pro AI-asistovaný vývoj,
rozdělené pro dlouhodobé/zavedené a nové projekty.

> **Stav: DRAFT.** Vše je sloučeno do jediného `ai-rules.tex` kvůli snazší ruční revizi.
> Po zamrznutí draftu lze opět rozdělit na `sekce/*.tex` (sekce jsou v souboru
> vyznačené komentáři `% SEKCE: ...`).

## Obsah

- **Část A** — závazná pravidla (vč. A1.7: data pod NDA a nedůvěryhodné AI nástroje)
- **Část B** — doporučení (vč. B4: rozhodovací škála režimů práce s AI pod NDA)
- Onboarding checklisty, kategorizace projektu, šablona ADR

## Build

Vyžaduje TeX Live 2026 (nebo MiKTeX se stejně čerstvým jádrem LaTeXu, 2026-06-01+)
s `lualatex` a `latexmk`. Starší instalace tagování buď nemají, nebo mají v
nekonzistentní verzi — `latex-lab` novější než `l3kernel` se projeví chybami už
v `\DocumentMetadata`; pak pomůže aktualizace distribuce.

```sh
make          # vytvoří všechna PDF (latexmk opakuje běhy, dokud se neustálí TOC a odkazy)
make cs       # jen česká varianta
make en       # jen anglická varianta
make clean    # smaže pomocné soubory
make watch    # průběžný build hlavního dokumentu
```

## Tagované PDF (PDF/UA-2)

Výstup je tagované PDF 2.0 podle PDF/UA-2 (přístupnost: čtečky obrazovky,
přeformátování, extrakce textu). Zapíná ho `\DocumentMetadata` na začátku
`preamble.tex`; proto engine LuaLaTeX — XeLaTeX tagovat neumí. Shodu ověřuje
v CI veraPDF a nevyhovující PDF build shodí.

Co z toho plyne pro úpravy zdroje:

- **Žádná matematika pro symboly.** Vzorec v tagovaném PDF potřebuje
  alternativní text; místo `$\rightarrow$`, `$\sim$`, `$-$`, `$\square$`
  použij makra `\then`, `\sympart`, `\sympoor`, `\cb` z preambule.
- **Nadpisy jen přes `\section` a spol.** Vzhled se nastavuje šablonami
  (`\EditInstance{heading}{...}`), ne balíkem `titlesec` — ten je s tagováním
  nekompatibilní a nadpisy by v PDF nebyly nadpisy.
- **Tabulky mají v prvním řádku hlavičku** (`table/header-rows={1}` v preambuli).
  Tabulka bez hlavičkového řádku potřebuje před sebou vlastní `\tagpdfsetup`.
- **Nové balíčky prověř** — přidej do `\DocumentMetadata` klíč
  `check-tagging-status` a v logu je přehled, které balíčky jsou s tagováním
  kompatibilní. Nekompatibilní jsou např. `titlesec`, `fvextra`.
- Odkaz v patičce/záhlaví nesmí být (patička je artefakt) — proto `\pageref*`.

## Struktura ai-rules.tex

- řádky po `\begin{document}` — preambule, styl, paleta, makra
- dále sedm sekcí oddělených komentářem `% SEKCE: <jmeno>.tex`

## Metadata a klasifikace dokumentu

Titul, PDF subjekt a klasifikaci v patičce řídí makra `\doctitle`, `\docsubject`
a `\docclass` v `preamble.tex`; každý dokument je může přepsat přes `\renewcommand`
(viz `motivace.tex`). Při převzetí šablony jako interní směrnice změň `\docclass`
na `Interní` — jde o jediné místo pro oba dokumenty.

## Jazykové varianty

Česká varianta je v kořeni, anglická v `en/` (`ai-rules.tex`, `motivation.tex`
jako protějšek `motivace.tex`, a vlastní `preamble.tex`). Struktura sekcí i
pořadí odstavců jsou shodné, takže jdou porovnávat řádek po řádku.
Anglická preambule se liší
jen v jazyce (`\setdefaultlanguage{english}`), uvozovkách, metadatech a
řetězci v patičce; vše ostatní je shodné. Buduje se z adresáře `en/`, protože
`\input{preamble.tex}` se hledá vůči aktuálnímu adresáři.

## Konvence

- **One-sentence-per-line**: změna věty = jeden řádek v diffu.
- **Obě jazykové varianty se drží v synchronu**: věcná změna pravidla patří
  do české i anglické verze v témže MR (vydávají se pod stejnou verzí).
- PDF se needituje ručně ani neverzuje (viz `.gitignore`); buduje se z `.tex`.
- Konkrétní projekty se zde neuvádějí — budou předmětem samostatného vzorového dokumentu.
