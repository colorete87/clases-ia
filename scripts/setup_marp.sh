#!/bin/bash

# Script to configure Marp and convert Markdown files to presentations
# Reusable for different projects/themes
# Author: AI Assistant
# Date: $(date)

# Configuration
VERBOSE=false
FORCE=false

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -v, --verbose    Verbose mode"
    echo "  -f, --force      Force Marp CLI reinstallation"
    echo "  -h, --help       Show this help"
    echo ""
    echo "This script installs Marp CLI globally to convert Markdown files to presentations."
    echo ""
}

# Process arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "❌ Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

echo "🚀 Setting up Marp for Markdown to presentation conversion..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first:"
    echo "   https://nodejs.org/"
    echo ""
    echo "💡 On Ubuntu/Debian: sudo apt install nodejs npm"
    echo "💡 On macOS: brew install node"
    echo "💡 On Windows: Download from https://nodejs.org/"
    exit 1
fi

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not available. Please install npm first."
    exit 1
fi

if [ "$VERBOSE" = true ]; then
    echo "✅ Node.js version: $(node --version)"
    echo "✅ npm version: $(npm --version)"
fi

# Check if Marp is already installed
if command -v marp &> /dev/null && [ "$FORCE" = false ]; then
    echo "✅ Marp CLI is already installed: $(marp --version)"
    echo "💡 Use -f or --force to reinstall"
    echo ""
    echo "🎉 Marp is ready to use!"
    show_usage_info
    exit 0
fi

# Install Marp CLI globally
echo "📦 Installing Marp CLI..."
if [ "$FORCE" = true ]; then
    echo "🔄 Reinstalling Marp CLI..."
    npm uninstall -g @marp-team/marp-cli 2>/dev/null || true
fi

npm install -g @marp-team/marp-cli

if [ $? -eq 0 ]; then
    echo "✅ Marp CLI installed successfully"
else
    echo "❌ Error installing Marp CLI"
    echo "💡 Try running: sudo npm install -g @marp-team/marp-cli"
    exit 1
fi

# Verify installation
echo "🔍 Verifying installation..."
marp --version

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Marp is ready to use!"
    show_usage_info
else
    echo "❌ Error verifying Marp installation"
    exit 1
fi

# Function to show usage information
show_usage_info() {
    echo ""
    echo "📝 Useful Marp commands:"
    echo "   marp file.md --pdf          # Generate PDF"
    echo "   marp file.md --html         # Generate HTML"
    echo "   marp file.md --pptx         # Generate PowerPoint"
    echo "   marp file.md --watch        # Watch mode (auto-regenerate)"
    echo ""
    echo "🔧 Available scripts in this project:"
    echo "   ./scripts/run_conversion.sh                    # Convert Marp files to PDF"
    echo "   ./scripts/run_conversion.sh -h                 # View script help"
    echo "   ./scripts/run_conversion.sh -i slides -o pdf   # Custom directories"
    echo ""
    echo "📁 Typical folder structure:"
    echo "   - marp_slides/: Marp files (.md)"
    echo "   - pdf_slides/: Generated PDF files"
    echo "   - scripts/: Conversion scripts"
    echo ""
    echo "💡 To use in other projects:"
    echo "   1. Copy the scripts/ folder to your new project"
    echo "   2. Run: ./scripts/setup_marp.sh"
    echo "   3. Run: ./scripts/run_conversion.sh"
    echo ""
}
