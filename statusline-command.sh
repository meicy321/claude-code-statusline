#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Claude Code Status Line · Starter Kit #06
# ═══════════════════════════════════════════════════════════════
# Designed by  雷蒙（Raymond Hou）
# Source:      https://github.com/Raymondhou0917/claude-code-resources
# Docs:        https://cc.lifehacker.tw
# Newsletter:  https://raymondhouch.com/
# Threads:     @raymond0917
# License:     CC BY-NC-SA 4.0 · 個人使用自由；禁止商業用途
# ═══════════════════════════════════════════════════════════════
# 想改顯示什麼？下面這幾行 true/false 切換就好。

# ── 顯示開關（把 true 改 false 就能關閉對應欄位） ──
EMOJI_STR="😊🥗"
SHOW_MODEL=true
SHOW_CONTEXT_BAR=true
SHOW_RATE_5H=true
SHOW_RATE_7D=true
SHOW_GIT_BRANCH=true
SHOW_GIT_DIFF=true
SHOW_PROJECT=true
SHOW_LAST_MSG=true   # 顯示「最後一則訊息的時間」（需要 Section E 的 hook 支援）
LAST_MSG_FILE="$HOME/.claude/last-session-msg"

# ── 顏色定義 ──
WH=$'\033[97m'
GR=$'\033[38;2;80;200;81m'
YL=$'\033[38;2;255;235;59m'
OG=$'\033[38;2;255;152;0m'
RD=$'\033[38;2;244;67;54m'
MD=$'\033[38;2;246;184;90m'
DM=$'\033[90m'
RS=$'\033[0m'
SEP="${DM} │ ${RS}"

input=$(cat)

# ── 解析 Claude Code 傳來的 JSON ──
model=$(echo "$input" | jq -r '.model.display_name // ""')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
rl_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl_5h_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rl_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
rl_7d_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# ══════ LINE 1 ══════
L1=""
[ -n "$EMOJI_STR" ] && L1="${EMOJI_STR} "

# 模型名稱
if $SHOW_MODEL && [ -n "$model" ]; then
    L1="${L1}${SEP}${MD}${model}${RS}"
fi

# Context 進度條（閾值版：根據使用率整條變色）
if $SHOW_CONTEXT_BAR && [ -n "$remaining" ]; then
    pct=$(printf '%.0f' "$remaining")
    used=$((100 - pct))
    BAR_W=12
    filled=$(( used * BAR_W / 100 ))

    # 根據使用率選擇顏色
    if   [ "$used" -ge 90 ]; then BAR_COLOR=$RD; pc=$RD
    elif [ "$used" -ge 70 ]; then BAR_COLOR=$OG; pc=$OG
    elif [ "$used" -ge 50 ]; then BAR_COLOR=$YL; pc=$YL
    else                          BAR_COLOR=$GR; pc=$WH
    fi

    bar=""
    for ((n=0; n<BAR_W; n++)); do
        if [ $n -lt $filled ]; then
            bar="${bar}${BAR_COLOR}█"
        else
            bar="${bar}${DM}░"
        fi
    done
    bar="${bar}${RS}"
    L1="${L1}${SEP}${bar} ${pc}${used}%${RS}"
fi

# 倒數計時
_ttl() {
    local s=$(( $1 - $(date +%s) ))
    [ "$s" -le 0 ] && echo "0m" && return
    local d=$((s/86400)) h=$(((s%86400)/3600)) m=$(((s%3600)/60))
    [ $d -gt 0 ] && echo "${d}D${h}H" && return
    [ $h -gt 0 ] && echo "${h}H${m}m" && return
    echo "${m}m"
}

# 已使用額度顏色（used% 越高顏色越紅）
_rl_used_color() {
    local used=$1
    if   [ "$used" -ge 75 ]; then echo "$RD"
    elif [ "$used" -ge 50 ]; then echo "$OG"
    elif [ "$used" -ge 25 ]; then echo "$YL"
    else                          echo "$GR"
    fi
}

# 5h rate limit
if $SHOW_RATE_5H && [ -n "$rl_5h" ]; then
    used=$(printf '%.0f' "$rl_5h")
    t=""; [ -n "$rl_5h_reset" ] && t=$(_ttl "$rl_5h_reset")
    c=$(_rl_used_color "$used")
    L1="${L1}${SEP}${WH}${t} ${c}${used}% used${RS}"
fi

# 7d rate limit
if $SHOW_RATE_7D && [ -n "$rl_7d" ]; then
    used=$(printf '%.0f' "$rl_7d")
    t=""; [ -n "$rl_7d_reset" ] && t=$(_ttl "$rl_7d_reset")
    c=$(_rl_used_color "$used")
    L1="${L1}${SEP}${WH}${t} ${c}${used}% used${RS}"
fi

# 第一行開頭的 SEP 去掉（如果第一個欄位前面有 SEP）
L1=$(echo "$L1" | sed -E 's/^([^│]*) │ /\1 /')

# ══════ LINE 2 ══════
L2=""
if git_top=$(git rev-parse --show-toplevel 2>/dev/null); then
    if $SHOW_GIT_BRANCH; then
        br=$(git branch --show-current 2>/dev/null)
        if [ -n "$br" ]; then
            dirty=""
            git diff-index --quiet HEAD -- 2>/dev/null || dirty="*"
            [ -z "$dirty" ] && [ -n "$(git ls-files --others --exclude-standard 2>/dev/null | head -1)" ] && dirty="*"
            L2="${WH}${br}${dirty}${RS}"
        fi
    fi

    if $SHOW_GIT_DIFF; then
        stat=$(git diff --shortstat HEAD 2>/dev/null)
        ins=$(echo "$stat" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+')
        del=$(echo "$stat" | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+')
        if [ -n "$ins" ] || [ -n "$del" ]; then
            ds=""
            [ -n "$ins" ] && ds="${GR}+${ins}${RS}"
            [ -n "$ins" ] && [ -n "$del" ] && ds="${ds}${DM}/${RS}"
            [ -n "$del" ] && ds="${ds}${RD}-${del}${RS}"
            [ -n "$L2" ] && L2="${L2}${SEP}${ds}" || L2="${ds}"
        fi
    fi

    if $SHOW_PROJECT; then
        pname=$(basename "$git_top")
        if [ -n "$pname" ]; then
            [ -n "$L2" ] && L2="${L2}${SEP}${WH}${pname}${RS}" || L2="${WH}${pname}${RS}"
        fi
    fi
fi

# 最後訊息時間（從 UserPromptSubmit hook 寫入的檔案讀取）
# 這不是「現在時間」，而是「上次你跟這個 session 對話的時間戳」
# 舊的 tmux session 撿回來時，能一眼看到上次聊到哪
if $SHOW_LAST_MSG && [ -f "$LAST_MSG_FILE" ]; then
    last_msg=$(cat "$LAST_MSG_FILE" 2>/dev/null)
    if [ -n "$last_msg" ]; then
        [ -n "$L2" ] && L2="${L2}${SEP}${DM}📝 ${last_msg}${RS}" || L2="${DM}📝 ${last_msg}${RS}"
    fi
fi

# Session 持續時間
SESSION_START_FILE="$HOME/.claude/session-start-time"
if [ -f "$SESSION_START_FILE" ]; then
    start_ts=$(cat "$SESSION_START_FILE" 2>/dev/null)
    if [ -n "$start_ts" ]; then
        now_ts=$(date +%s)
        duration=$((now_ts - start_ts))
        hours=$((duration / 3600))
        minutes=$(((duration % 3600) / 60))

        if [ $hours -gt 0 ]; then
            duration_str="${hours}h${minutes}m"
        else
            duration_str="${minutes}m"
        fi

        [ -n "$L2" ] && L2="${L2}${SEP}${DM}🕐 session:${RS}${WH}${duration_str}${RS}" || L2="${DM}🕐 session:${RS}${WH}${duration_str}${RS}"
    fi
fi

# ══════ 輸出 ══════
printf '%s\n' "$L1"
[ -n "$L2" ] && printf '%s\n' "$L2"
