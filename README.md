# Playable email HTML snippets

The Playable Video email snippet in every version we've used, plus every customer email we've built with it.

- **Starting a new email?** Copy the current control snippet from [`snippets/v2.0/`](snippets/v2.0/).
- **Need a past build?** Finished customer emails live in [`templates/`](templates/) as the record of what shipped.

## What's in here

```
snippets/                  control snippets, one folder per version
  v2.0/                    current
    snippet.html           copy-from snippet with __PLACEHOLDERS__
    control-email.html     minimal test email using Playable's demo video
  v1.4/                    earlier sound version
  v1.0/                    legacy, muted only
templates/                 finished customer emails, one folder per brand
  aeromexico/  blizzard/  frame/  jpmorgan/  kennards/  thatconceptstore/
scripts/
  check-templates.sh       catches unfilled placeholders and leftover assets
CHANGELOG.md               what changed between snippet versions
```

## Build a new customer email

1. **Pick a version.** Use the current one, [`snippets/v2.0/`](snippets/v2.0/), unless the customer needs an older one.
2. **Copy the snippet.** Paste the contents of `snippet.html` into the customer's email where the video goes, leaving out its first line (the usage comment).
3. **Fill in the placeholders** from the [table below](#placeholders). Use find-and-replace so every copy of each one changes.
4. **Run the check:** `bash scripts/check-templates.sh path/to/email.html`
5. **Test it.** Run your email and that version's `control-email.html` through Litmus. If the control looks right and yours doesn't, the problem is in your email, not the snippet.
6. **Save it** as `templates/<brand>/<brand>.html`, adding `sound` for sound versions (e.g. `framesound.html`). Add a row to the [templates table](#templates) and commit with your work GitHub account.

Moving an existing customer email to a newer snippet? Make a new file next to the old one (like `frame.html` → `framesound.html`) and mark each change with a one-line comment, e.g. `<!-- FRAME: stage sized 675x842 (was 600x336) -->`.

## Placeholders

| Placeholder | What goes there | FRAME example |
|---|---|---|
| `__BASE_URL__` | `https://<host>/xid_v:<video ID>.uid_<recipient ID>`: the customer's Playable host, the video ID, and your ESP's per-recipient ID merge tag | `https://tcdeavv.playable.video/xid_v:6755360955695215.uid_{{${user_id}}}` |
| `__CLICK_URL__` | Where a click on the video lands | `https://frame-store.com/pages/kendall-jenner-for-frame` |
| `__WIDTH__` / `__HEIGHT__` | Video size in px | `675` / `842` |
| `__WIDTH_2X__` / `__WIDTH_3X__` | Width × 2 and × 3, for `srcset` | `1350` / `2025` |
| `__RATIO__` | Height ÷ width × 100, up to 2 decimals (1.0 and 2.0) | `124.74` |
| `__HEIGHT_PLUS_100__` | Height + 100 (1.0 only) | `942` |
| `__ALT__` | Alt text for the video images | `Kendall Jenner for FRAME` |
| `__SOUND_PAGE_URL__` | Page that plays the video with sound, for mail apps that can't (1.4 and 2.0) | a `cdn1.playable.video/prototypes/…` page |
| `__SOUND_FALLBACK_IMG__` | Image shown in place of the sound video when a mail app can't play it (1.4 and 2.0). `__BASE_URL__/video@2x` works if there's nothing custom | `…/video@2x` |

Leave `playable="Y2FyZWVyQHBsYXlhYmxlLnZpZGVv"` as it is. Every snippet uses the same value.

The recipient ID merge tag depends on the ESP. `{{${user_id}}}` is Braze's, and most templates here use it; swap in the sending platform's unique-ID tag.

## How Playable URLs work

Every asset hangs off the base URL (`__BASE_URL__/<asset>`):

| Asset | Used for |
|---|---|
| `lowsrc.jpg` | Low-res still: poster, Outlook image, background while loading |
| `video`, `video@2x`, `video@3x` | Animated image fallback at 1×, 2× and 3× |
| `video.mp4`, `video@2x.mp4`, `video@3x.mp4`, `video.webm` | Muted autoplay video |
| `native.m3u8`, `native.mp4` | Video with sound (1.4 and later) |
| `loading` | Loading spinner (1.0) |
| `click/<destination>` | Tracked click that redirects to `<destination>` |

Demo videos use `demo.playable.video/xid_demo:<id>` instead of a customer host and `xid_v:`.

## Snippet versions

| Version | Status | What it does | Used by |
|---|---|---|---|
| [2.0](snippets/v2.0/) | Current | Sound, plus a responsive stage that keeps the video's shape on phones and an "Outlook? click here for sound" line | jpmorgan, frame (sound) |
| [1.4](snippets/v1.4/) | Superseded | Sound, fixed pixel size | kennards |
| [1.0](snippets/v1.0/) | Legacy | Muted autoplay with a blur-in, no sound | aeromexico, blizzard, frame, thatconceptstore |

Details for each version are in [CHANGELOG.md](CHANGELOG.md).

What each kind of mail app shows with 2.0:

| Mail app | Shows |
|---|---|
| Plays video inline (Apple Mail, iOS Mail) | Muted autoplay video, with a native video on top that plays sound when tapped |
| Supports HTML5 video but not inline autoplay | Animated image under a play control; playing it starts the video with sound |
| No video support | Animated image (or `__SOUND_FALLBACK_IMG__`, depending on how the app handles `<video>`) |
| Outlook for Windows | Still image (`lowsrc.jpg`) linked to the click URL |

Everywhere except Apple Mail and iOS Mail, the "Outlook? click here for sound" line shows under the video.

The control emails use Playable's demo video, which has no sound files (`native.*`) or loading spinner. Their sound layer won't play until they point at a demo video with sound.

## Templates

| Brand | File | Snippet | Size | Notes |
|---|---|---|---|---|
| AeroMexico | [aeromexico.html](templates/aeromexico/aeromexico.html) | 1.0 | 650x278 | Two CTAs, dark navy background, Roboto/Space Grotesk |
| Blizzard (internal) | [blizzardinternal.html](templates/blizzard/blizzardinternal.html) | 1.0 | 600x336 | Stripo export with rollover images. Points at the `vidiense-dev` environment |
| FRAME | [frame.html](templates/frame/frame.html) | 1.0 | 675x842 | Kendall Jenner for FRAME, 675px-wide layout with image and CTA rows |
| FRAME | [framesound.html](templates/frame/framesound.html) | 2.0 | 675x842 | `frame.html` rebuilt on 2.0 with FRAME's assets; `FRAME:` comments mark each change. Sound links use FRAME's click-through until a FRAME sound page exists |
| J.P. Morgan Private Bank | [jpmorgansound.html](templates/jpmorgan/jpmorgansound.html) | 2.0 | 600x336 | Marketo template (`{{my.*}}`, `{{lead.*}}` tokens) with dark-mode classes. A code formatter split some `{{my.mobileAlignment}}` tokens in the `<head>` CSS, so those won't fill in |
| Kennards Hire | [kennardssound.html](templates/kennards/kennardssound.html) | 1.4 | 600x1066 | Four-step editorial layout. **Missing the snippet's `<style>` block**, so its autoplay video never switches on (the check script flags this) |
| THAT Concept Store | [thatconceptstore.html](templates/thatconceptstore/thatconceptstore.html) | 1.0 | 600x336 | Playable demo video. Clicks go straight to YouTube rather than through Playable tracking |

## Versioning

Snippet versions are MAJOR.MINOR:

- **MAJOR** (2.0 → 3.0): the structure changes, such as layers added or removed, a new layout approach, or new placeholders.
- **MINOR** (2.0 → 2.1): fixes and tweaks that keep the same placeholders.

To release a version:

1. Copy the current folder to `snippets/vX.Y/` and make the change in both `snippet.html` and `control-email.html`.
2. Update the `<!-- Version X.Y -->` marker.
3. Add a CHANGELOG entry and update the versions table above.
4. Run the new control email through Litmus.
5. Commit, then tag that commit `snippet-vX.Y` and push the tag with `git push origin snippet-vX.Y`.

Customer templates are a record of what was sent, so don't upgrade them in place. Make a new file instead.

## Before you commit

- Run `bash scripts/check-templates.sh`. It should finish with 0 errors, apart from the known Kennards issue above.
- Commit as your work GitHub account. In a fresh clone, set this repo's commit email to your GitHub noreply address (listed at github.com/settings/emails):
  ```bash
  git config user.email "<id>+<username>@users.noreply.github.com"
  ```
- Keep format-on-save off for these files. The repo's `.vscode/settings.json` does this for VS Code. Code formatters break ESP tokens like `{{my.mobileAlignment}}`.
- If an AI coding assistant helps, turn off its `Co-Authored-By` trailer so it doesn't show up as a repo contributor.
- HTML comments ship with the email. Strip internal notes, like the `FRAME:` comments, before a real send.
