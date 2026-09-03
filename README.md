# arshiailaty.github.io

Personal academic website of **Arshia Ilaty** — joint Ph.D. student at UC Irvine
(Donald Bren School of ICS) and San Diego State University. Research interests:
LLMs, anomaly & fraud detection, NLP, query processing, distributed systems, and
federated learning. Previously a software engineer at World Mobile and Tesla.

Live site: <https://arshiailaty.github.io/>

## Structure

| File | Purpose |
|------|---------|
| `index.html` | Professional page — tabbed: Overview, Research (publications), Teaching, Entrepreneurship, Services & Awards |
| `personal.html` | Personal page — background, hobbies, photos |
| `schedule.html` | Embedded Google Calendar for booking time |
| `assets/css/custom.css` | Design tokens (indigo/teal), dark theme, and all custom components |
| `assets/js/custom.js` | Dark-mode toggle, scroll-reveal, image lightbox |
| `optimize-images.sh` | Local helper to shrink the `images/` folder |

Built on the [HTML5 UP "Story"](https://html5up.net/story) template. No build
step — it's plain HTML/CSS/JS served straight from the repo by GitHub Pages.

## Features

- **Light/dark theme** — toggle in the nav; remembers your choice and honors the
  OS `prefers-color-scheme` on first visit.
- **Publications** as cards with color-coded venue badges (arXiv, NeurIPS, AACR,
  JMIR, Zenodo).
- **Skill chips**, a hero highlight strip, scroll-reveal animations (disabled for
  `prefers-reduced-motion`), and a click-to-zoom photo lightbox.
- SEO / social: per-page meta descriptions, Open Graph, and Twitter Card tags.

## Preview locally

No dependencies needed — serve the folder with any static server:

```bash
python3 -m http.server 8137
# then open http://localhost:8137
```

## Adding a publication

Publications live in the **Research** tab of `index.html`, inside
`<ol class="papers-list">`. Copy an existing `<li class="paper">` block and edit
the four spans (`paper-title`, `paper-authors`, `paper-venue`, `paper-links`);
wrap your own name in `<strong>`. Add an optional venue badge with
`<span class="pub-badge pub-badge--arxiv">arXiv</span>` (badge classes:
`--arxiv`, `--neurips`, `--aacr`, `--jmir`, `--zenodo`, `--journal`). Keep the
list newest-first. Full list and citation counts:
[Google Scholar](https://scholar.google.com/citations?user=IsR-aEMAAAAJ&hl=en).

## Optimizing images

The `images/` folder is large; before adding more, run the helper on your Mac
(needs `brew install imagemagick`, optional `brew install webp`):

```bash
./optimize-images.sh          # resize + compress in place (backs up first)
./optimize-images.sh --webp   # also emit .webp copies
```

## License

Site content © Arshia Ilaty. Template under the
[CCA 3.0 license](https://html5up.net/license) (HTML5 UP).
