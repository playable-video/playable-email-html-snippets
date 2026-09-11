# Snippet changelog

Every version of the Playable Video email snippet that appears in this repo, newest first.

These notes were reconstructed in September 2026 by comparing the templates, so they describe what the code does rather than an official release history. Versions 1.1 to 1.3 never made it into the repo. Versions follow MAJOR.MINOR; see [Versioning](README.md#versioning) for when to bump which.

## 2.0 (current)

Control: [`snippets/v2.0/`](snippets/v2.0/). Used by `templates/jpmorgan/jpmorgansound.html` and `templates/frame/framesound.html`.

- **Responsive stage.** Below the video's width the stage switches to `width: 100%` with a percentage `padding-bottom` (height ÷ width), so the video keeps its shape when a mail app zooms the message to fit a phone. The snippet's own notes say an earlier approach used viewport units, which squashed the video in that situation.
- `aspect-ratio` on the video and fallback image, for clients that lay out `<video>` before its metadata loads.
- The show/hide `<style>` ships inside the snippet (`data-provider="playable.video"`), so it can't get lost when the snippet is pasted into a new email.
- `.-playable-video` is hidden without a `[playable]` prefix. That also hides the "Outlook? click here for sound" line, which sits outside the Playable container.
- The Outlook image is now linked to the Playable click-through.
- The sound layer sits in a zero-height wrapper like the other layers, and its transparent poster has an explicit width and height.
- The sound layer's no-video fallback is a single linked image instead of 1.4's centring table.

## 1.4 (sound)

Control: [`snippets/v1.4/`](snippets/v1.4/). Used by `templates/kennards/kennardssound.html`.

- Replaced the legacy structure with zero-height layers stacked in a fixed-size stage:
  1. Outlook image (`[if mso]`)
  2. Muted autoplay video
  3. Animated fallback image (`.-playable-video`)
  4. Native video with controls and sound (`native.m3u8` / `native.mp4`, `[if (!mso)&(!IE)]`)
- Autoplay sources trimmed to `video@2x.mp4` and `video.mp4`.
- "Apple Mail baseline-gap fix": judging by the markup, `font-size: 0; line-height: 0` on the stage and `vertical-align: top` on the videos, which remove the gap Apple Mail leaves under inline media.
- Kennards links every layer to its sound landing page. The control uses the Playable click-through for the autoplay and fallback layers, like 2.0.
- `kennardssound.html` shipped without the snippet's `<style>` block. The control's CSS is reconstructed from 2.0, with the `[playable]` prefix that 2.0's notes say the earlier rule had.

## 1.0 (legacy, muted only)

Control: [`snippets/v1.0/`](snippets/v1.0/). Used by `aeromexico`, `thatconceptstore`, `blizzard` and `frame` (the templates carry no version marker).

The original snippet: muted autoplay, no sound.

- `@media (-webkit-video-playable-inline)` shows the `<video>` and hides the animated `<img>` next to it.
- Low-res still as a background with a loading spinner on top, then a blur-in `playable-reveal` animation.
- Four sources: `video@3x.mp4`, `video@2x.mp4`, `video.webm`, `video.mp4`.
- The video box is 100px taller than the slot and shifted up 50px (`top: -50px`, `object-position: 50% 50px`) inside a `padding-bottom` ratio box.
- Outlook gets a centring table and an `[if mso 15]` height fix.
