# Makefile for Marp scripts
# Facilitates the use of presentation conversion scripts

# Default configuration
THEME ?= fine-tuning
VERBOSE ?= false
FORCE ?= false

# Directories
SCRIPTS_DIR = scripts
THEME_DIR = themes/$(THEME)
IMG_SRC_DIR = $(THEME_DIR)/presentation/img_src

# Logo and styling configuration (can be overridden)
LOGO_LEFT ?= $(IMG_SRC_DIR)/logo_left.png
LOGO_RIGHT ?= $(IMG_SRC_DIR)/logo_right.png
BACKGROUND ?= $(IMG_SRC_DIR)/background.png
HEADER_TEXT ?= "My Company - Training Course"
FOOTER_TEXT ?= "Confidential - All rights reserved"

.PHONY: help setup install clean all convert md-to-marp watch config validate create-theme default-logos show-config custom open-pdfs

# Default command
help: ## Show this help
	@echo "Marp Scripts - Makefile"
	@echo ""
	@echo "Usage: make [command] [options]"
	@echo ""
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Variables:"
	@echo "  THEME           Theme/project to use (default: fine-tuning)"
	@echo "  VERBOSE         Verbose mode (default: false)"
	@echo "  FORCE           Force mode - skip all confirmations (default: false)"
	@echo "  LOGO_LEFT       Left logo path (default: $(IMG_SRC_DIR)/logo_left.png)"
	@echo "  LOGO_RIGHT      Right logo path (default: $(IMG_SRC_DIR)/logo_right.png)"
	@echo "  BACKGROUND      Background image path (default: $(IMG_SRC_DIR)/background.png)"
	@echo "  HEADER_TEXT     Header text (default: My Company - Training Course)"
	@echo "  FOOTER_TEXT     Footer text (default: Confidential - All rights reserved)"
	@echo ""
	@echo "Examples:"
	@echo "  make setup                    # Install Marp CLI"
	@echo "  make all                      # Convert everything with logos/headers/footers"
	@echo "  make all THEME=my-course      # Convert everything (my-course)"
	@echo "  make convert VERBOSE=true     # Convert with verbose mode"
	@echo "  make all FORCE=true           # Convert without any confirmations"
	@echo "  make create-theme NAME=fine-tuning   # Create new theme 'fine-tuning'"
	@echo "  make open-pdfs THEME=my-course    # Open all PDFs for theme"
	@echo "  make all HEADER_TEXT='My Company' FOOTER_TEXT='Confidential' # Custom headers/footers"

setup: ## Install Marp CLI
	@echo "🚀 Installing Marp CLI..."
	@$(SCRIPTS_DIR)/setup_marp.sh

install: setup ## Alias for setup

md-to-marp: ## Convert MD files to Marp format with logos/headers/footers
	@echo "📝 Converting MD to Marp with logos, headers, and footers..."
	@if [ "$(FORCE)" != "true" ] && [ -d "$(THEME_DIR)/presentation/marp_slides" ] && [ -n "$$(ls -A $(THEME_DIR)/presentation/marp_slides 2>/dev/null)" ]; then \
		echo "⚠️  WARNING: Files exist in $(THEME_DIR)/presentation/marp_slides/"; \
		echo "   This command will overwrite existing Marp files, including any manual adjustments."; \
		echo ""; \
		read -p "Do you want to overwrite marp_slides? (y/N): " confirm && \
		if [ "$$confirm" != "y" ] && [ "$$confirm" != "Y" ]; then \
			echo "❌ Marp conversion cancelled"; \
			exit 1; \
		fi; \
	fi
	@if [ "$(VERBOSE)" = "true" ]; then \
		$(SCRIPTS_DIR)/marp_tools.sh md-to-marp \
			--project-dir $(THEME_DIR) \
			--logo-left "$(LOGO_LEFT)" --logo-right "$(LOGO_RIGHT)" \
			--background "$(BACKGROUND)" --header $(HEADER_TEXT) --footer $(FOOTER_TEXT) -v; \
	else \
		$(SCRIPTS_DIR)/marp_tools.sh md-to-marp \
			--project-dir $(THEME_DIR) \
			--logo-left "$(LOGO_LEFT)" --logo-right "$(LOGO_RIGHT)" \
			--background "$(BACKGROUND)" --header $(HEADER_TEXT) --footer $(FOOTER_TEXT); \
	fi

convert: ## Convert Marp files to PDF
	@echo "🔄 Converting Marp to PDF..."
	@if [ "$(VERBOSE)" = "true" ]; then \
		$(SCRIPTS_DIR)/marp_tools.sh convert --project-dir $(PWD)/$(THEME_DIR) -v; \
	else \
		$(SCRIPTS_DIR)/marp_tools.sh convert --project-dir $(PWD)/$(THEME_DIR); \
	fi

all: ## Convert everything: MD -> Marp -> PDF with logos/headers/footers
	@echo "🔄 Converting everything: MD -> Marp -> PDF with logos, headers, and footers..."
	@skip_marp_conversion=false; \
	if [ "$(FORCE)" != "true" ] && [ -d "$(THEME_DIR)/presentation/marp_slides" ] && [ -n "$$(ls -A $(THEME_DIR)/presentation/marp_slides 2>/dev/null)" ]; then \
		echo "⚠️  WARNING: Files exist in $(THEME_DIR)/presentation/marp_slides/"; \
		echo "   This command will overwrite existing Marp files, including any manual adjustments."; \
		echo ""; \
		read -p "Do you want to overwrite marp_slides? (y/N): " confirm && \
		if [ "$$confirm" != "y" ] && [ "$$confirm" != "Y" ]; then \
			echo "⏭️  Skipping marp_slides generation, will continue with PDF generation using existing files..."; \
			skip_marp_conversion=true; \
		fi; \
	fi; \
	make copy-images; \
	if [ "$$skip_marp_conversion" = "false" ]; then \
		if [ "$(VERBOSE)" = "true" ]; then \
			$(SCRIPTS_DIR)/marp_tools.sh md-to-marp --project-dir $(PWD)/$(THEME_DIR) \
				--logo-left "$(LOGO_LEFT)" --logo-right "$(LOGO_RIGHT)" \
				--background "$(BACKGROUND)" --header $(HEADER_TEXT) --footer $(FOOTER_TEXT) -v; \
		else \
			$(SCRIPTS_DIR)/marp_tools.sh md-to-marp --project-dir $(PWD)/$(THEME_DIR) \
				--logo-left "$(LOGO_LEFT)" --logo-right "$(LOGO_RIGHT)" \
				--background "$(BACKGROUND)" --header $(HEADER_TEXT) --footer $(FOOTER_TEXT); \
		fi; \
	fi; \
	if [ "$(VERBOSE)" = "true" ]; then \
		$(SCRIPTS_DIR)/marp_tools.sh convert --project-dir $(PWD)/$(THEME_DIR) -v; \
		$(SCRIPTS_DIR)/marp_tools.sh convert-program --project-dir $(PWD)/$(THEME_DIR) -v; \
	else \
		$(SCRIPTS_DIR)/marp_tools.sh convert --project-dir $(PWD)/$(THEME_DIR); \
		$(SCRIPTS_DIR)/marp_tools.sh convert-program --project-dir $(PWD)/$(THEME_DIR); \
	fi

watch: ## Watch mode (auto-regenerate)
	@echo "👀 Starting watch mode..."
	@echo "Press Ctrl+C to exit"
	@$(SCRIPTS_DIR)/marp_tools.sh watch --project-dir $(PWD)/$(THEME_DIR)

config: ## Show current configuration
	@echo "📋 Current configuration:"
	@$(SCRIPTS_DIR)/marp_tools.sh config

validate: ## Validate configuration
	@echo "🔍 Validating configuration..."
	@$(SCRIPTS_DIR)/marp_tools.sh validate

create-theme: ## Create new theme (use: make create-theme NAME=my-theme)
	@if [ -z "$(NAME)" ]; then \
		echo "❌ Error: Specify theme name with NAME=my-theme"; \
		echo "Example: make create-theme NAME=fine-tuning"; \
		exit 1; \
	fi
	@echo "🚀 Creating theme: $(NAME)"
	@$(SCRIPTS_DIR)/create_theme_template.sh $(NAME)
	@echo "✅ Theme '$(NAME)' created successfully in themes/$(NAME)/"
	@echo "Next steps:"
	@echo "  make all THEME=$(NAME)"
	@echo "  make watch THEME=$(NAME)"

clean: ## Clean PDF files only (preserves marp_slides)
	@echo "🧹 Cleaning PDF files only..."
	@if [ -d "$(THEME_DIR)/presentation/pdf_slides" ]; then \
		echo "  Removing $(THEME_DIR)/presentation/pdf_slides/"; \
		rm -rf $(THEME_DIR)/presentation/pdf_slides/*; \
	fi
	@if [ -f "$(THEME_DIR)/program.pdf" ]; then \
		echo "  Removing $(THEME_DIR)/program.pdf"; \
		rm -f $(THEME_DIR)/program.pdf; \
	fi
	@echo "✅ PDF cleanup completed (marp_slides preserved)"

clean-marp: ## Clean marp_slides with confirmation
	@echo "⚠️  WARNING: This will remove ALL files in marp_slides/"
	@echo "   This includes any manual adjustments you may have made."
	@echo ""
	@if [ "$(FORCE)" != "true" ]; then \
		read -p "Are you sure you want to continue? (y/N): " confirm && \
		if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
			if [ -d "$(THEME_DIR)/presentation/marp_slides" ]; then \
				echo "  Removing $(THEME_DIR)/presentation/marp_slides/"; \
				rm -rf $(THEME_DIR)/presentation/marp_slides/*; \
			fi; \
			echo "✅ Marp slides cleanup completed"; \
		else \
			echo "❌ Cleanup cancelled"; \
		fi; \
	else \
		if [ -d "$(THEME_DIR)/presentation/marp_slides" ]; then \
			echo "  Removing $(THEME_DIR)/presentation/marp_slides/"; \
			rm -rf $(THEME_DIR)/presentation/marp_slides/*; \
		fi; \
		echo "✅ Marp slides cleanup completed (forced)"; \
	fi

clean-all: ## Clean all generated files with confirmation
	@echo "⚠️  WARNING: This will remove ALL generated files including marp_slides/"
	@echo "   This includes any manual adjustments you may have made."
	@echo ""
	@if [ "$(FORCE)" != "true" ]; then \
		read -p "Are you sure you want to continue? (y/N): " confirm && \
		if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
			echo "🧹 Cleaning all generated files..."; \
			if [ -d "$(THEME_DIR)/presentation/marp_slides" ]; then \
				echo "  Removing $(THEME_DIR)/presentation/marp_slides/"; \
				rm -rf $(THEME_DIR)/presentation/marp_slides/*; \
			fi; \
			if [ -d "$(THEME_DIR)/presentation/pdf_slides" ]; then \
				echo "  Removing $(THEME_DIR)/presentation/pdf_slides/"; \
				rm -rf $(THEME_DIR)/presentation/pdf_slides/*; \
			fi; \
			if [ -f "$(THEME_DIR)/program.pdf" ]; then \
				echo "  Removing $(THEME_DIR)/program.pdf"; \
				rm -f $(THEME_DIR)/program.pdf; \
			fi; \
			echo "✅ Complete cleanup finished"; \
		else \
			echo "❌ Cleanup cancelled"; \
		fi; \
	else \
		echo "🧹 Cleaning all generated files (forced)..."; \
		if [ -d "$(THEME_DIR)/presentation/marp_slides" ]; then \
			echo "  Removing $(THEME_DIR)/presentation/marp_slides/"; \
			rm -rf $(THEME_DIR)/presentation/marp_slides/*; \
		fi; \
		if [ -d "$(THEME_DIR)/presentation/pdf_slides" ]; then \
			echo "  Removing $(THEME_DIR)/presentation/pdf_slides/"; \
			rm -rf $(THEME_DIR)/presentation/pdf_slides/*; \
		fi; \
		if [ -f "$(THEME_DIR)/program.pdf" ]; then \
			echo "  Removing $(THEME_DIR)/program.pdf"; \
			rm -f $(THEME_DIR)/program.pdf; \
		fi; \
		echo "✅ Complete cleanup finished (forced)"; \
	fi

status: ## Show file status
	@echo "📊 File status for theme '$(THEME)':"
	@echo ""
	@echo "Source MD files:"
	@if [ -d "$(THEME)/presentation/md_src" ]; then \
		ls -la $(THEME)/presentation/md_src/ 2>/dev/null || echo "  Not found"; \
	else \
		echo "  Directory does not exist"; \
	fi
	@echo ""
	@echo "Marp files:"
	@if [ -d "$(THEME)/presentation/marp_slides" ]; then \
		ls -la $(THEME)/presentation/marp_slides/ 2>/dev/null || echo "  Empty"; \
	else \
		echo "  Directory does not exist"; \
	fi
	@echo ""
	@echo "PDF files:"
	@if [ -d "$(THEME)/presentation/pdf_slides" ]; then \
		ls -la $(THEME)/presentation/pdf_slides/ 2>/dev/null || echo "  Empty"; \
	else \
		echo "  Directory does not exist"; \
	fi
	@echo ""
	@echo "Images:"
	@if [ -d "$(THEME)/presentation/img_src" ]; then \
		ls -la $(THEME)/presentation/img_src/ 2>/dev/null || echo "  Empty"; \
	else \
		echo "  Directory does not exist"; \
	fi

list-themes: ## List all available themes/projects
	@echo "📋 Available themes/projects:"
	@for dir in */; do \
		if [ -d "$$dir/presentation" ]; then \
			echo "  $$(basename $$dir)"; \
		fi; \
	done

images: ## Show available images
	@echo "🖼️  Available images in theme '$(THEME)':"
	@if [ -d "$(IMG_SRC_DIR)" ]; then \
		ls -la $(IMG_SRC_DIR)/ 2>/dev/null || echo "  No images"; \
	else \
		echo "  Image directory does not exist"; \
	fi

copy-images: ## Copy images to working directory
	@echo "📋 Copying images..."
	@if [ -d "$(IMG_SRC_DIR)" ]; then \
		mkdir -p $(THEME_DIR)/presentation/marp_slides/images; \
		cp -r $(IMG_SRC_DIR)/* $(THEME_DIR)/presentation/marp_slides/images/ 2>/dev/null || true; \
		echo "✅ Images copied to marp_slides/images/"; \
	else \
		echo "❌ No image directory"; \
	fi

open-pdfs: ## Open program.pdf and all PDFs in pdf_slides directory
	@echo "📖 Opening PDF files for theme '$(THEME)'..."
	@pdf_count=0; \
	if [ -f "$(THEME_DIR)/program.pdf" ]; then \
		echo "  Opening $(THEME_DIR)/program.pdf"; \
		if command -v xdg-open >/dev/null 2>&1; then \
			xdg-open "$(THEME_DIR)/program.pdf" 2>/dev/null & \
		elif command -v evince >/dev/null 2>&1; then \
			evince "$(THEME_DIR)/program.pdf" 2>/dev/null & \
		elif command -v okular >/dev/null 2>&1; then \
			okular "$(THEME_DIR)/program.pdf" 2>/dev/null & \
		elif command -v firefox >/dev/null 2>&1; then \
			firefox "$(THEME_DIR)/program.pdf" 2>/dev/null & \
		else \
			echo "❌ No PDF viewer found. Install evince, okular, or another PDF viewer."; \
		fi; \
		pdf_count=$$((pdf_count + 1)); \
	else \
		echo "  ⚠️  program.pdf not found in $(THEME_DIR)/"; \
	fi; \
	if [ -d "$(THEME_DIR)/presentation/pdf_slides" ] && [ -n "$$(ls -A $(THEME_DIR)/presentation/pdf_slides/*.pdf 2>/dev/null)" ]; then \
		for pdf in $(THEME_DIR)/presentation/pdf_slides/*.pdf; do \
			if [ -f "$$pdf" ]; then \
				echo "  Opening $$pdf"; \
				if command -v xdg-open >/dev/null 2>&1; then \
					xdg-open "$$pdf" 2>/dev/null & \
				elif command -v evince >/dev/null 2>&1; then \
					evince "$$pdf" 2>/dev/null & \
				elif command -v okular >/dev/null 2>&1; then \
					okular "$$pdf" 2>/dev/null & \
				elif command -v firefox >/dev/null 2>&1; then \
					firefox "$$pdf" 2>/dev/null & \
				fi; \
				pdf_count=$$((pdf_count + 1)); \
			fi; \
		done; \
	else \
		echo "  ⚠️  No PDFs found in $(THEME_DIR)/presentation/pdf_slides/"; \
	fi; \
	if [ $$pdf_count -eq 0 ]; then \
		echo "❌ No PDF files found. Run 'make all' first to generate PDFs."; \
	else \
		echo "✅ Opened $$pdf_count PDF file(s)"; \
	fi

# Logo and styling management
default-logos: ## Create default logo placeholders
	@echo "🎨 Creating default logo placeholders..."
	@mkdir -p $(IMG_SRC_DIR)
	@if [ ! -f "$(IMG_SRC_DIR)/logo_left.png" ]; then \
		echo "Creating left logo placeholder..."; \
		convert -size 200x100 xc:lightblue -pointsize 20 -fill black -gravity center -annotate +0+0 "LOGO LEFT" $(IMG_SRC_DIR)/logo_left.png 2>/dev/null || \
		echo "ImageMagick not available, creating text file instead"; \
		echo "LOGO LEFT PLACEHOLDER" > $(IMG_SRC_DIR)/logo_left.txt; \
	fi
	@if [ ! -f "$(IMG_SRC_DIR)/logo_right.png" ]; then \
		echo "Creating right logo placeholder..."; \
		convert -size 200x100 xc:lightgreen -pointsize 20 -fill black -gravity center -annotate +0+0 "LOGO RIGHT" $(IMG_SRC_DIR)/logo_right.png 2>/dev/null || \
		echo "ImageMagick not available, creating text file instead"; \
		echo "LOGO RIGHT PLACEHOLDER" > $(IMG_SRC_DIR)/logo_right.txt; \
	fi
	@if [ ! -f "$(IMG_SRC_DIR)/background.png" ]; then \
		echo "Creating background placeholder..."; \
		convert -size 800x600 gradient:blue-purple -pointsize 30 -fill white -gravity center -annotate +0+0 "BACKGROUND" $(IMG_SRC_DIR)/background.png 2>/dev/null || \
		echo "ImageMagick not available, creating text file instead"; \
		echo "BACKGROUND PLACEHOLDER" > $(IMG_SRC_DIR)/background.txt; \
	fi
	@echo "✅ Default placeholders created in $(IMG_SRC_DIR)/"

show-config: ## Show current logo/header/footer configuration
	@echo "⚙️  Current configuration for theme '$(THEME)':"
	@echo ""
	@echo "Logos:"
	@echo "  Left logo:  $(LOGO_LEFT)"
	@echo "  Right logo: $(LOGO_RIGHT)"
	@echo "  Background: $(BACKGROUND)"
	@echo ""
	@echo "Text:"
	@echo "  Header: $(HEADER_TEXT)"
	@echo "  Footer: $(FOOTER_TEXT)"
	@echo ""
	@echo "Files exist:"
	@[ -f "$(LOGO_LEFT)" ] && echo "  ✓ Left logo exists" || echo "  ✗ Left logo missing"
	@[ -f "$(LOGO_RIGHT)" ] && echo "  ✓ Right logo exists" || echo "  ✗ Right logo missing"
	@[ -f "$(BACKGROUND)" ] && echo "  ✓ Background exists" || echo "  ✗ Background missing"

custom: ## Convert with custom logos/headers/footers (interactive)
	@echo "🎨 Custom conversion with interactive configuration..."
	@echo ""
	@if [ "$(FORCE)" = "true" ]; then \
		echo "Using default values (FORCE mode)"; \
		left_logo="$(LOGO_LEFT)"; \
		right_logo="$(LOGO_RIGHT)"; \
		bg_image="$(BACKGROUND)"; \
		header_text="$(HEADER_TEXT)"; \
		footer_text="$(FOOTER_TEXT)"; \
	else \
		read -p "Left logo path [$(LOGO_LEFT)]: " left_logo; \
		left_logo=$${left_logo:-$(LOGO_LEFT)}; \
		read -p "Right logo path [$(LOGO_RIGHT)]: " right_logo; \
		right_logo=$${right_logo:-$(LOGO_RIGHT)}; \
		read -p "Background image path [$(BACKGROUND)]: " bg_image; \
		bg_image=$${bg_image:-$(BACKGROUND)}; \
		read -p "Header text [$(HEADER_TEXT)]: " header_text; \
		header_text=$${header_text:-$(HEADER_TEXT)}; \
		read -p "Footer text [$(FOOTER_TEXT)]: " footer_text; \
		footer_text=$${footer_text:-$(FOOTER_TEXT)}; \
	fi; \
	echo ""; \
	echo "🔄 Converting with custom settings..."; \
	$(SCRIPTS_DIR)/marp_tools.sh md-to-marp --project-dir $(PWD)/$(THEME_DIR) \
		--logo-left "$$left_logo" --logo-right "$$right_logo" \
		--background "$$bg_image" --header "$$header_text" --footer "$$footer_text"; \
	$(SCRIPTS_DIR)/marp_tools.sh convert --project-dir $(PWD)/$(THEME_DIR); \
	$(SCRIPTS_DIR)/marp_tools.sh convert-program --project-dir $(PWD)/$(THEME_DIR); \
	echo "✅ Custom conversion completed!"

# Development commands
dev-setup: ## Complete setup for development
	@echo "🛠️  Development setup..."
	@make setup
	@make validate
	@echo "✅ Development setup completed"

test: ## Test scripts with example theme
	@echo "🧪 Testing scripts..."
	@make create-theme NAME=test-theme
	@make all THEME=test-theme
	@echo "✅ Test completed"
	@echo "Generated files in themes/test-theme/presentation/pdf_slides/"

# Specific help commands
help-scripts: ## Show scripts help
	@echo "📖 Marp scripts help:"
	@$(SCRIPTS_DIR)/marp_tools.sh --help

help-create: ## Show help for creating themes
	@echo "📖 Help for creating themes:"
	@$(SCRIPTS_DIR)/create_theme_template.sh --help

# Information commands
info: ## Show system information
	@echo "ℹ️  System information:"
	@echo "  Current theme: $(THEME)"
	@echo "  Verbose mode: $(VERBOSE)"
	@echo "  Current directory: $(PWD)"
	@echo "  Scripts: $(SCRIPTS_DIR)"
	@echo ""
	@echo "Tools:"
	@which python3 >/dev/null 2>&1 && echo "  Python3: $(shell python3 --version)" || echo "  Python3: Not installed"
	@which node >/dev/null 2>&1 && echo "  Node.js: $(shell node --version)" || echo "  Node.js: Not installed"
	@which marp >/dev/null 2>&1 && echo "  Marp: $(shell marp --version)" || echo "  Marp: Not installed"

# Maintenance commands
update-scripts: ## Update scripts from repository
	@echo "🔄 Updating scripts..."
	@echo "Note: This command assumes scripts are in a Git repository"
	@git pull origin main || echo "Error: Could not update from Git"

# Backup commands
backup: ## Create backup of MD files
	@echo "💾 Creating MD files backup..."
	@mkdir -p backups
	@tar -czf backups/md-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz */presentation/md_src/ */program.md 2>/dev/null || true
	@echo "✅ Backup created in backups/"

# Dependency installation commands
install-deps: ## Install system dependencies
	@echo "📦 Installing system dependencies..."
	@echo "Installing Node.js and npm..."
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get update && sudo apt-get install -y nodejs npm; \
	elif command -v brew >/dev/null 2>&1; then \
		brew install node; \
	else \
		echo "Could not install automatically. Install Node.js manually."; \
	fi
	@make setup
