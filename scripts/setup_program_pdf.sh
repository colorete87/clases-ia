#!/bin/bash

# Setup script for program PDF conversion
# This script installs the required dependencies and tests the conversion

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== Setting up Program PDF Conversion ==="
echo "Script directory: $SCRIPT_DIR"
echo "Project root: $PROJECT_ROOT"
echo

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed or not in PATH"
    exit 1
fi

echo "Python version: $(python3 --version)"
echo

# Check if pip is available
if ! python3 -m pip --version &> /dev/null; then
    echo "Error: pip is not available for Python 3"
    exit 1
fi

echo "Installing required packages..."
echo

# Install packages
python3 -m pip install --user markdown weasyprint

# Alternative if weasyprint fails (requires wkhtmltopdf)
echo
echo "If weasyprint installation fails, you can install pdfkit as alternative:"
echo "  python3 -m pip install --user pdfkit"
echo "  # And install wkhtmltopdf system package"
echo

echo "=== Testing installation ==="
echo

# Test imports
python3 -c "import markdown; print('✓ markdown imported successfully')"
python3 -c "import weasyprint; print('✓ weasyprint imported successfully')" || {
    echo "⚠ weasyprint import failed, trying pdfkit..."
    python3 -m pip install --user pdfkit || echo "⚠ pdfkit installation failed"
    python3 -c "import pdfkit; print('✓ pdfkit imported successfully')" || echo "⚠ pdfkit import failed"
}

echo
echo "=== Setup complete ==="
echo
echo "You can now use the conversion script:"
echo "  $SCRIPT_DIR/convert_program_to_pdf.py themes/example"
echo "  $SCRIPT_DIR/convert_program_to_pdf.py themes/fine-tuning --verbose"
echo
