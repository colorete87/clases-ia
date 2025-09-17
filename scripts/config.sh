#!/bin/bash

# Configuration file for Marp scripts
# Reusable for different projects/themes
# Author: AI Assistant

# =============================================================================
# DEFAULT CONFIGURATION
# =============================================================================

# Default directory structure
DEFAULT_MD_SRC_DIR="presentation/md_src"
DEFAULT_MARP_SLIDES_DIR="presentation/marp_slides"
DEFAULT_PDF_SLIDES_DIR="presentation/pdf_slides"
DEFAULT_IMG_SRC_DIR="presentation/img_src"
DEFAULT_STYLE_CSS="presentation/style.css"
DEFAULT_PROGRAMA="program.md"

# Default directories (for compatibility)
DEFAULT_INPUT_DIR="$DEFAULT_MARP_SLIDES_DIR"
DEFAULT_OUTPUT_DIR="$DEFAULT_PDF_SLIDES_DIR"
DEFAULT_THEME=""

# Marp configuration
MARP_OPTIONS="--pdf"
MARP_HTML_OPTIONS="--html"
MARP_PPTX_OPTIONS="--pptx"

# Logo and background configuration
DEFAULT_LOGO_LEFT=""
DEFAULT_LOGO_RIGHT=""
DEFAULT_BACKGROUND=""

# Header and footer configuration
DEFAULT_HEADER_TEXT=""
DEFAULT_FOOTER_TEXT=""

# Python configuration
PYTHON_CMD="python3"

# Node.js configuration
NPM_CMD="npm"
MARP_PACKAGE="@marp-team/marp-cli"

# =============================================================================
# PROJECT-SPECIFIC CONFIGURATION
# =============================================================================

# You can override the default configurations here
# Example:
# DEFAULT_INPUT_DIR="presentations"
# DEFAULT_OUTPUT_DIR="pdfs"
# DEFAULT_THEME="custom-theme"

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Function to load configuration from file
load_config() {
    local config_file="$1"
    
    if [ -f "$config_file" ]; then
        echo "📁 Loading configuration from: $config_file"
        source "$config_file"
    else
        echo "⚠️  Configuration file not found: $config_file"
        echo "   Using default configuration"
    fi
}

# Function to show current configuration
show_config() {
    echo "📋 Current configuration:"
    echo "   Directory structure:"
    echo "     - MD source: $DEFAULT_MD_SRC_DIR"
    echo "     - Marp slides: $DEFAULT_MARP_SLIDES_DIR"
    echo "     - PDF slides: $DEFAULT_PDF_SLIDES_DIR"
    echo "     - Images: $DEFAULT_IMG_SRC_DIR"
    echo "     - CSS styles: $DEFAULT_STYLE_CSS"
    echo "     - Program: $DEFAULT_PROGRAMA"
    echo "   Theme: ${DEFAULT_THEME:-default}"
    echo "   Python command: $PYTHON_CMD"
    echo "   npm command: $NPM_CMD"
    echo "   Marp package: $MARP_PACKAGE"
    echo ""
}

# Function to validate configuration
validate_config() {
    local errors=0
    
    # Check if Python is available
    if ! command -v "$PYTHON_CMD" &> /dev/null; then
        echo "❌ Error: $PYTHON_CMD is not available"
        errors=$((errors + 1))
    fi
    
    # Check if npm is available
    if ! command -v "$NPM_CMD" &> /dev/null; then
        echo "❌ Error: $NPM_CMD is not available"
        errors=$((errors + 1))
    fi
    
    # Check if Marp is installed
    if ! command -v marp &> /dev/null; then
        echo "⚠️  Warning: Marp CLI is not installed"
        echo "   Run: ./scripts/setup_marp.sh"
    fi
    
    if [ $errors -gt 0 ]; then
        echo "❌ Found $errors errors in configuration"
        return 1
    else
        echo "✅ Configuration is valid"
        return 0
    fi
}

# Function to create example configuration file
create_example_config() {
    local example_file="$1"
    
    cat > "$example_file" << 'EOF'
#!/bin/bash

# Example configuration file for Marp scripts
# Copy this file and modify according to your needs

# Custom directories
DEFAULT_INPUT_DIR="my_presentations"
DEFAULT_OUTPUT_DIR="my_pdfs"
DEFAULT_THEME="my_custom_theme"

# Additional Marp options
MARP_OPTIONS="--pdf --allow-local-files"
MARP_HTML_OPTIONS="--html --allow-local-files"
MARP_PPTX_OPTIONS="--pptx --allow-local-files"

# Python configuration (if using virtual environment)
# PYTHON_CMD="/path/to/venv/bin/python"

# Node.js configuration (if using nvm or similar)
# NPM_CMD="/path/to/npm"
# MARP_PACKAGE="@marp-team/marp-cli"
EOF

    echo "📝 Example configuration file created: $example_file"
    echo "   Edit the file according to your needs"
}

# =============================================================================
# AUTOMATIC CONFIGURATION
# =============================================================================

# Search for project configuration file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Load project configuration if it exists
# Priority: 1) theme-example theme, 2) project root
if [ -f "$PROJECT_DIR/themes/theme-example/marp.config.sh" ]; then
    PROJECT_CONFIG="$PROJECT_DIR/themes/theme-example/marp.config.sh"
elif [ -f "$PROJECT_DIR/marp.config.sh" ]; then
    PROJECT_CONFIG="$PROJECT_DIR/marp.config.sh"
else
    PROJECT_CONFIG="$PROJECT_DIR/marp.config.sh"
fi
load_config "$PROJECT_CONFIG"

# Show configuration if requested
if [ "${1:-}" = "--show-config" ]; then
    show_config
    exit 0
fi

# Validate configuration if requested
if [ "${1:-}" = "--validate" ]; then
    validate_config
    exit $?
fi

# Create example file if requested
if [ "${1:-}" = "--create-example" ]; then
    create_example_config "$PROJECT_DIR/marp.config.example.sh"
    exit 0
fi
