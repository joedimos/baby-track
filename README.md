# Baby Track

A deliberately simple, mobile-first baby care and development tracker.

## What it tracks

- Feeding (breast, bottle, formula, solids)
- Sleep logs and duration
- Diapers
- Tummy time
- Notes and daily timeline
- Weight, length, and head circumference
- Developmental milestone memories
- Baby name, birth date, and calculated age
- JSON data export

## Privacy

Version 1 is local-first. Data is stored in the browser using `localStorage`; there is no account, analytics service, remote database, or third-party data transmission in the app.

Because browser storage can be cleared, use **Export my data** periodically for anything you want to preserve.

## Run locally

No build step or dependencies are required.

```bash
python3 -m http.server 8000
```

Then open `http://localhost:8000`.

You can also open `index.html` directly for most functionality.

## Product philosophy

Baby Track is designed for tired parents: common actions should take only a few taps, the current day is the default view, and deeper history stays out of the way until it is needed.

Milestones are intentionally presented as a personal development log rather than a screening or diagnostic system. Development varies between children; questions or concerns belong with a qualified pediatric clinician.

## Next-stage architecture

The local data model is intentionally small so a later release can add optional family sync, authentication, pediatric visit reports, reminders, richer charts, and encrypted cloud backup without making the core logging workflow complicated.
