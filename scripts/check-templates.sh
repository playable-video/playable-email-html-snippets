#!/usr/bin/env bash
# Sanity-checks Playable email templates before they're committed or sent.
#
#   bash scripts/check-templates.sh                     # every .html under templates/ and snippets/
#   bash scripts/check-templates.sh path/to/email.html  # just the files you name
#
# Errors (exit code 1):
#   - unfilled __PLACEHOLDERS__ (allowed only in snippets/*/snippet.html)
#   - more than one Playable video ID or host in one email, usually assets left over
#     from the template it was copied from
#   - no @media (-webkit-video-playable-inline) rule, so the autoplay video never shows
#   - unbalanced <div> or <video> tags inside the Playable snippet
# Warnings: no snippet, no version marker, a sound snippet missing a native.* source.
#
# Plain bash with grep/sed/awk, so it runs in Git Bash on Windows and on macOS.

files=()
if [ "$#" -gt 0 ]; then
    files=("$@")
else
    cd "$(dirname "$0")/.." || exit 2
    while IFS= read -r f; do files+=("$f"); done < <(find templates snippets -name '*.html' 2>/dev/null | sort)
fi
if [ "${#files[@]}" -eq 0 ]; then
    echo "No .html files found under templates/ or snippets/."
    exit 2
fi

errors=0
warnings=0
level=""
issues=""

err()  { issues="${issues}         error:   $1"$'\n'; level="ERROR"; errors=$((errors + 1)); }
warn() { issues="${issues}         warning: $1"$'\n'; [ "$level" = "ok" ] && level="warn"; warnings=$((warnings + 1)); }

for f in "${files[@]}"; do
    level="ok"
    issues=""
    hosts=""

    if [ ! -f "$f" ]; then
        printf '%-5s  %s\n         error:   file not found\n' "ERROR" "$f"
        errors=$((errors + 1))
        continue
    fi

    body=$(tr -d '\r' < "$f")
    name=$(basename "$f")

    # Snippet version: the <!-- Version X.Y --> marker, or 1.0 for the unlabeled legacy snippet.
    version=$(sed -n 's/.*<!-- *Version \([0-9][0-9.]*\).*/\1/p' <<<"$body" | head -n 1)
    if [ -z "$version" ] && grep -q 'playable-reveal' <<<"$body"; then version="1.0"; fi

    if ! grep -q 'Playable Video, Patent' <<<"$body"; then
        warn "no Playable snippet found"
    else
        [ -n "$version" ] || warn 'no <!-- Version X.Y --> marker'

        hosts=$(grep -oE 'https?://[^/"'"'"' ]+/xid_' <<<"$body" | sed -e 's#^https*://##' -e 's#/xid_$##' | sort -u)

        if [ "$name" != "snippet.html" ]; then
            placeholders=$(grep -oE '__[A-Z0-9_]+__' <<<"$body" | sort -u | tr '\n' ' ')
            [ -z "$placeholders" ] || err "unfilled placeholders: $placeholders"

            ids=$(grep -oE 'xid_[a-z]+:[0-9]+' <<<"$body" | sort -u)
            n_ids=$(grep -c . <<<"$ids")
            n_hosts=$(grep -c . <<<"$hosts")
            [ "$n_ids" -le 1 ] || err "more than one Playable video ID: $(echo $ids)"
            [ "$n_ids" -ge 1 ] || warn "no Playable video ID (xid_...) found"
            [ "$n_hosts" -le 1 ] || err "more than one Playable host: $(echo $hosts)"
        fi

        grep -qE '@media[[:space:]]*\(-webkit-video-playable-inline\)' <<<"$body" \
            || err "no @media (-webkit-video-playable-inline) rule, so the autoplay video can never switch on"

        if grep -qE 'native\.(m3u8|mp4)' <<<"$body" || awk -v v="$version" 'BEGIN { exit !(v + 0 >= 1.4) }'; then
            grep -q 'native\.m3u8' <<<"$body" || warn "sound snippet has no native.m3u8 source"
            grep -q 'native\.mp4' <<<"$body" || warn "sound snippet has no native.mp4 source"
        fi

        region=$(awk '/Playable Video, Patent/ { p = 1 } p { print } /end Playable Video/ { p = 0 }' <<<"$body")
        d_open=$(grep -oE '<div([[:space:]>]|$)' <<<"$region" | wc -l | tr -d ' ')
        d_close=$(grep -oE '</div>' <<<"$region" | wc -l | tr -d ' ')
        v_open=$(grep -oE '<video([[:space:]]|$)' <<<"$region" | wc -l | tr -d ' ')
        v_close=$(grep -oE '</video>' <<<"$region" | wc -l | tr -d ' ')
        [ "$d_open" -eq "$d_close" ] || err "snippet has $d_open <div> but $d_close </div>"
        [ "$v_open" -eq "$v_close" ] || err "snippet has $v_open <video> but $v_close </video>"
    fi

    printf '%-5s  %-50s %-6s %s\n' "$level" "$f" "${version:+v$version}" "$(echo $hosts)"
    [ -z "$issues" ] || printf '%s' "$issues"
done

echo
echo "${#files[@]} file(s) checked: $errors error(s), $warnings warning(s)."
[ "$errors" -eq 0 ]
