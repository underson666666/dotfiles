#!/bin/sh
#
# Antigravity CLI custom status line
#
# Requires: jq
#
# Antigravity passes a JSON payload to stdin every time the agent state changes.
#

JSON="$(cat)"

# ANSI colors
RESET="$(printf '\033[0m')"
DIM="$(printf '\033[2m')"
CYAN="$(printf '\033[36m')"
GREEN="$(printf '\033[32m')"
YELLOW="$(printf '\033[33m')"
MAGENTA="$(printf '\033[35m')"
BLUE="$(printf '\033[34m')"
RED="$(printf '\033[31m')"

# ---- Model / effort ---------------------------------------------------------

MODEL_DISPLAY="$(printf '%s' "$JSON" | jq -r '.model.display_name // .model.id // "unknown"')"

# Status-line JSON does not currently expose effort as a separate field.
# For models whose display name ends in "(Low)", "(Medium)", or "(High)",
# extract that suffix as the effort level.
EFFORT="$(printf '%s' "$MODEL_DISPLAY" | sed -n 's/.*(\(Low\|Medium\|High\))$/\1/p')"

if [ -n "$EFFORT" ]; then
    MODEL_NAME="$(printf '%s' "$MODEL_DISPLAY" | sed 's/ (\(Low\|Medium\|High\))$//')"
else
    MODEL_NAME="$MODEL_DISPLAY"
    EFFORT="-"
fi

# ---- Context window --------------------------------------------------------

# Antigravity's used_percentage already grows from 0 -> 100 as context is used.
CONTEXT_USED="$(printf '%s' "$JSON" | jq -r '
    if .context_window.used_percentage == null
    then 0
    else .context_window.used_percentage
    end
')"

CONTEXT_USED_FMT="$(awk -v n="$CONTEXT_USED" 'BEGIN { printf "%.1f", n }')"

# Dynamic coloring for context window (used %):
# < 60%: green, 60-80%: yellow, >= 80%: red
CONTEXT_COLOR="$(awk -v n="$CONTEXT_USED" -v r="$RED" -v y="$YELLOW" -v g="$GREEN" 'BEGIN {
    if (n >= 80.0) printf "%s", r;
    else if (n >= 60.0) printf "%s", y;
    else printf "%s", g;
}')"

# ---- Execution mode / tool permissions / background tasks ------------------

CYCLE_MODE="$(printf '%s' "$JSON" | jq -r '.cycle_mode // "unknown"')"
TOOL_PERM="$(jq -r '.toolPermission // "ask"' ~/.gemini/antigravity-cli/settings.json 2>/dev/null)"

if [ "$TOOL_PERM" = "always-proceed" ]; then
    PERM_LABEL="auto-approve"
    PERM_COLOR="$GREEN"
else
    PERM_LABEL="${TOOL_PERM:-ask}"
    PERM_COLOR="$YELLOW"
fi

# サブエージェントの数を取得
SUBAGENTS_COUNT=$(printf '%s' "$JSON" | jq -r '[.subagents[]? | select(.status == "running")] | length // 0')


# ---- Quotas / rate limits --------------------------------------------------

# quota is an object whose keys are quota bucket names.
#
# remaining_fraction:
#   1.0 = 100% remaining
#   0.0 =   0% remaining
QUOTAS="$(printf '%s' "$JSON" | jq -r '
    (.quota // {})
    | to_entries
    | map(
        .display_key = (.key | sub("^gemini-"; ""))
        | .order = (
            if .key == "gemini-5h" or .key == "5h" then 1
            elif .key == "gemini-weekly" or .key == "weekly" then 2
            elif .key == "3p-5h" then 3
            elif .key == "3p-weekly" then 4
            else 99
            end
          )
      )
    | sort_by(.order, .display_key)
    | .[]
    | [
        .display_key,
        (((.value.remaining_fraction // 0) * 100) | tostring)
      ]
    | @tsv
' | while IFS="$(printf '\t')" read -r NAME VALUE; do
    VALUE_FMT="$(awk -v n="$VALUE" 'BEGIN { printf "%.1f", n }')"
    # Dynamic coloring for quota (remaining %):
    # >= 50%: green, 20-50%: yellow, < 20%: red
    COLOR="$(awk -v n="$VALUE" -v r="$RED" -v y="$YELLOW" -v g="$GREEN" 'BEGIN {
        if (n < 20.0) printf "%s", r;
        else if (n < 50.0) printf "%s", y;
        else printf "%s", g;
    }')"
    printf '%s%s=%s%%%s ' "$COLOR" "$NAME" "$VALUE_FMT" "$RESET"
done)"
# Remove trailing spaces.
QUOTAS="$(printf '%s' "$QUOTAS" | sed 's/[[:space:]]*$//')"

if [ -z "$QUOTAS" ]; then
    QUOTAS="quota=n/a"
fi

# ---- Render ---------------------------------------------------------------

# Example:
# Gemini 3.7 Flash(Medium) | 5h=99.9% weekly=100.0% 3p-5h=100.0% 3p-weekly=100.0% | Ctx:0.0% | unknown | tasks:0

printf "${CYAN}%s(%s)${RESET}" "$MODEL_NAME" "$EFFORT"
printf " ${DIM}|${RESET} %s" "$QUOTAS"
printf " ${DIM}|${RESET} ${CONTEXT_COLOR}Ctx:%s%%${RESET}\n" "$CONTEXT_USED_FMT"
printf "${BLUE}%s${RESET} ${DIM}(${RESET}${PERM_COLOR}%s${RESET}${DIM})${RESET}" "$CYCLE_MODE" "$PERM_LABEL"
printf " ${DIM}|${RESET} agents:%s\n" "$SUBAGENTS_COUNT"
