#!/usr/bin/env bash
# new-market.sh —— 铺一个选品深挖项目:<market-scout-选品调研>/yyyymmdd-<赛道>-作战地图/
# 用法: bash new-market.sh "<赛道名>" ["<market-scout-选品调研目录>"]
#   不给第二参数 → 默认在当前目录下的 market-scout-选品调研/
set -euo pipefail

NICHE="${1:-}"
BASE="${2:-}"
[ -z "$NICHE" ] && { echo "用法: new-market.sh \"<赛道名>\" [\"<market-scout-选品调研目录>\"]"; exit 1; }

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TPL="$SKILL_DIR/templates"

if [ -n "$BASE" ]; then ROOT="$BASE"; else ROOT="$(pwd)/market-scout-选品调研"; fi
DATE="$(date +%Y%m%d)"
SLUG="$(printf '%s' "$NICHE" | tr ' /' '--')"
DIR="$ROOT/${DATE}-${SLUG}-作战地图"

[ -d "$DIR" ] && { echo "已存在: $DIR (换个名或删了重来)"; exit 1; }
mkdir -p "$DIR/原始数据" "$DIR/评论样本"

for f in brief.md 作战地图.md; do
  sed -e "s|{{NICHE}}|$NICHE|g" -e "s|{{DATE}}|$DATE|g" -e "s|{{TIER}}|T1|g" "$TPL/$f" > "$DIR/$f"
done

# 品类层选品雷达池:没有就从模板铺一个
if [ ! -f "$ROOT/选品雷达.md" ]; then
  sed -e "s|{{RANGE}}|待定|g" -e "s|{{DATE}}|$DATE|g" -e "s|{{TIER}}|T1|g" "$TPL/选品雷达.md" > "$ROOT/选品雷达.md"
fi

echo "✅ 铺好: $DIR"
echo "   ├─ brief.md        ← 先填 P0 范围/目标/数据源"
echo "   ├─ 作战地图.md      ← P1–P5 产出(8 块作战地图)"
echo "   ├─ 原始数据/  评论样本/"
echo "   └─ 选品雷达池: $ROOT/选品雷达.md"
