#!/bin/bash
set -eo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO] $1${NC}"; }
log_success() { echo -e "${GREEN}[SUCCÈS] $1${NC}"; }
log_warn() { echo -e "${YELLOW}[ATTENTION] $1${NC}"; }
log_error() { echo -e "${RED}[ERREUR] $1${NC}"; }

assert_git_repo() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { log_error "Pas un dépôt Git valide."; exit 1; }
}

get_current_branch() { git rev-parse --abbrev-ref HEAD; }

# Extraction automatique du code JIRA depuis le nom de la branche (ex: feature/PROJ-123-login -> PROJ-123)
extract_jira_ticket() {
    local branch=$(get_current_branch)
    if [[ "$branch" =~ [A-Z]+-[0-9]+ ]]; then
        echo "${BASH_REMATCH[0]}"
    else
        echo ""
    fi
}

ensure_rebase_config() { git config --local pull.rebase true; }

start_new_task() {
    ensure_rebase_config
    git add :/
    git diff-index --quiet HEAD -- || git commit -m "wip: sauvegarde automatique avant switch"

    log_info "Mise à jour de la branche develop..."
    git checkout develop && git pull origin develop

    echo -e "${YELLOW}👉 Entrez le numéro de ticket Jira (ex: PROJ-123) :${NC}"
    read -r jira_id
    echo -e "${YELLOW}👉 Entrez la description de la tâche (ex: add login page) :${NC}"
    read -r task_desc

    jira_upper=$(echo "$jira_id" | tr '[:lower:]' '[:upper:]')
    clean_desc=$(echo "$task_desc" | sed 's/ /-/g' | tr '[:upper:]' '[:lower:]')
    local branch_name="feature/${jira_upper}-$clean_desc"

    git checkout -b "$branch_name"
    log_success "Branche créée : $branch_name"
}

save_work() {
    local branch=$(get_current_branch)
    [ "$branch" == "develop" ] || [ "$branch" == "main" ] && { log_error "Interdiction de committer sur $branch"; return 1; }

    log_info "Statut des fichiers :"
    git status -s

    local jira_ticket=$(extract_jira_ticket)
    echo -e "${YELLOW}👉 Entrez votre message de commit (ex: add style to button) :${NC}"
    read -r commit_msg

    # Formatage entreprise : [JIRA-XXX] feat: description
    local final_msg="feat: $commit_msg"
    if [ -n "$jira_ticket" ]; then
        final_msg="[$jira_ticket] feat: $commit_msg"
    fi

    git add :/ && git commit -m "$final_msg"
    log_success "Commit enregistré : $final_msg"
}

sync_and_rebase() {
    ensure_rebase_config
    log_info "Lancement du Pull Rebase..."
    if ! git pull origin develop; then
        log_error "CONFLIT DÉTECTÉ. Le script s'arrête."
        log_warn "Résolution manuelle requise :"
        log_warn "1. Corrigez les fichiers."
        log_warn "2. Tapez : git add <fichiers>"
        log_warn "3. Tapez : git rebase --continue"
        exit 1
    fi
    log_success "Historique synchronisé et rectiligne !"
}

push_work() {
    local current=$(get_current_branch)
    [ "$current" == "develop" ] || [ "$current" == "main" ] && { log_error "Interdiction de push sur $current"; return 1; }

    echo -e "${PURPLE}Type de Push :${NC}\n1) Premier Push\n2) Mise à jour après Rebase / Conflit GitLab"
    read -r push_choice
    if [ "$push_choice" == "1" ]; then
        git push origin "$current"
    elif [ "$push_choice" == "2" ]; then
        git push origin "$current" --force-with-lease
    else
        log_error "Choix invalide."
    fi
}

assert_git_repo
clear
echo -e "${PURPLE}=== CONFIGURATION ENTERPRISE APP WORKFLOW ===${NC}"
echo -e "Branche : ${YELLOW}$(get_current_branch)${NC}\n"
echo -e "1) Démarrer une tâche\n2) Enregistrer (Commit + Jira)\n3) Synchroniser (Pull Rebase)\n4) Envoyer sur GitLab\n5) Quitter"
read -r main_choice
case $main_choice in
    1) start_new_task ;; 2) save_work ;; 3) sync_and_rebase ;; 4) push_work ;; 5) exit 0 ;; *) log_error "Invalide"; exit 1 ;;
esac
