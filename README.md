# Baby Track

A simple, mobile-first, local-first baby care and development tracker. The application has no runtime dependencies, account requirement, analytics SDK, or remote database.

## Features

### Daily care
- Feeding: breast, bottle, formula, solids, optional amount in oz/mL
- Sleep: enter a duration or start/stop a live timer
- Diapers: wet, dirty, both, or dry
- Pumping: duration or live timer
- Tummy time: duration or live timer
- Medicine administration log (logging only; the app does not recommend doses)
- General notes
- Today dashboard and chronological timeline

### Growth & development
- Weight, length, and head-circumference history
- Development journal organized by CDC milestone ages from 2 months through 3 years
- Milestone completion progress
- Direct link to CDC's official milestone resources

The milestone journal is not a diagnostic or screening instrument. CDC describes milestones as things most children (75% or more) can do by a given age. Concerns about development should be discussed with a child's healthcare professional.

### Insights
- 7- and 30-day care summaries
- Average feeds and diapers per day
- Recorded sleep average
- Daily logging activity visualization
- Tummy-time totals

These summaries describe the data entered by the caregiver; they do not determine whether a baby's feeding, sleep, growth, or development is medically appropriate.

### Privacy & backup
Baby Track stores its data in browser `localStorage`. It does not send baby data to a server. Users can export a complete JSON backup, import it later, or erase all local data from the profile screen.

Browser data can be cleared by the browser or operating system, so important records should be exported periodically.

## Run

No package installation or build step is required:

```bash
python3 -m http.server 8000
```

Open `http://localhost:8000`.

For PWA/service-worker behavior, serve the application over HTTP(S) rather than opening the HTML as a local file.

## Architecture

- `index.html` — semantic application shell and dialogs
- `styles.css` — responsive mobile-first design system
- `app.js` — data model, care logging, timers, growth, milestones, insights, import/export
- `manifest.webmanifest` — installable web-app metadata
- `sw.js` — offline application-shell cache

Data uses a versioned `baby-track-v2` localStorage key and migrates the original `baby-track-v1` record on first load.

## Potential next phase

The local-first architecture can be extended with optional encrypted caregiver sync, multiple children, pediatric visit reports, reminders, vaccination/appointment records, attachment support, growth-chart percentile calculations using validated standards, and authenticated cloud backup. Those features should remain optional so the core logging flow stays fast and private.
