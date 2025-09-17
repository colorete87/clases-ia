# Program PDF Conversion

This directory contains a standalone script for converting `program.md` files to PDF format, completely independent from the Marp-based slide conversion system.

## Features

- **Standalone conversion**: Converts `program.md` to `program.pdf` without using Marp
- **Theme-specific styling**: Uses `program.css` files for custom styling (separate from slide `style.css`)
- **Professional formatting**: Optimized for document-style PDFs with proper page breaks, headers, and footers
- **Multiple PDF engines**: Supports both WeasyPrint and pdfkit as backends
- **Markdown extensions**: Full support for tables, code blocks, footnotes, and more

## Files

- `convert_program_to_pdf.py` - Main conversion script
- `setup_program_pdf.sh` - Setup script to install dependencies
- `requirements-program-pdf.txt` - Python package requirements
- `README_PROGRAM_PDF.md` - This documentation

## Installation

### Option 1: Automatic Setup
```bash
./scripts/setup_program_pdf.sh
```

### Option 2: Manual Installation
```bash
# Install required packages
pip install markdown weasyprint

# Alternative if weasyprint fails
pip install pdfkit  # Requires wkhtmltopdf system package
```

### System Dependencies

For **WeasyPrint** (recommended):
- Usually works out of the box on most systems
- Better CSS support and rendering quality

For **pdfkit** (fallback):
```bash
# Ubuntu/Debian
sudo apt-get install wkhtmltopdf

# CentOS/RHEL/Fedora
sudo dnf install wkhtmltopdf  # or yum install wkhtmltopdf

# macOS
brew install wkhtmltopdf
```

## Usage

### Basic Usage
```bash
# Convert program.md in a theme directory
./scripts/convert_program_to_pdf.py themes/example
./scripts/convert_program_to_pdf.py themes/fine-tuning

# Specify custom output path
./scripts/convert_program_to_pdf.py themes/example --output /tmp/my-program.pdf

# Verbose output
./scripts/convert_program_to_pdf.py themes/example --verbose
```

### Help
```bash
./scripts/convert_program_to_pdf.py --help
```

## Styling

The script looks for theme-specific CSS files in this order:

1. `{theme}/program.css`
2. `{theme}/presentation/program.css`
3. `{theme}/styles/program.css`
4. Built-in default styles (if no CSS file found)

### Creating Custom Styles

Create a `program.css` file in your theme directory:

```css
/* Custom program styling */
@page {
    size: A4;
    margin: 2.5cm;
    @top-center {
        content: "My Course Program";
        font-family: Arial, sans-serif;
        font-size: 10pt;
        color: #666;
    }
}

body {
    font-family: 'Arial', sans-serif;
    font-size: 11pt;
    line-height: 1.6;
    color: #333;
}

h1 {
    color: #2c3e50;
    border-bottom: 3pt solid #3498db;
}

/* Add more custom styles... */
```

## Examples

### Example Theme
- **Input**: `themes/example/program.md`
- **Output**: `themes/example/program.pdf`
- **Styling**: `themes/example/program.css`
- **Features**: Gradient colors, modern styling

### Fine-Tuning Theme
- **Input**: `themes/fine-tuning/program.md`
- **Output**: `themes/fine-tuning/program.pdf`
- **Styling**: `themes/fine-tuning/program.css`
- **Features**: Professional layout, Spanish content support

## Supported Markdown Features

- **Headers** (H1-H6) with automatic page break handling
- **Lists** (ordered and unordered, nested)
- **Tables** with styling
- **Code blocks** with syntax highlighting
- **Blockquotes**
- **Links**
- **Emphasis** (bold, italic)
- **Horizontal rules**
- **Footnotes**
- **Definition lists**
- **Abbreviations**
- **Emojis** (with proper font support)

## PDF Features

- **A4 page format** (configurable via CSS)
- **Professional headers/footers** with page numbers
- **Automatic page breaks** with orphan/widow control
- **Print-optimized styling**
- **Bookmarks** (from headers)
- **Proper text justification**
- **Box shadows and gradients** (where supported)

## Troubleshooting

### ImportError: No module named 'markdown'
```bash
pip install markdown
```

### ImportError: No module named 'weasyprint'
```bash
# Try weasyprint first
pip install weasyprint

# If it fails, use pdfkit alternative
pip install pdfkit
# And install wkhtmltopdf system package
```

### CSS not loading
- Check that `program.css` exists in the theme directory
- Use `--verbose` flag to see which CSS file is being used
- Verify CSS syntax is valid

### Poor PDF quality
- WeasyPrint generally produces better results than pdfkit
- Check CSS `@page` settings for margins and sizing
- Ensure fonts are properly specified

### Page breaks issues
- Use `page-break-before`, `page-break-after`, `page-break-inside` CSS properties
- The script includes sensible defaults for headers and content blocks

## Integration with Existing Workflow

This script is designed to work alongside your existing Marp-based slide generation:

1. **Slides**: Use existing Marp workflow with `style.css`
2. **Program document**: Use this script with `program.css`
3. **Both are independent** and use different styling approaches

## Differences from Marp

| Feature | Marp Slides | Program PDF |
|---------|-------------|-------------|
| **Purpose** | Presentation slides | Document/handout |
| **Layout** | Slide-based | Continuous pages |
| **Styling** | `style.css` | `program.css` |
| **Page breaks** | Manual (`---`) | Automatic |
| **Headers/footers** | Per slide | Per page |
| **PDF engine** | Marp/Chromium | WeasyPrint/pdfkit |
| **Markdown extensions** | Basic | Full (tables, footnotes, etc.) |

## Contributing

To add support for new PDF engines or features:

1. Modify `convert_program_to_pdf.py`
2. Add new CSS templates in theme directories
3. Update this documentation
4. Test with existing themes

## License

This script follows the same license as the main project.
