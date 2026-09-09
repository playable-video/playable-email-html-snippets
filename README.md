# playable-email-html-snippets

A library of HTML email templates that embed Playable Video. Keep one file per brand/campaign so new builds can start from the closest existing template.

## Templates

| File | Brand | Playable snippet | Video slot | Notes |
|------|-------|------------------|------------|-------|
| `aeromexico.html` | AeroMexico | Legacy (muted autoplay, `playable-reveal` blur-in) | 650x278, 16:9-ish | Two CTAs, dark navy background, Roboto/Space Grotesk |
| `thatconceptstore.html` | THAT Concept Store | Legacy (muted autoplay, `playable-reveal` blur-in) | 600x336, 16:9 | Single outlined CTA on black, demo Playable asset |
| `blizzardinternal.html` | Playable (Blizzard internal) | Legacy (muted autoplay) | 600x336, 16:9 | Stripo-style export with rollover images and hover states |
| `kennardssound.html` | Kennards Hire | v1.4 + Apple Mail baseline-gap fix, sound-enabled (`native.m3u8` / `native.mp4` with controls) | 600x1066, portrait | Four-step editorial layout, red/black brand, prototype landing page fallback |
| `jpmorgansound.html` | J.P. Morgan Private Bank | v2.0 responsive stage, sound-enabled (`native.m3u8` / `native.mp4` with controls) | 600x336, 16:9 | Marketo template (`{{my.*}}`, `{{lead.*}}` tokens), "Outlook? click here for sound" link, dark-mode classes |

## Conventions

- Filenames are lowercase with no separators (e.g. `thatconceptstore.html`). Suffix `sound` marks templates using the sound-enabled snippet.
- Personalised Playable URLs use the `{{${user_id}}}` merge token; swap for your ESP's syntax.
- "Legacy" snippets hide the `<video>` behind `@media (-webkit-video-playable-inline)` and fall back to an animated `<img>`. "Sound" snippets add a third block with native HTML5 controls for webmail clients.
