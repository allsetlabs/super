.PHONY: help install install-c install-p install-mv install-sw install-se install-sd install-sm install-sb install-dm install-dbb setup-brew setup-git setup-nvm setup-node setup-python setup-PostgreSQL setup-tmux setup-tableplus setup-docker setup-seekr-env setup-mac unsetup-mac clean claude terminal update-cc open-mcp open-seekr-db open-sdb start stop open add-claude remove-claude run-p run-mv run-sw run-se run-sd run-sm run-sb run-sdb run-dm run-dbb run-d stop-d run-dsb stop-dsb create-s-creds tree-add tree-remove tree-list run-cs build-cs

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m

# Port Configuration
PORTFOLIO_PORT := 4000
MEME_VAULT_PORT := 4001
SEEKR_WEB_PORT := 5173
SEEKR_EXTENSION_PORT := 4002
SEEKR_DESKTOP_PORT := 4003
SEEKR_MOBILE_PORT := 4004
BACKEND_PORT := 5001
DATABASE_PORT := 5432
STORYBOOK_PORT := 6006

# Backend Configuration
BACKEND_HOST := 0.0.0.0
DATABASE_NAME := seekr_db
DATABASE_USER := $(shell whoami)
DATABASE_URL := postgresql+psycopg://$(DATABASE_USER)@localhost:$(DATABASE_PORT)/$(DATABASE_NAME)

# API Configuration
API_BASE_URL := http://localhost:$(BACKEND_PORT)

help:
	@echo "$(BLUE)Personal Projects - Makefile Commands$(NC)"
	@echo ""
	@echo "$(YELLOW)System Setup Commands (macOS):$(NC)"
	@echo "  make setup-mac         - Install ALL system dependencies (Homebrew, nvm, Node, Git, Python, PostgreSQL, tmux, TablePlus, Docker) and configure Seekr"
	@echo "  make unsetup-mac       - Remove ALL system dependencies and reset .zshrc"
	@echo "  make setup-brew        - Install Homebrew"
	@echo "  make setup-git         - Install Git"
	@echo "  make setup-nvm         - Install nvm and configure shell"
	@echo "  make setup-node        - Install latest Node.js via nvm"
	@echo "  make setup-python      - Install Python 3.12 and configure PATH"
	@echo "  make setup-PostgreSQL  - Install PostgreSQL via Homebrew"
	@echo "  make setup-tmux        - Install tmux via Homebrew"
	@echo "  make setup-tableplus   - Install TablePlus database GUI"
	@echo "  make setup-docker      - Install Docker Desktop"
	@echo "  make setup-seekr-env   - Configure Seekr environment variables (.env file)"
	@echo ""
	@echo "$(YELLOW)Install Commands:$(NC)"
	@echo "  make install           - Install ALL modules"
	@echo "  make install-c         - Install component library"
	@echo "  make install-p         - Install portfolio"
	@echo "  make install-mv        - Install meme-vault"
	@echo "  make install-sw        - Install Seekr web"
	@echo "  make install-se        - Install Seekr extension"
	@echo "  make install-sd        - Install Seekr desktop"
	@echo "  make install-sm        - Install Seekr mobile"
	@echo "  make install-sb        - Install Seekr backend (Python)"
	@echo "  make install-d         - Install DevBot (app + backend)"
	@echo ""
	@echo "$(YELLOW)Run Commands (local, no tmux):$(NC)"
	@echo "  make run-p             - Run portfolio locally"
	@echo "  make run-mv            - Run meme-vault locally"
	@echo "  make run-sw            - Run Seekr web locally"
	@echo "  make run-se            - Run Seekr extension locally"
	@echo "  make run-sd            - Run Seekr desktop locally"
	@echo "  make run-sm            - Run Seekr mobile locally"
	@echo "  make run-sb            - Run Seekr backend locally"
	@echo "  make run-sdb           - Start PostgreSQL and create database"
	@echo "  make run-cs            - Run Component Storybook locally"
	@echo "  make build-cs          - Build Component Storybook static site"
	@echo ""
	@echo "$(YELLOW)DevBot (run from allset/devbot/):$(NC)"
	@echo "  make install           - Install app + backend"
	@echo "  make start             - Start all services in tmux"
	@echo "  make stop              - Stop all services"
	@echo ""
	@echo "$(YELLOW)Tmux Session Commands:$(NC)"
	@echo "  make start             - Start ALL modules in tmux session 'super'"
	@echo "  make open              - Attach to existing tmux session 'super'"
	@echo "  make stop              - Stop tmux session 'super'"
	@echo "  make add-claude        - Add Claude pane to existing tmux session"
	@echo "  make remove-claude     - Remove Claude pane from tmux session"
	@echo ""
	@echo "$(YELLOW)Utilities:$(NC)"
	@echo "  make clean             - Remove all node_modules and Python venv"
	@echo "  make update-cc         - Update Claude Code globally"
	@echo "  make open-mcp          - Open MCP configuration files"
	@echo "  make open-seekr-db     - Open Seekr database in TablePlus"
	@echo "  make claude            - Open Claude in the current directory"
	@echo "  make terminal       - Open Terminal app in current directory"
	@echo ""

# ============================================================================
# SYSTEM SETUP COMMANDS
# ============================================================================

# Install Homebrew
setup-brew:
	@echo "$(BLUE)🍺 Installing Homebrew...$(NC)"
	@if command -v brew &> /dev/null; then \
		echo "$(GREEN)✅ Homebrew already installed: $$(brew --version | head -1)$(NC)"; \
	else \
		echo "$(YELLOW)Installing Homebrew...$(NC)"; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		echo "$(GREEN)✅ Homebrew installed!$(NC)"; \
	fi
	@echo "$(YELLOW)Configuring Homebrew cask options in .zshrc...$(NC)"
	@if ! grep -q "HOMEBREW_CASK_OPTS" ~/.zshrc 2>/dev/null; then \
		echo "" >> ~/.zshrc; \
		echo "# Homebrew Cask Configuration" >> ~/.zshrc; \
		echo 'export HOMEBREW_CASK_OPTS="--appdir=~/Applications"' >> ~/.zshrc; \
		echo "$(GREEN)✅ Homebrew cask configuration added to .zshrc$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  Homebrew cask configuration already exists in .zshrc$(NC)"; \
	fi

# Install Git
setup-git:
	@echo "$(BLUE)🔧 Installing Git...$(NC)"
	@if command -v git &> /dev/null; then \
		echo "$(GREEN)✅ Git already installed: $$(git --version)$(NC)"; \
	else \
		if command -v brew &> /dev/null; then \
			echo "$(YELLOW)Installing Git via Homebrew...$(NC)"; \
			brew install git; \
			echo "$(GREEN)✅ Git installed!$(NC)"; \
		else \
			echo "$(RED)❌ Homebrew not found. Run 'make setup-brew' first.$(NC)"; \
			exit 1; \
		fi \
	fi

# Install nvm and configure shell
setup-nvm:
	@echo "$(BLUE)📦 Installing nvm...$(NC)"
	@if [ -s "$${HOME}/.nvm/nvm.sh" ]; then \
		echo "$(GREEN)✅ nvm already installed$(NC)"; \
	else \
		echo "$(YELLOW)Installing nvm via official install script...$(NC)"; \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash; \
		echo "$(GREEN)✅ nvm installed!$(NC)"; \
	fi
	@echo "$(BLUE)⚙️  Adding automatic Node version switching to .zshrc...$(NC)"
	@if ! grep -q "load-nvmrc" ~/.zshrc 2>/dev/null; then \
		echo '' >> ~/.zshrc; \
		echo '# Automatically switch Node versions' >> ~/.zshrc; \
		echo 'autoload -U add-zsh-hook' >> ~/.zshrc; \
		echo 'load-nvmrc() {' >> ~/.zshrc; \
		echo '  local node_version="$$(nvm version)"' >> ~/.zshrc; \
		echo '  local nvmrc_path="$$(nvm_find_nvmrc)"' >> ~/.zshrc; \
		echo '' >> ~/.zshrc; \
		echo '  if [ -n "$$nvmrc_path" ]; then' >> ~/.zshrc; \
		echo '    local nvmrc_node_version=$$(nvm version "$$(cat "$${nvmrc_path}")")' >> ~/.zshrc; \
		echo '' >> ~/.zshrc; \
		echo '    if [ "$$nvmrc_node_version" = "N/A" ]; then' >> ~/.zshrc; \
		echo '      nvm install' >> ~/.zshrc; \
		echo '    elif [ "$$nvmrc_node_version" != "$$node_version" ]; then' >> ~/.zshrc; \
		echo '      nvm use' >> ~/.zshrc; \
		echo '    fi' >> ~/.zshrc; \
		echo '  elif [ "$$node_version" != "$$(nvm version default)" ]; then' >> ~/.zshrc; \
		echo '    echo "Reverting to nvm default version"' >> ~/.zshrc; \
		echo '    nvm use default' >> ~/.zshrc; \
		echo '  fi' >> ~/.zshrc; \
		echo '}' >> ~/.zshrc; \
		echo 'add-zsh-hook chpwd load-nvmrc' >> ~/.zshrc; \
		echo 'load-nvmrc' >> ~/.zshrc; \
		echo "$(GREEN)✅ Auto-switching configuration added to .zshrc$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  Auto-switching already configured in .zshrc$(NC)"; \
	fi

# Install latest Node.js via nvm
setup-node:
	@echo "$(BLUE)🟢 Installing latest Node.js via nvm...$(NC)"
	@if ! [ -s "$${HOME}/.nvm/nvm.sh" ]; then \
		echo "$(RED)❌ nvm not found. Run 'make setup-nvm' first.$(NC)"; \
		exit 1; \
	fi
	@bash -c 'source $$HOME/.zshrc && \
	if command -v node &> /dev/null; then \
		CURRENT_VERSION=$$(node --version); \
		echo "$(GREEN)✅ Node.js already installed: $$CURRENT_VERSION$(NC)"; \
		echo "$(YELLOW)Installing latest LTS version...$(NC)"; \
		nvm install --lts; \
		nvm use --lts; \
		nvm alias default "lts/*"; \
		echo "$(GREEN)✅ Latest Node.js LTS installed and set as default!$(NC)"; \
	else \
		echo "$(YELLOW)Installing latest LTS Node.js...$(NC)"; \
		nvm install --lts; \
		nvm use --lts; \
		nvm alias default "lts/*"; \
		echo "$(GREEN)✅ Node.js LTS installed and set as default!$(NC)"; \
	fi && \
	echo "" && \
	echo "$(BLUE)Installed versions:$(NC)" && \
	nvm list'

# Install Python 3.12 and configure PATH
setup-python:
	@echo "$(BLUE)🐍 Installing Python 3.12...$(NC)"
	@if command -v python3.12 &> /dev/null; then \
		echo "$(GREEN)✅ Python 3.12 already installed: $$(python3.12 --version)$(NC)"; \
	else \
		if command -v brew &> /dev/null; then \
			echo "$(YELLOW)Installing Python 3.12 via Homebrew...$(NC)"; \
			brew install python@3.12; \
			echo "$(GREEN)✅ Python 3.12 installed!$(NC)"; \
		else \
			echo "$(RED)❌ Homebrew not found. Run 'make setup-brew' first.$(NC)"; \
			exit 1; \
		fi \
	fi
	@echo "$(BLUE)⚙️  Configuring Python 3.12 PATH in .zshrc...$(NC)"
	@if ! grep -q "python@3.12/bin" ~/.zshrc 2>/dev/null; then \
		echo '' >> ~/.zshrc; \
		echo '# Python 3.12 PATH' >> ~/.zshrc; \
		echo 'export PATH="/opt/homebrew/opt/python@3.12/bin:$$PATH"' >> ~/.zshrc; \
		echo "$(GREEN)✅ Python 3.12 PATH added to .zshrc$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  Python 3.12 already in PATH$(NC)"; \
	fi

# Install PostgreSQL and configure PATH
setup-PostgreSQL:
	@echo "$(BLUE)🐘 Installing PostgreSQL...$(NC)"
	@if command -v psql &> /dev/null; then \
		echo "$(GREEN)✅ PostgreSQL already installed: $$(psql --version)$(NC)"; \
	elif [ -x "/opt/homebrew/opt/postgresql@18/bin/psql" ]; then \
		echo "$(YELLOW)⚠️  PostgreSQL installed but not in PATH$(NC)"; \
	else \
		if command -v brew &> /dev/null; then \
			echo "$(YELLOW)Installing PostgreSQL via Homebrew...$(NC)"; \
			brew install postgresql@18; \
			echo "$(GREEN)✅ PostgreSQL installed!$(NC)"; \
		else \
			echo "$(RED)❌ Homebrew not found. Run 'make setup-brew' first.$(NC)"; \
			exit 1; \
		fi \
	fi
	@echo "$(BLUE)⚙️  Configuring PostgreSQL PATH in .zshrc...$(NC)"
	@if ! grep -q "postgresql@18/bin" ~/.zshrc 2>/dev/null; then \
		echo '' >> ~/.zshrc; \
		echo '# PostgreSQL PATH' >> ~/.zshrc; \
		echo 'export PATH="/opt/homebrew/opt/postgresql@18/bin:$$PATH"' >> ~/.zshrc; \
		echo "$(GREEN)✅ PostgreSQL PATH added to .zshrc$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  PostgreSQL already in PATH$(NC)"; \
	fi

# Install tmux via Homebrew and configure
setup-tmux:
	@echo "$(BLUE)💻 Installing tmux...$(NC)"
	@if command -v tmux &> /dev/null; then \
		echo "$(GREEN)✅ tmux already installed: $$(tmux -V)$(NC)"; \
	else \
		if command -v brew &> /dev/null; then \
			echo "$(YELLOW)Installing tmux via Homebrew...$(NC)"; \
			brew install tmux; \
			echo "$(GREEN)✅ tmux installed!$(NC)"; \
		else \
			echo "$(RED)❌ Homebrew not found. Run 'make setup-brew' first.$(NC)"; \
			exit 1; \
		fi \
	fi
	@echo "$(BLUE)⚙️  Configuring tmux...$(NC)"
	@if [ -f ~/.tmux.conf ]; then \
		echo "$(YELLOW)⚠️  ~/.tmux.conf already exists, skipping configuration$(NC)"; \
	else \
		echo "$(YELLOW)Creating ~/.tmux.conf with mouse support...$(NC)"; \
		cat > ~/.tmux.conf << 'EOF'$(echo) && \
		echo '# Enable mouse support for clicking, scrolling, and resizing' >> ~/.tmux.conf && \
		echo 'set -g mouse on' >> ~/.tmux.conf && \
		echo '' >> ~/.tmux.conf && \
		echo '# Allow easier copy-paste (hold Shift to use macOS native selection)' >> ~/.tmux.conf && \
		echo '# Status bar customization (optional but helpful)' >> ~/.tmux.conf && \
		echo 'set -g status-position bottom' >> ~/.tmux.conf && \
		echo 'set -g status-style bg=colour234,fg=colour137' >> ~/.tmux.conf && \
		echo '' >> ~/.tmux.conf && \
		echo '# Better pane numbering for easier navigation' >> ~/.tmux.conf && \
		echo 'set -g base-index 1' >> ~/.tmux.conf && \
		echo 'setw -g pane-base-index 1' >> ~/.tmux.conf && \
		echo "$(GREEN)✅ tmux configured with mouse support$(NC)"; \
	fi
	@if tmux list-sessions &>/dev/null; then \
		tmux source-file ~/.tmux.conf 2>/dev/null || true; \
		echo "$(GREEN)✅ tmux config reloaded for existing sessions$(NC)"; \
	fi

# Install TablePlus database GUI
setup-tableplus:
	@echo "$(BLUE)🗄️  Installing TablePlus...$(NC)"
	@if command -v brew &> /dev/null; then \
		if open -Ra TablePlus 2>/dev/null; then \
			echo "$(GREEN)✅ TablePlus already installed$(NC)"; \
		else \
			echo "$(YELLOW)Installing TablePlus via Homebrew...$(NC)"; \
			brew install --cask tableplus; \
			echo "$(GREEN)✅ TablePlus installed!$(NC)"; \
		fi \
	else \
		echo "$(RED)❌ Homebrew not found. Run 'make setup-brew' first.$(NC)"; \
		exit 1; \
	fi

# Install Docker Desktop
setup-docker:
	@echo "$(BLUE)🐳 Installing Docker Desktop...$(NC)"
	@if command -v brew &> /dev/null; then \
		if open -Ra Docker 2>/dev/null; then \
			echo "$(GREEN)✅ Docker Desktop already installed$(NC)"; \
		else \
			echo "$(YELLOW)Installing Docker Desktop via Homebrew...$(NC)"; \
			brew install --cask docker; \
			echo "$(GREEN)✅ Docker Desktop installed!$(NC)"; \
		fi \
	else \
		echo "$(RED)❌ Homebrew not found. Run 'make setup-brew' first.$(NC)"; \
		exit 1; \
	fi

# Configure Seekr environment variables
setup-seekr-env:
	@echo ""
	@echo "$(BLUE)🔧 Configuring Seekr Environment Variables...$(NC)"
	@echo ""
	@# Check if .env exists and read existing values
	@if [ -f allset/seekr/.env ]; then \
		echo "$(YELLOW)Found existing .env file. Reading current values...$(NC)"; \
		EXISTING_ANTHROPIC=$$(grep "^ANTHROPIC_API_KEY=" allset/seekr/.env 2>/dev/null | cut -d= -f2); \
		EXISTING_OPENAI=$$(grep "^OPENAI_API_KEY=" allset/seekr/.env 2>/dev/null | cut -d= -f2 | tr -d '"'); \
		EXISTING_GOOGLE=$$(grep "^GOOGLE_CLIENT_ID=" allset/seekr/.env 2>/dev/null | cut -d= -f2); \
		EXISTING_JWT=$$(grep "^JWT_SECRET_KEY=" allset/seekr/.env 2>/dev/null | cut -d= -f2); \
	else \
		echo "$(YELLOW)No existing .env file found.$(NC)"; \
		EXISTING_ANTHROPIC=""; \
		EXISTING_OPENAI=""; \
		EXISTING_GOOGLE=""; \
		EXISTING_JWT=""; \
	fi; \
	echo ""; \
	\
	if [ -n "$$EXISTING_ANTHROPIC" ] && [ "$$EXISTING_ANTHROPIC" != "your_anthropic_api_key_here" ]; then \
		echo "$(GREEN)✅ Using existing Anthropic API Key$(NC)"; \
		ANTHROPIC_KEY="$$EXISTING_ANTHROPIC"; \
	else \
		printf "\033[0;34mAnthropic API Key (Enter to use default): \033[0m"; \
		read ANTHROPIC_KEY; \
		ANTHROPIC_KEY=$${ANTHROPIC_KEY:-your_anthropic_api_key_here}; \
	fi; \
	echo ""; \
	\
	if [ -n "$$EXISTING_OPENAI" ] && [ "$$EXISTING_OPENAI" != "sk-proj-test-key" ]; then \
		echo "$(GREEN)✅ Using existing OpenAI API Key$(NC)"; \
		OPENAI_KEY="$$EXISTING_OPENAI"; \
	else \
		printf "\033[0;34mOpenAI API Key (Enter to use default): \033[0m"; \
		read OPENAI_KEY; \
		OPENAI_KEY=$${OPENAI_KEY:-sk-proj-test-key}; \
	fi; \
	echo ""; \
	\
	if [ -n "$$EXISTING_GOOGLE" ] && [ "$$EXISTING_GOOGLE" != "your-google-client-id-here.apps.googleusercontent.com" ]; then \
		echo "$(GREEN)✅ Using existing Google Client ID$(NC)"; \
		GOOGLE_CLIENT="$$EXISTING_GOOGLE"; \
	else \
		echo "$(YELLOW)Opening Google Cloud Console for OAuth credentials...$(NC)"; \
		open "https://console.cloud.google.com/apis/credentials" 2>/dev/null || true; \
		echo ""; \
		echo "$(YELLOW)📋 Instructions:$(NC)"; \
		echo "  1. Create OAuth 2.0 Client ID (or use existing)"; \
		echo "  2. Add authorized redirect URI: $(GREEN)http://localhost:$(SEEKR_WEB_PORT)$(NC)"; \
		echo "  3. Copy the Client ID and paste below"; \
		echo ""; \
		printf "\033[0;34mGoogle Client ID (Enter to use default): \033[0m"; \
		read GOOGLE_CLIENT; \
		GOOGLE_CLIENT=$${GOOGLE_CLIENT:-your-google-client-id-here.apps.googleusercontent.com}; \
	fi; \
	echo ""; \
	\
	if [ -n "$$EXISTING_JWT" ] && [ "$$EXISTING_JWT" != "your-secret-key-change-this-in-production" ]; then \
		echo "$(GREEN)✅ Using existing JWT secret key$(NC)"; \
		JWT_SECRET="$$EXISTING_JWT"; \
	else \
		echo "$(YELLOW)Generating random JWT secret key...$(NC)"; \
		JWT_SECRET=$$(openssl rand -hex 32); \
		echo "$(GREEN)✅ JWT secret generated$(NC)"; \
	fi; \
	echo ""; \
	\
	echo "$(YELLOW)Writing to allset/seekr/.env file...$(NC)"; \
	cat > allset/seekr/.env << EOF$(echo) && \
	echo "# API Keys" >> allset/seekr/.env && \
	echo "ANTHROPIC_API_KEY=$$ANTHROPIC_KEY" >> allset/seekr/.env && \
	echo "OPENAI_API_KEY=\"$$OPENAI_KEY\"" >> allset/seekr/.env && \
	echo "" >> allset/seekr/.env && \
	echo "# Google OAuth Configuration" >> allset/seekr/.env && \
	echo "# Get your Client ID from: https://console.cloud.google.com/apis/credentials" >> allset/seekr/.env && \
	echo "GOOGLE_CLIENT_ID=$$GOOGLE_CLIENT" >> allset/seekr/.env && \
	echo "" >> allset/seekr/.env && \
	echo "# JWT Secret Key (generate a random secure key)" >> allset/seekr/.env && \
	echo "# You can generate one using: openssl rand -hex 32" >> allset/seekr/.env && \
	echo "JWT_SECRET_KEY=$$JWT_SECRET" >> allset/seekr/.env && \
	echo "" >> allset/seekr/.env && \
	echo "# Frontend Configuration (used by web app)" >> allset/seekr/.env && \
	echo "VITE_GOOGLE_CLIENT_ID=$$GOOGLE_CLIENT" >> allset/seekr/.env && \
	echo "$(GREEN)✅ Environment file configured at allset/seekr/.env$(NC)"

# Complete system setup for macOS
setup-mac:
	@echo "$(BLUE)🚀 Starting Complete System Setup...$(NC)"
	@echo ""
	@echo "$(YELLOW)This will install:$(NC)"
	@echo "  1. Homebrew (package manager)"
	@echo "  2. Git (version control)"
	@echo "  3. nvm (Node version manager)"
	@echo "  4. Node.js LTS (JavaScript runtime)"
	@echo "  5. Python 3.12 (Python runtime)"
	@echo "  6. PostgreSQL 18 (Database)"
	@echo "  7. tmux (terminal multiplexer)"
	@echo "  8. TablePlus (Database GUI)"
	@echo "  9. Docker Desktop (Containerization)"
	@echo " 10. Claude Code (CLI tool)"
	@echo ""
	@$(MAKE) setup-brew
	@$(MAKE) setup-git
	@$(MAKE) setup-nvm
	@$(MAKE) setup-node
	@$(MAKE) setup-python
	@$(MAKE) setup-PostgreSQL
	@$(MAKE) setup-tmux
	@$(MAKE) setup-tableplus
	@$(MAKE) setup-docker
	@$(MAKE) setup-seekr-env
	@echo ""
	@echo "$(BLUE)🤖 Installing Claude Code...$(NC)"
	@bash -c 'source $$HOME/.zshrc && npm install -g @anthropic-ai/claude-code'
	@echo "$(GREEN)✅ Claude Code installed!$(NC)"
	@echo "$(BLUE)⚙️  Configuring Claude Code PATH in .zshrc...$(NC)"
	@if ! grep -q '\.local/bin.*PATH' ~/.zshrc 2>/dev/null; then \
		echo '' >> ~/.zshrc; \
		echo '# Claude Code PATH' >> ~/.zshrc; \
		echo 'export PATH="$$HOME/.local/bin:$$PATH"' >> ~/.zshrc; \
		echo "$(GREEN)✅ Claude Code PATH added to .zshrc$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  .local/bin already in PATH$(NC)"; \
	fi
	@echo ""
	@echo "$(GREEN)✅✅✅ System Setup Complete! ✅✅✅$(NC)"
	@echo ""
	@echo "$(YELLOW)Reloading shell configuration...$(NC)"
	@zsh -c 'source ~/.zshrc'
	@echo "$(GREEN)✅ Shell configuration reloaded$(NC)"
	@echo ""
	@echo "$(BLUE)Next steps:$(NC)"
	@echo "  Run 'make install' to install all project modules"
	@echo ""

# ============================================================================
# INSTALL COMMANDS
# ============================================================================

# Install everything
install:
	@echo "$(GREEN)🚀 Starting installation of all modules...$(NC)"
	@echo ""
	@$(MAKE) install-c
	@$(MAKE) install-p
	@$(MAKE) install-mv
	@$(MAKE) install-sw
	@$(MAKE) install-se
	@$(MAKE) install-sd
	@$(MAKE) install-sm
	@$(MAKE) install-sb
	@$(MAKE) install-d
	@echo ""
	@echo "$(GREEN)✅✅✅ Installation Complete! ✅✅✅$(NC)"
	@echo ""
	@echo "$(BLUE)Installed:$(NC)"
	@echo "  ✓ Component library"
	@echo "  ✓ Portfolio"
	@echo "  ✓ Meme Vault"
	@echo "  ✓ Seekr Web, Extension, Desktop, Mobile"
	@echo "  ✓ Seekr Backend (Python venv)"
	@echo "  ✓ DevBot App, Backend"
	@echo ""

# Install component library
install-c:
	@echo "$(BLUE)📦 Installing component library...$(NC)"
	cd allset/ui && npm install
	@echo "$(GREEN)✅ Component library ready!$(NC)"

# Install portfolio
install-p:
	@echo "$(BLUE)📦 Installing portfolio...$(NC)"
	cd allset/portfolio && npm install
	@echo "$(GREEN)✅ Portfolio ready!$(NC)"

# Install meme-vault
install-mv:
	@echo "$(BLUE)📦 Installing meme-vault...$(NC)"
	cd allset/meme-vault && npm install
	@echo "$(GREEN)✅ Meme-sounds ready!$(NC)"

# Install Seekr web
install-sw:
	@echo "$(BLUE)📦 Installing Seekr web...$(NC)"
	cd allset/seekr/web && npm install
	@echo "$(GREEN)✅ Seekr web ready!$(NC)"

# Install Seekr extension
install-se:
	@echo "$(BLUE)📦 Installing Seekr extension...$(NC)"
	cd allset/seekr/extension && npm install
	@echo "$(GREEN)✅ Seekr extension ready!$(NC)"

# Install Seekr desktop
install-sd:
	@echo "$(BLUE)📦 Installing Seekr desktop...$(NC)"
	cd allset/seekr/desktop && npm install
	@echo "$(GREEN)✅ Seekr desktop ready!$(NC)"

# Install Seekr mobile
install-sm:
	@echo "$(BLUE)📦 Installing Seekr mobile...$(NC)"
	cd allset/seekr/mobile && npm install
	@echo "$(GREEN)✅ Seekr mobile ready!$(NC)"

# Install Seekr backend (Python)
install-sb:
	@echo "$(BLUE)🐍 Installing Seekr Backend (Python 3.12)...$(NC)"
	cd allset/seekr/backend && \
	python3.12 -m venv venv && \
	. venv/bin/activate && \
	pip install --upgrade pip && \
	pip install -r requirements.txt
	@echo "$(GREEN)✅ Seekr Backend dependencies installed!$(NC)"
	@echo ""
	@$(MAKE) setup-seekr-env
	@echo ""
	@echo "$(GREEN)✅ Seekr Backend ready!$(NC)"

# Install DevBot (app + backend)
install-d:
	cd allset/devbot && $(MAKE) install

# ============================================================================
# RUN COMMANDS (local, no tmux)
# ============================================================================

# Run portfolio locally
run-p:
	@echo "$(YELLOW)Killing process on port $(PORTFOLIO_PORT)...$(NC)"
	@npx kill-port $(PORTFOLIO_PORT) 2>/dev/null || true
	@echo "$(GREEN)🚀 Starting Portfolio on port $(PORTFOLIO_PORT)...$(NC)"
	cd allset/portfolio && npm start -- --port=$(PORTFOLIO_PORT)

# Run meme-vault locally
run-mv:
	@echo "$(YELLOW)Killing process on port $(MEME_VAULT_PORT)...$(NC)"
	@npx kill-port $(MEME_VAULT_PORT) 2>/dev/null || true
	@echo "$(GREEN)🚀 Starting Meme-Sounds on port $(MEME_VAULT_PORT)...$(NC)"
	cd allset/meme-vault && npm start -- --port=$(MEME_VAULT_PORT)

# Run Seekr web locally
run-sw:
	@echo "$(YELLOW)Killing process on port $(SEEKR_WEB_PORT)...$(NC)"
	@npx kill-port $(SEEKR_WEB_PORT) 2>/dev/null || true
	@echo "$(GREEN)🚀 Starting Seekr Web on port $(SEEKR_WEB_PORT)...$(NC)"
	cd allset/seekr/web && VITE_API_BASE_URL=$(API_BASE_URL) npm start -- --port=$(SEEKR_WEB_PORT)

# Run Seekr extension locally
run-se:
	@echo "$(YELLOW)Killing process on port $(SEEKR_EXTENSION_PORT)...$(NC)"
	@npx kill-port $(SEEKR_EXTENSION_PORT) 2>/dev/null || true
	@echo "$(GREEN)🚀 Starting Seekr Extension on port $(SEEKR_EXTENSION_PORT)...$(NC)"
	cd allset/seekr/extension && npm run dev

# Run Seekr desktop locally
run-sd:
	@echo "$(YELLOW)Killing process on port $(SEEKR_DESKTOP_PORT)...$(NC)"
	@npx kill-port $(SEEKR_DESKTOP_PORT) 2>/dev/null || true
	@echo "$(GREEN)🚀 Starting Seekr Desktop on port $(SEEKR_DESKTOP_PORT)...$(NC)"
	cd allset/seekr/desktop && npm run dev -- --port=$(SEEKR_DESKTOP_PORT)

# Run Seekr mobile locally
run-sm:
	@echo "$(YELLOW)Killing process on port $(SEEKR_MOBILE_PORT)...$(NC)"
	@npx kill-port $(SEEKR_MOBILE_PORT) 2>/dev/null || true
	@echo "$(GREEN)🚀 Starting Seekr Mobile on port $(SEEKR_MOBILE_PORT)...$(NC)"
	cd allset/seekr/mobile && npm run dev -- --port=$(SEEKR_MOBILE_PORT)

# Start PostgreSQL and create database if needed
run-sdb:
	@echo "$(BLUE)🐘 Setting up PostgreSQL...$(NC)"
	@export PATH="/opt/homebrew/opt/postgresql@18/bin:$$PATH"; \
	if ! command -v psql &> /dev/null; then \
		echo "$(RED)❌ PostgreSQL not found. Run 'make setup-PostgreSQL' first.$(NC)"; \
		exit 1; \
	fi; \
	if ! pg_isready -q 2>/dev/null; then \
		echo "$(YELLOW)Starting PostgreSQL...$(NC)"; \
		brew services start postgresql@18 2>/dev/null || brew services start postgresql 2>/dev/null || true; \
		sleep 2; \
		if ! pg_isready -q 2>/dev/null; then \
			echo "$(RED)❌ Failed to start PostgreSQL$(NC)"; \
			exit 1; \
		fi; \
	fi; \
	echo "$(GREEN)✅ PostgreSQL running$(NC)"; \
	if ! psql -lqt 2>/dev/null | cut -d \| -f 1 | grep -qw $(DATABASE_NAME); then \
		echo "$(YELLOW)Creating database '$(DATABASE_NAME)'...$(NC)"; \
		createdb $(DATABASE_NAME) 2>/dev/null || true; \
	fi; \
	echo "$(GREEN)✅ Database '$(DATABASE_NAME)' ready$(NC)"

# Run Seekr backend locally
run-sb:
	@echo "$(YELLOW)Killing process on port $(BACKEND_PORT)...$(NC)"
	@npx kill-port $(BACKEND_PORT) 2>/dev/null || true
	@$(MAKE) run-sdb
	@$(MAKE) open-sdb
	@echo "$(GREEN)🚀 Starting Seekr Backend on port $(BACKEND_PORT)...$(NC)"
	@echo "$(GREEN)🎯 Server: http://localhost:$(BACKEND_PORT)$(NC)"
	@echo "$(GREEN)📚 API Docs: http://localhost:$(BACKEND_PORT)/docs$(NC)"
	@cd allset/seekr/backend && \
		. venv/bin/activate && \
		DATABASE_URL=$(DATABASE_URL) \
		BACKEND_HOST=$(BACKEND_HOST) \
		BACKEND_PORT=$(BACKEND_PORT) \
		MODE=development \
		python main.py


# Run Component Storybook locally
run-cs:
	@echo "$(YELLOW)Killing process on port $(STORYBOOK_PORT)...$(NC)"
	@npx kill-port $(STORYBOOK_PORT) 2>/dev/null || true
	@echo "$(GREEN)🚀 Starting Component Storybook on port $(STORYBOOK_PORT)...$(NC)"
	cd allset/ui && npm run storybook

# Build Component Storybook static site
build-cs:
	@echo "$(GREEN)🏗️  Building Component Storybook...$(NC)"
	cd allset/ui && npm run build-storybook
	@echo "$(GREEN)✅ Storybook built to allset/ui/storybook-static/$(NC)"


# ============================================================================
# TMUX SESSION COMMANDS
# ============================================================================

# Start all modules in tmux session
start:
	@echo "$(BLUE)🚀 Starting all modules in tmux session 'super'...$(NC)"
	@echo ""
	@if tmux has-session -t super 2>/dev/null; then \
		echo "$(YELLOW)⚠️  Tmux session 'super' already exists. Killing it first...$(NC)"; \
		tmux kill-session -t super; \
	fi
	@echo "$(YELLOW)Killing processes on all ports...$(NC)"
	@npx kill-port $(BACKEND_PORT) $(PORTFOLIO_PORT) $(MEME_VAULT_PORT) $(SEEKR_WEB_PORT) $(SEEKR_EXTENSION_PORT) $(SEEKR_DESKTOP_PORT) $(SEEKR_MOBILE_PORT) 2>/dev/null || true
	@echo "$(GREEN)Creating tmux session 'super'...$(NC)"
	@tmux new-session -d -s super -n seekr-backend
	@tmux send-keys -t super:seekr-backend 'make run-sb' C-m
	@sleep 2
	@tmux new-window -t super -n portfolio
	@tmux send-keys -t super:portfolio 'make run-p' C-m
	@sleep 1
	@tmux new-window -t super -n meme-vault
	@tmux send-keys -t super:meme-vault 'make run-mv' C-m
	@sleep 1
	@tmux new-window -t super -n seekr-web
	@tmux send-keys -t super:seekr-web 'make run-sw' C-m
	@sleep 1
	@tmux new-window -t super -n seekr-extension
	@tmux send-keys -t super:seekr-extension 'make run-se' C-m
	@sleep 1
	@tmux new-window -t super -n seekr-desktop
	@tmux send-keys -t super:seekr-desktop 'make run-sd' C-m
	@sleep 1
	@tmux new-window -t super -n seekr-mobile
	@tmux send-keys -t super:seekr-mobile 'make run-sm' C-m
	@echo ""
	@echo "$(GREEN)✅✅✅ All modules started! ✅✅✅$(NC)"
	@echo ""
	@echo "$(BLUE)Active windows:$(NC)"
	@tmux list-windows -t super 2>/dev/null || true
	@echo ""
	@echo "$(YELLOW)Use 'make open' to attach to the tmux session$(NC)"
	@echo "$(YELLOW)Use 'make stop' to stop all modules$(NC)"

# Attach to existing tmux session
open:
	@if ! tmux has-session -t super 2>/dev/null; then \
		echo "$(RED)❌ Tmux session 'super' does not exist!$(NC)"; \
		echo "$(YELLOW)Use 'make start' to create it.$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)Opening tmux session 'super'...$(NC)"
	@tmux attach -t super

# Stop tmux session
stop:
	@if ! tmux has-session -t super 2>/dev/null; then \
		echo "$(YELLOW)⚠️  Tmux session 'super' does not exist.$(NC)"; \
		exit 0; \
	fi
	@echo "$(YELLOW)Stopping tmux session 'super'...$(NC)"
	@tmux kill-session -t super
	@echo "$(GREEN)✅ Tmux session 'super' stopped!$(NC)"

# Add Claude pane to existing tmux session
add-claude:
	@if ! tmux has-session -t super 2>/dev/null; then \
		echo "$(RED)❌ Tmux session 'super' does not exist!$(NC)"; \
		echo "$(YELLOW)Use 'make start' to create it first.$(NC)"; \
		exit 1; \
	fi
	@INDEX=1; \
	while tmux list-windows -t super 2>/dev/null | grep -q "claude-$$INDEX"; do \
		INDEX=$$((INDEX + 1)); \
	done; \
	echo "$(GREEN)Adding Claude window 'claude-$$INDEX' to tmux session 'super'...$(NC)"; \
	tmux new-window -t super -n claude-$$INDEX; \
	tmux send-keys -t super:claude-$$INDEX 'make claude' C-m; \
	echo "$(GREEN)✅ Claude window 'claude-$$INDEX' added! Use 'make open' to attach.$(NC)"

# Remove all Claude windows from tmux session
remove-claude:
	@if ! tmux has-session -t super 2>/dev/null; then \
		echo "$(YELLOW)⚠️  Tmux session 'super' does not exist.$(NC)"; \
		exit 0; \
	fi
	@CLAUDE_WINDOWS=$$(tmux list-windows -t super -F "#{window_name}" 2>/dev/null | grep "claude" || true); \
	if [ -z "$$CLAUDE_WINDOWS" ]; then \
		echo "$(YELLOW)⚠️  No Claude windows exist in session 'super'.$(NC)"; \
		exit 0; \
	fi; \
	echo "$(YELLOW)Removing all Claude windows from tmux session 'super'...$(NC)"; \
	for WINDOW in $$CLAUDE_WINDOWS; do \
		echo "  → Removing $$WINDOW..."; \
		tmux kill-window -t super:$$WINDOW 2>/dev/null || true; \
	done; \
	echo "$(GREEN)✅ All Claude windows removed!$(NC)"

# ============================================================================
# UTILITY COMMANDS
# ============================================================================

# Clean all node_modules and Python venv
clean:
	@echo "$(YELLOW)🧹 Cleaning all node_modules and package-lock.json...$(NC)"
	rm -rf allset/ui/node_modules allset/ui/package-lock.json
	rm -rf allset/portfolio/node_modules allset/portfolio/package-lock.json
	rm -rf allset/meme-vault/node_modules allset/meme-vault/package-lock.json
	rm -rf allset/seekr/extension/node_modules allset/seekr/extension/package-lock.json
	rm -rf allset/seekr/web/node_modules allset/seekr/web/package-lock.json
	rm -rf allset/seekr/desktop/node_modules allset/seekr/desktop/package-lock.json
	rm -rf allset/seekr/mobile/node_modules allset/seekr/mobile/package-lock.json
	rm -rf allset/devbot/app/node_modules allset/devbot/app/package-lock.json
	rm -rf allset/devbot/backend/node_modules allset/devbot/backend/package-lock.json
	@echo "$(YELLOW)🧹 Cleaning Python venv...$(NC)"
	rm -rf allset/seekr/backend/venv
	@echo "$(GREEN)✅ Cleanup complete!$(NC)"

# Remove ALL system dependencies (Homebrew, nvm, Node, Python, PostgreSQL, tmux, .zshrc)
unsetup-mac:
	@echo "$(RED)⚠️⚠️⚠️  WARNING  ⚠️⚠️⚠️$(NC)"
	@echo ""
	@echo "$(YELLOW)This will PERMANENTLY remove:$(NC)"
	@echo "  • All node_modules and Python venv directories"
	@echo "  • Docker Desktop (containerization)"
	@echo "  • TablePlus (database GUI)"
	@echo "  • Homebrew and ALL Homebrew packages (Git, Python 3.12, PostgreSQL, tmux)"
	@echo "  • nvm and all Node.js versions"
	@echo "  • .zshrc file (will be cleared completely)"
	@echo "  • Seekr environment configuration (allset/seekr/.env)"
	@echo "  • All cache directories"
	@echo ""
	@echo "$(YELLOW)🗑️  Cleaning project dependencies...$(NC)"
	@$(MAKE) clean
	@echo ""
	@echo "$(YELLOW)🗑️  Uninstalling Docker Desktop...$(NC)"
	@if command -v brew &> /dev/null; then \
		brew uninstall --cask docker 2>/dev/null || true; \
	fi
	@rm -rf ~/Applications/Docker.app 2>/dev/null || true
	@rm -rf /Applications/Docker.app 2>/dev/null || true
	@rm -rf ~/Library/Group\ Containers/group.com.docker 2>/dev/null || true
	@rm -rf ~/Library/Containers/com.docker.docker 2>/dev/null || true
	@rm -rf ~/Library/Application\ Support/Docker\ Desktop 2>/dev/null || true
	@rm -rf ~/.docker 2>/dev/null || true
	@echo "$(GREEN)✅ Docker Desktop removed$(NC)"
	@echo ""
	@echo "$(YELLOW)🗑️  Uninstalling TablePlus...$(NC)"
	@if command -v brew &> /dev/null; then \
		brew uninstall --cask tableplus 2>/dev/null || true; \
	fi
	@rm -rf ~/Applications/TablePlus.app 2>/dev/null || true
	@rm -rf /Applications/TablePlus.app 2>/dev/null || true
	@rm -rf ~/Library/Application\ Support/com.tinyapp.TablePlus 2>/dev/null || true
	@rm -rf ~/Library/Preferences/com.tinyapp.TablePlus.plist 2>/dev/null || true
	@rm -rf ~/Library/Caches/com.tinyapp.TablePlus 2>/dev/null || true
	@echo "$(GREEN)✅ TablePlus removed$(NC)"
	@echo ""
	@echo "$(YELLOW)🗑️  Removing PostgreSQL data...$(NC)"
	@rm -rf /usr/local/var/postgres 2>/dev/null || true
	@rm -rf /usr/local/var/postgresql@* 2>/dev/null || true
	@rm -rf ~/Library/Application\ Support/Postgres 2>/dev/null || true
	@rm -rf ~/.postgresql_history ~/.psql_history 2>/dev/null || true
	@echo "$(GREEN)✅ PostgreSQL data removed$(NC)"
	@echo ""
	@echo "$(YELLOW)🗑️  Uninstalling Homebrew (removes Git, Python, PostgreSQL, tmux)...$(NC)"
	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
	@echo "$(GREEN)✅ Homebrew removed (Git, Python 3.12, PostgreSQL, tmux all removed)$(NC)"
	@echo ""
	@echo "$(YELLOW)🗑️  Removing nvm and Node.js...$(NC)"
	@rm -rf ~/.nvm ~/.npm ~/.node-gyp ~/.node_repl_history
	@echo "$(GREEN)✅ nvm and Node.js removed$(NC)"
	@echo ""
	@echo "$(YELLOW)🗑️  Clearing .zshrc...$(NC)"
	@> ~/.zshrc
	@echo "$(GREEN)✅ .zshrc cleared$(NC)"
	@echo ""
	@echo "$(YELLOW)🗑️  Removing tmux config...$(NC)"
	@rm -f ~/.tmux.conf
	@echo "$(GREEN)✅ tmux config removed$(NC)"
	@echo ""
	@echo "$(YELLOW)🗑️  Removing Seekr environment file...$(NC)"
	@rm -f allset/seekr/.env
	@echo "$(GREEN)✅ Seekr .env file removed$(NC)"
	@echo ""
	@echo "$(YELLOW)🗑️  Cleaning cache directories...$(NC)"
	@rm -rf ~/Library/Caches/Homebrew 2>/dev/null || true
	@rm -rf ~/Library/Logs/Homebrew 2>/dev/null || true
	@rm -rf ~/.cache/pip 2>/dev/null || true
	@rm -rf ~/.pyenv 2>/dev/null || true
	@rm -rf /Library/Frameworks/Python.framework 2>/dev/null || true
	@echo "$(GREEN)✅ Cache cleaned$(NC)"
	@echo ""
	@echo "$(GREEN)✅✅✅ All system dependencies removed! ✅✅✅$(NC)"
	@echo ""
	@echo "$(BLUE)To reinstall everything:$(NC)"
	@echo "  1. Restart your terminal"
	@echo "  2. Run 'make setup-mac'"
	@echo ""
	@echo "$(YELLOW)⚠️  Note: macOS system tools (/usr/bin/git, /usr/bin/python3) remain intact$(NC)"

claude: ## Open Claude in the current directory
	claude --dangerously-skip-permissions --chrome

terminal: ## Open Terminal app in current directory
	@open -a Terminal $(CURDIR)

open-mcp: ## Open MCP configuration files in Cursor
	@open -a "Cursor" \
		"$$HOME/Library/Application Support/Claude/claude_desktop_config.json" \
		"$$HOME/.cursor/mcp.json" \
		"$$HOME/.claude.json" && \
	if [ -f "$$HOME/.claude.json" ]; then \
		LINE_NUM=$$(grep -n "mcpServers" "$$HOME/.claude.json" | head -1 | cut -d: -f1) && \
		if [ -n "$$LINE_NUM" ]; then \
			echo "$(GREEN)Found mcpServers at line $$LINE_NUM in .claude.json$(NC)"; \
		fi; \
	fi

open-sdb: ## Open Seekr database in TablePlus
	@echo "$(GREEN)🗄️  Opening Seekr database in TablePlus...$(NC)"
	@DB_URL=$$(echo "$(DATABASE_URL)" | sed 's/postgresql+psycopg:/postgresql:/'); \
	if command -v open &> /dev/null; then \
		if open -Ra TablePlus 2>/dev/null; then \
			echo "$(GREEN)Opening database: $$DB_URL$(NC)"; \
			open -a TablePlus "$$DB_URL" 2>/dev/null || (echo "$(YELLOW)⚠️  Opening TablePlus manually...$(NC)" && open -a TablePlus); \
		else \
			echo "$(YELLOW)⚠️  TablePlus not found. Install with: brew install --cask tableplus$(NC)"; \
		fi; \
	else \
		echo "$(RED)❌ Error: macOS 'open' command not available (macOS only)$(NC)"; \
	fi

update-cc: ## Update Claude Code globally via npm
	@echo "$(GREEN)Installing Claude Code globally...$(NC)" && \
	npm install -g @anthropic-ai/claude-code && \
	echo "$(GREEN)✅ Claude Code installed successfully!$(NC)"

# ============================================================================
# GIT WORKTREE COMMANDS
# ============================================================================

tree-add:
ifndef NAME
	$(error NAME is required. Usage: make tree-add NAME=<branch-name>)
endif
	@echo "Creating worktree: super-tree/$(NAME) from main"
	@git worktree add -b $(NAME) ../super-tree/$(NAME) origin/main
	@echo "Opening worktree in Cursor..."
	@cursor ../super-tree/$(NAME)
	@echo "Worktree 'super-tree/$(NAME)' setup complete!"

tree-remove:
ifdef NAME
	@echo "Removing worktree: $(NAME)"
	@git worktree remove ../super-tree/$(NAME) --force 2>/dev/null || git worktree remove ../super-tree/$(NAME) 2>/dev/null || true
	@echo "Pruning worktree references..."
	@git worktree prune
	@echo "Worktree 'super-tree/$(NAME)' has been removed!"
else
	@echo "Finding and removing all worktrees starting with 'super-tree/'..."
	@git worktree list --porcelain | grep "^worktree" | cut -d' ' -f2 | grep "/super-tree/" | while read -r worktree_path; do \
		worktree_name=$$(basename "$$worktree_path"); \
		echo "Removing worktree: $$worktree_name at $$worktree_path"; \
		git worktree remove "$$worktree_path" --force 2>/dev/null || git worktree remove "$$worktree_path" 2>/dev/null || true; \
	done
	@echo "Pruning worktree references..."
	@git worktree prune
	@echo "All super-tree/* worktrees have been removed!"
endif

tree-list:
	@echo "Listing all worktrees in 'super-tree/':"
	@echo "================================================"
	@found=0; \
	git worktree list --porcelain | awk ' \
		BEGIN { found=0 } \
		/^worktree/ { \
			path=$$2; \
			if (path ~ /\/super-tree\//) { \
				found=1; \
				name=path; \
				gsub(/.*\//, "", name); \
				printf "%-30s %s\n", "Name:", name; \
				printf "%-30s %s\n", "Path:", path; \
			} \
		} \
		/^HEAD/ && found { \
			commit=$$2; \
			printf "%-30s %s\n", "Commit:", substr(commit, 1, 8); \
		} \
		/^branch/ && found { \
			branch=$$2; \
			gsub(/refs\/heads\//, "", branch); \
			printf "%-30s %s\n", "Branch:", branch; \
			print "------------------------------------------------"; \
			found=0; \
		} \
		/^detached/ && found { \
			printf "%-30s %s\n", "Branch:", "(detached HEAD)"; \
			print "------------------------------------------------"; \
			found=0; \
		} \
	' | { \
		if read -r line; then \
			echo "$$line"; \
			cat; \
		else \
			echo "No worktrees found starting with 'super-tree/'"; \
		fi \
	}

# Seekr Credentials Configuration
SEEKR_CREDS_FILE := seekr-creds.json
SEEKR_API_URL := http://localhost:$(BACKEND_PORT)

# Create Seekr test credentials
create-s-creds:
	@echo "$(BLUE)🔐 Creating Seekr test credentials...$(NC)"
	@# Check if backend is running
	@if ! curl -s "$(SEEKR_API_URL)/health" > /dev/null 2>&1; then \
		echo "$(RED)❌ Backend not running at $(SEEKR_API_URL)$(NC)"; \
		echo "$(YELLOW)   Run 'make start-seekr-backend' first$(NC)"; \
		exit 1; \
	fi
	@# Determine next user number
	@if [ -f "$(SEEKR_CREDS_FILE)" ]; then \
		NEXT_NUM=$$(python3 -c "import json; d=json.load(open('$(SEEKR_CREDS_FILE)')); print(len(d)+1)"); \
	else \
		NEXT_NUM=1; \
		echo '{}' > "$(SEEKR_CREDS_FILE)"; \
	fi; \
	USER_KEY="test_user_$$NEXT_NUM"; \
	EMAIL="testuser$$NEXT_NUM@example.com"; \
	PASSWORD="DevTest$$NEXT_NUM!"; \
	echo "$(GREEN)👤 Creating $$USER_KEY ($$EMAIL)...$(NC)"; \
	RESPONSE=$$(curl -s -X POST "$(SEEKR_API_URL)/api/auth/signup" \
		-H "Content-Type: application/json" \
		-d "{\"email\": \"$$EMAIL\", \"password\": \"$$PASSWORD\", \"name\": \"Test User $$NEXT_NUM\"}"); \
	if echo "$$RESPONSE" | grep -q "access_token"; then \
		echo "$(GREEN)✅ User created successfully$(NC)"; \
		python3 -c "import json; \
d=json.load(open('$(SEEKR_CREDS_FILE)')); \
d['$$USER_KEY']={'email': '$$EMAIL', 'password': '$$PASSWORD'}; \
json.dump(d, open('$(SEEKR_CREDS_FILE)', 'w'), indent=2)"; \
		echo "$(GREEN)💾 Credentials saved to $(SEEKR_CREDS_FILE)$(NC)"; \
		echo ""; \
		echo "$(BLUE)📋 Credentials:$(NC)"; \
		echo "   Email:    $$EMAIL"; \
		echo "   Password: $$PASSWORD"; \
	elif echo "$$RESPONSE" | grep -q "already registered"; then \
		echo "$(YELLOW)⚠️  Email already registered, trying next...$(NC)"; \
		$(MAKE) create-s-creds; \
	elif echo "$$RESPONSE" | grep -q "development mode"; then \
		echo "$(RED)❌ Backend not in development mode$(NC)"; \
		echo "$(YELLOW)   Ensure MODE=development is set$(NC)"; \
		exit 1; \
	else \
		echo "$(RED)❌ Signup failed: $$RESPONSE$(NC)"; \
		exit 1; \
	fi
