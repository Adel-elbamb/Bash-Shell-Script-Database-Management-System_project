#!/bin/bash

DB_ROOT="$(pwd)/databases"
LOG_FILE="$(pwd)/logs/dbms.log"
mkdir -p "$DB_ROOT" "$(dirname "$LOG_FILE")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

type_text() {
    text="$1"
    delay="${2:-0.01}"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo
}

print_header() {
    clear
    echo -e "${CYAN}${BOLD}╔═════════════════════════════════════════════════════════════╗"
    echo -ne "${CYAN}${BOLD}║ "; type_text "🚀 Welcome to the Ultimate Bash DBMS System!" 0.005
    echo -e "${CYAN}${BOLD}╚═════════════════════════════════════════════════════════════╝${NC}"
}

progress_bar() {
    echo -n "${YELLOW}⏳ Please wait: "
    for i in {1..20}; do echo -n "▮"; sleep 0.03; done
    echo -e " ${GREEN}Done!${NC}"
}

show_alert() {
    msg="$1"; color="$2"
    echo -e "${color}┌────────────────────────────────────────────┐"
    echo -e "│ ${msg}"
    echo -e "└────────────────────────────────────────────┘${NC}"
}

validate_db_name() {
    [[ $1 =~ ^[a-zA-Z][a-zA-Z0-9_]{2,19}$ ]]
}

create_database() {
    read -p "📦 Enter Database Name: " db_name
    if ! validate_db_name "$db_name"; then
        echo -en "\a"
        show_alert "❌ Invalid name. Use 3–20 letters, numbers, _ (start with letter)." "$RED"
        return
    fi

    if [[ -d "$DB_ROOT/$db_name" ]]; then
        show_alert "⚠️ Database '$db_name' already exists." "$RED"
        return
    fi

    mkdir "$DB_ROOT/$db_name"
    progress_bar
    show_alert "✅ Database '$db_name' created successfully." "$GREEN"
    echo "[+] Created DB: $db_name" >> "$LOG_FILE"
}

list_databases() {
    echo -e "${YELLOW}📚 Databases:${NC}"
    if [ "$(ls -A "$DB_ROOT")" ]; then
        ls "$DB_ROOT" | nl
    else
        echo -e "${RED}🚫 No databases found.${NC}"
    fi
}

connect_database() {
    read -p "🔌 Enter Database Name: " db_name
    if [[ -d "$DB_ROOT/$db_name" ]]; then
        show_alert "✅ Connected to '$db_name'." "$GREEN"
        progress_bar
        bash bin/connect_menu.sh "$DB_ROOT/$db_name"
    else
        echo -en "\a"
        show_alert "❌ Database not found." "$RED"
    fi
}

drop_database() {
    read -p "🗑️ Enter Database Name to Delete: " db_name
    if [[ -d "$DB_ROOT/$db_name" ]]; then
        read -p "⚠️ Are you sure? This will delete all tables. [y/N]: " confirm
        shopt -s nocasematch
        if [[ "$confirm" == "y" ]]; then
            rm -r "$DB_ROOT/$db_name"
            progress_bar
            show_alert "🗑️ '$db_name' deleted." "$GREEN"
            echo "[-] Dropped DB: $db_name" >> "$LOG_FILE"
        else
            show_alert "❎ Deletion cancelled." "$YELLOW"
        fi
    else
        show_alert "❌ Database '$db_name' not found." "$RED"
    fi
}

while true; do
    print_header
    echo -e "${YELLOW}${BOLD}📋 Main Menu:${NC}"
    echo -e "${CYAN}[1]${NC}  📁 Create Database       ${DIM}- Add new DB${NC}"
    echo -e "${CYAN}[2]${NC}  📂 List Databases        ${DIM}- View all DBs${NC}"
    echo -e "${CYAN}[3]${NC}  🔌 Connect To Database   ${DIM}- Open DB tables${NC}"
    echo -e "${CYAN}[4]${NC}  🗑️  Drop Database          ${DIM}- Delete DB${NC}"
    echo -e "${CYAN}[5]${NC}  🚪 Exit                  ${DIM}- Quit app${NC}"
    echo "────────────────────────────────────────────────────────────"

    read -p "🎯 Choose [1-5]: " choice

    case "$choice" in
        1) create_database ;;
        2) list_databases ;;
        3) connect_database ;;
        4) drop_database ;;
        5) show_alert "👋 Exiting Bash DBMS. Goodbye!" "$BLUE"; break ;;
        *) echo -en "\a"; show_alert "❌ Invalid option. Try again!" "$RED" ;;
    esac

    echo -e "\n${DIM}🔁 Press Enter to return to menu...${NC}"
    read
done
