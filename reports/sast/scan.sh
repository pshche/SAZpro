## Скрипт для удобного заканчивания конфигов

#!/bin/bash

PROJECT_DIR="/Users/ps/SAZ/saz-lab/targets/webgoat"
REPORTS_DIR="$HOME/SAZ/saz-lab/reports/sast"
RULES_DIR1="/Users/ps/semgrep-rules"
RULES_DIR2="/Users/ps/.semgrep/my_rules"

RESULT_FORMAT="sarif"   # json, sarif, txt, vim, emacs

# Автоматически выбираем расширение и флаг semgrep
case "$RESULT_FORMAT" in
    json)   EXT="json"; FLAG="--json" ;;
    sarif)  EXT="sarif"; FLAG="--sarif" ;;
    txt)    EXT="txt"; FLAG="" ;;
    vim)    EXT="txt"; FLAG="--vim" ;;
    emacs)  EXT="txt"; FLAG="--emacs" ;;
    *)      EXT="log"; FLAG="" ;;
esac

FULL_RESULT_PATH="$REPORTS_DIR/webgoat_sast_results.$EXT"

echo "🔍 Сканирование webgoat (формат: $RESULT_FORMAT)"
cd "$PROJECT_DIR" || exit 1
mkdir -p "$REPORTS_DIR"

# Сбор конфигов правил
CONFIG_ARGS=""
[ -d "$RULES_DIR1/javascript" ] && CONFIG_ARGS="$CONFIG_ARGS --config $RULES_DIR1/javascript"
[ -d "$RULES_DIR1/typescript" ] && CONFIG_ARGS="$CONFIG_ARGS --config $RULES_DIR1/typescript"
[ -d "$RULES_DIR2/javascript" ] && CONFIG_ARGS="$CONFIG_ARGS --config $RULES_DIR2/javascript"

if [ -z "$CONFIG_ARGS" ]; then
    echo "❌ Нет папок с правилами"
    exit 1
fi

# Запуск semgrep (без слова scan)
if [ -n "$FLAG" ]; then
    semgrep $CONFIG_ARGS $FLAG . > "$FULL_RESULT_PATH"
else
    semgrep $CONFIG_ARGS . > "$FULL_RESULT_PATH"
fi

# Код возврата: 0 (нет находок) или 1 (находки) – успех, остальное – ошибка
if [ $? -le 1 ]; then
    echo "✅ Результат сохранён: $FULL_RESULT_PATH"
    exit 0
else
    echo "⚠️ Ошибка выполнения semgrep"
    exit 1
fi