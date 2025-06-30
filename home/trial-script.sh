#!/usr/bin/env bash
# trial-backend - Backend for trial directory creator
# Returns the selected directory path to stdout

set -euo pipefail

# Configuration
readonly TRIAL_DIR="$HOME/src/trials"

# Colors for output (to stderr)
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Function to generate random words
words() {
  local num=${1:-2}
  local words
  
  # Try multiple word sources in order of preference
  local word_sources=(
    "/usr/share/dict/words"
    "/System/Library/Spelling/en_US/Contents/Resources/en_US.dict"
    "/usr/dict/words"
  )
  
  local dict_file=""
  for source in "${word_sources[@]}"; do
    if [[ -f "$source" && -r "$source" ]]; then
      dict_file="$source"
      break
    fi
  done
  
  if [[ -z "$dict_file" ]]; then
    # Fallback to a simple word generator
    local fallback_words=("alpha" "beta" "gamma" "delta" "epsilon" "zeta" "eta" "theta" "iota" "kappa" "lambda" "mu" "nu" "xi" "omicron" "pi" "rho" "sigma" "tau" "upsilon" "phi" "chi" "psi" "omega" "quick" "brown" "fox" "jumps" "over" "lazy" "dog" "hello" "world" "test" "demo" "sample" "project" "trial" "code" "hack" "build" "script" "tool" "app")
    local selected_words=()
    for ((i=0; i<num; i++)); do
      selected_words+=("${fallback_words[$((RANDOM % ${#fallback_words[@]}))]}")
    done
    printf "%s" "$(IFS=-; echo "${selected_words[*]}")"
  else
    words=$(cat "$dict_file" | shuf -n "$num" | tr '\n' '-' | tr '[:upper:]' '[:lower:]')
    echo "${words%-}" # Remove trailing hyphen
  fi
}

# Main trial function
main() {
  local PROJECT_NAME=${*:-$(words 2)}
  local DATE_PREFIX=$(date +%Y-%m-%d)
  local DEFAULT_NAME="${DATE_PREFIX}-${PROJECT_NAME}"
  local selected_trial
  local existing_trials
  local FULL_PATH

  # Create trial directory if it doesn't exist
  mkdir -p "$TRIAL_DIR"

  # Find existing trial directories (excluding the parent directory itself)
  existing_trials=$(find "$TRIAL_DIR" -maxdepth 1 -type d -not -path "$TRIAL_DIR" 2>/dev/null | sort -r || true)

  # Use fzf to select or create new trial
  if [[ -n "$existing_trials" ]]; then
    # Show existing trials and allow creating new one
    selected_trial=$(printf "%s\n%s" "$DEFAULT_NAME" "$(basename -a $existing_trials)" |
      fzf --prompt="Select existing trial or create new: " \
        --header="↑↓ to navigate, Enter to select, Ctrl-C to cancel" \
        --height=15 \
        --reverse \
        --query="$DEFAULT_NAME" || true)
  else
    # No existing trials, just use the default name
    selected_trial="$DEFAULT_NAME"
  fi

  # Handle cancellation
  if [[ -z "$selected_trial" ]]; then
    echo -e "${YELLOW}Cancelled.${NC}" >&2
    return 1
  fi

  # Create the selected directory
  FULL_PATH="$TRIAL_DIR/$selected_trial"
  mkdir -p "$FULL_PATH"

  echo -e "${GREEN}Created/selected:${NC} $FULL_PATH" >&2
  
  # Output the path to stdout for the shell function to use
  echo "$FULL_PATH"
}

# Run the function
main "$@"