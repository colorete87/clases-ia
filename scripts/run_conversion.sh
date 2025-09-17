#!/bin/bash

# Script to convert Marp files to PDF
# Reusable for different projects/themes
# Author: AI Assistant
# Date: $(date)

# Default configuration
PROJECT_DIR=""
INPUT_DIR="presentation/marp_slides"
OUTPUT_DIR="presentation/pdf_slides"
THEME=""
VERBOSE=false

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -p, --project-dir DIR    Project directory (default: parent directory)"
    echo "  -i, --input DIR          Directory with Marp files (default: presentation/marp_slides)"
    echo "  -o, --output DIR         Output directory for PDFs (default: presentation/pdf_slides)"
    echo "  -t, --theme THEME        CSS theme to use (.css file in scripts/)"
    echo "  -v, --verbose            Verbose mode"
    echo "  -h, --help               Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Use default configuration"
    echo "  $0 -p /path/to/project               # Specify project directory"
    echo "  $0 -i slides -o output -t custom     # Custom directories and theme"
    echo ""
}

# Process arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--project-dir)
            PROJECT_DIR="$2"
            shift 2
            ;;
        -i|--input)
            INPUT_DIR="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -t|--theme)
            THEME="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
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

# Determine project directory
if [ -z "$PROJECT_DIR" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
fi

# Verify that project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Error: Project directory '$PROJECT_DIR' does not exist"
    exit 1
fi

# Save script path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configuration
source "$SCRIPT_DIR/config.sh"

# Load theme-specific configuration
load_theme_config "$PROJECT_DIR"

# Don't change to project directory, work from root directory

if [ "$VERBOSE" = true ]; then
    echo "📁 Project directory: $PROJECT_DIR"
    echo "📁 Input directory: $INPUT_DIR"
    echo "📁 Output directory: $OUTPUT_DIR"
    echo "🎨 Theme: ${THEME:-default}"
    echo ""
fi

echo "🚀 Starting conversion of Marp files to PDF..."
echo ""

# Verify that Marp is installed
if ! command -v marp &> /dev/null; then
    echo "❌ Marp is not installed. Running setup..."
    bash "$(dirname "${BASH_SOURCE[0]}")/setup_marp.sh"
    echo ""
fi

# Create directories if they don't exist
echo "📁 Creating necessary directories..."
mkdir -p "$PROJECT_DIR/$INPUT_DIR" "$PROJECT_DIR/$OUTPUT_DIR"

# Verify that Marp files exist
if [ ! -d "$PROJECT_DIR/$INPUT_DIR" ] || [ -z "$(ls -A "$PROJECT_DIR/$INPUT_DIR"/*.md 2>/dev/null)" ]; then
    echo "❌ No Marp files found in $PROJECT_DIR/$INPUT_DIR/"
    echo "   Make sure .md files are in $PROJECT_DIR/$INPUT_DIR/"
    exit 1
fi

# Convert Marp files to PDF
echo "🔄 Converting Marp files to PDF..."

# Build command with absolute paths
CMD="python3 $SCRIPT_DIR/convert_marp_to_pdf.py"
CMD="$CMD --project-dir '$PROJECT_DIR'"
CMD="$CMD '$INPUT_DIR'"
CMD="$CMD -o '$OUTPUT_DIR'"

if [ -n "$THEME" ]; then
    CMD="$CMD -t '$THEME'"
fi

# Execute command
echo "🔄 Executing: $CMD"
eval $CMD

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Conversion completed!"
    echo ""
    echo "📁 Generated files:"
    echo "   - $INPUT_DIR/: Marp files (input)"
    echo "   - $OUTPUT_DIR/: Generated PDF files"
    echo ""
    echo "📝 To view presentations:"
    echo "   - Open .pdf files in $OUTPUT_DIR/"
    echo "   - Or use: marp $INPUT_DIR/file.md --watch"
    echo ""
else
    echo "❌ Error during conversion"
    exit 1
fi
