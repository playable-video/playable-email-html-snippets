# Snippet changelog

Every version of the Playable Video email snippet that appears in this repo, newest first.

The notes for 2.0 and earlier were reconstructed in September 2026 by comparing the templates, so they describe what the code does rather than an official release history. Versions 1.1 to 1.3 never made it into the repo. Versions follow MAJOR.MINOR; see [Versioning](README.md#versioning) for when to bump which.

## 2.1 (current)

Control: [`snippets/v2.1/`](snippets/v2.1/). Not used by any template yet. The changes below come from October 2026 Braze test sends of `templates/jpmorgan/jpmorgansummerreadingsound.html`, a 2.0 build that carries them (see its `JPM:` comments), checked in Apple Mail, Gmail and Outlook. That email later moved its links and sound line to the client's choices (see the README's templates table); 2.1 keeps the defaults below.

Fixes 2.0 showing nothing in Outlook on iPhone and iPad. That app passes the inline-video test (`@media (-webkit-video-playable-inline)`) but won't play video, and it drops the `playable` attribute or attribute selectors. So 2.0's unprefixed hide rule hid the animated image there, while the video stayed hidden too.

- The fallback hide rule is `*[playable] .-playable-video` again, the form Playable's own platform snippet uses. Apps that drop the attribute or attribute selectors now skip both rules in the inline-video block and keep the animated image. The prefix has no quoted value: a quoted attribute selector stopped working after a Braze send, so keep CSS selectors free of quotes.
- Playable's platform rule for Outlook, `<style>.-pl-vws-\0{ display: none !important; }</style>`, follows the snippet's style block in its own element, exactly as the platform ships it. `-pl-vws-` is the sound layer's class.
- The sound layer is hidden by a plain `.-pl-vws-` rule in the inline-video block and brought back by `*[playable] .-pl-vws-`. Outlook on iPhone and iPad applies only the plain rule, so the sound layer, a video it won't play, no longer sits on top of the animated image and swallows the tap. Apple Mail applies both and keeps tap-to-play inline. The platform's `\0` rule alone didn't hide the layer there.
- The sound line reads "Click here to watch with sound" (2.0: "Outlook? click here for sound"). It sits in `<!--[if mso]>` and no longer has the `-playable-video` class, so only Outlook for Windows shows it; every other app gives sound from the video itself or the sound page. Hiding this line was 2.0's only reason to drop the prefix.
- No HTML in CSS comments: the `aspect-ratio` comment says "a video" instead of `<video>`. Email on Acid reports that Outlook.com can blank an email over HTML inside a `<style>` block.
- The animated image links to `__SOUND_PAGE_URL__` instead of `__BASE_URL__/click/__CLICK_URL__`, so tapping it in Outlook on iPhone and iPad, or in an app without video, opens the sound page. Those taps no longer go through Playable's tracked click. The autoplay video and the Outlook for Windows image still link to `__BASE_URL__/click/__CLICK_URL__`.

## 2.0 (responsive stage)

Control: [`snippets/v2.0/`](snippets/v2.0/). Used by `templates/jpmorgan/jpmorgansound.html`, `templates/jpmorgan/jpmorgansummerreadingsound.html` and `templates/frame/framesound.html`.

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
