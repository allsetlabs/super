.PHONY: help setup-mac update-cc open-mcp submodules clean tree-add tree-remove tree-list claude terminal

# Colors
RED    := \033[0;31m
GREEN  := \033[0;32m
YELLOW := \033[1;33m
BLUE   := \033[0;34m
NC     := \033[0m

help:
	@echo "$(BLUE)Super Repo — Global Commands$(NC)"
	@echo ""
	@echo "$(YELLOW)Setup:$(NC)"
	@echo "  make setup-mac       - Install all system dependencies (Homebrew, Node, Python, tmux, Docker, etc.)"
	@echo "  make update-cc       - Update Claude Code globally"
	@echo ""
	@echo "$(YELLOW)Submodules:$(NC)"
	@echo "  make submodules      - Init and update all submodules"
	@echo ""
	@echo "$(YELLOW)Utilities:$(NC)"
	@echo "  make open-mcp        - Open MCP config files in Cursor"
	@echo "  make claude          - Open Claude Code in current directory"
	@echo "  make terminal        - Open Terminal in current directory"
	@echo "  make clean           - Remove all node_modules across modules"
	@echo ""
	@echo "$(YELLOW)Worktrees:$(NC)"
	@echo "  make tree-add NAME=<branch>    - Create a new git worktree"
	@echo "  make tree-remove NAME=<branch> - Remove a worktree"
	@echo "  make tree-list                 - List all worktrees"
	@echo ""
	@echo "$(YELLOW)To run a module:$(NC)"
	@echo "  cd modules/forge-modules/<module> && make start"
	@echo ""

# ============================================================================
# SYSTEM SETUP
# ============================================================================

setup-mac:
	@echo "$(BLUE)Installing system dependencies...$(NC)"
	@command -v brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@command -v git >/dev/null 2>&1 || brew install git
	@command -v node >/dev/null 2>&1 || brew install node
	@command -v python3 >/dev/null 2>&1 || brew install python@3.12
	@command -v tmux >/dev/null 2>&1 || brew install tmux
	@open -Ra Docker 2>/dev/null || brew install --cask docker
	@npm install -g @anthropic-ai/claude-code 2>/dev/null || true
	@echo "$(GREEN)System setup complete! Run 'make submodules' then cd into any module and run 'make install'.$(NC)"

update-cc:
	@echo "$(GREEN)Updating Claude Code...$(NC)"
	npm install -g @anthropic-ai/claude-code
	@echo "$(GREEN)Done!$(NC)"

# ============================================================================
# SUBMODULES
# ============================================================================

submodules:
	@echo "$(BLUE)Initialising all submodules...$(NC)"
	git submodule update --init --recursive
	@echo "$(GREEN)All submodules ready!$(NC)"

# ============================================================================
# UTILITIES
# ============================================================================

clean:
	@echo "$(YELLOW)Removing node_modules across all modules...$(NC)"
	@find modules/forge-modules -name "node_modules" -type d -prune -exec rm -rf {} + 2>/dev/null || true
	@find modules/forge-modules -name "package-lock.json" -not -path "*/node_modules/*" -delete 2>/dev/null || true
	@echo "$(GREEN)Clean complete!$(NC)"

claude:
	claude --dangerously-skip-permissions

terminal:
	@open -a Terminal $(CURDIR)

open-mcp:
	@open -a "Cursor" \
		"$$HOME/Library/Application Support/Claude/claude_desktop_config.json" \
		"$$HOME/.claude.json" 2>/dev/null || true

# ============================================================================
# GIT WORKTREES
# ============================================================================

tree-add:
ifndef NAME
	$(error NAME is required. Usage: make tree-add NAME=<branch-name>)
endif
	@git worktree add -b $(NAME) ../super-tree/$(NAME) origin/main
	@cursor ../super-tree/$(NAME)
	@echo "$(GREEN)Worktree 'super-tree/$(NAME)' ready!$(NC)"

tree-remove:
ifdef NAME
	@git worktree remove ../super-tree/$(NAME) --force 2>/dev/null || true
	@git worktree prune
	@echo "$(GREEN)Removed super-tree/$(NAME)$(NC)"
else
	@git worktree list --porcelain | grep "^worktree" | cut -d' ' -f2 | grep "/super-tree/" | \
		xargs -I{} git worktree remove {} --force 2>/dev/null || true
	@git worktree prune
	@echo "$(GREEN)All super-tree worktrees removed$(NC)"
endif

tree-list:
	@git worktree list
