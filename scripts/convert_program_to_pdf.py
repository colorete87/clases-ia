#!/usr/bin/env python3
"""
Standalone script to convert program.md to program.pdf
Independent from Marp - uses markdown + weasyprint for PDF generation
Supports theme-specific styling via program.css files
"""

import os
import sys
import argparse
import markdown
from pathlib import Path
from datetime import datetime

def find_program_css(theme_path):
    """Find program.css file in theme directory"""
    css_locations = [
        theme_path / "program.css",
        theme_path / "presentation" / "program.css",
        theme_path / "styles" / "program.css"
    ]
    
    for css_path in css_locations:
        if css_path.exists():
            return css_path
    
    return None

def get_default_css():
    """Return default CSS for program styling"""
    return """
/* Default Program Styling - A4 Format */
@page {
    size: 210mm 297mm;  /* Exact A4 dimensions */
    margin: 15mm 20mm;  /* A4 theme margins */
    @top-center {
        content: "Course Program";
        font-family: Arial, sans-serif;
        font-size: 7pt;  /* A4 theme font size */
        color: #666;
    }
    @bottom-center {
        content: "Page " counter(page) " of " counter(pages);
        font-family: Arial, sans-serif;
        font-size: 6pt;  /* A4 theme font size */
        color: #666;
    }
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-size: 9pt;  /* A4 theme font size */
    line-height: 1.3;  /* A4 theme line height */
    color: #333;
    max-width: none;
    margin: 0;
    padding: 15mm 20mm;  /* A4 theme padding */
}

/* Headers */
h1 {
    font-size: 24pt;
    font-weight: bold;
    color: #2c3e50;
    margin-top: 0;
    margin-bottom: 20pt;
    border-bottom: 3pt solid #3498db;
    padding-bottom: 10pt;
    page-break-after: avoid;
}

h2 {
    font-size: 18pt;
    font-weight: bold;
    color: #34495e;
    margin-top: 25pt;
    margin-bottom: 15pt;
    page-break-after: avoid;
    border-left: 4pt solid #e74c3c;
    padding-left: 15pt;
}

h3 {
    font-size: 14pt;
    font-weight: bold;
    color: #2c3e50;
    margin-top: 20pt;
    margin-bottom: 12pt;
    page-break-after: avoid;
}

h4, h5, h6 {
    font-size: 12pt;
    font-weight: bold;
    color: #34495e;
    margin-top: 15pt;
    margin-bottom: 10pt;
    page-break-after: avoid;
}

/* Paragraphs */
p {
    margin-bottom: 12pt;
    text-align: justify;
    orphans: 2;
    widows: 2;
}

/* Lists */
ul, ol {
    margin-bottom: 15pt;
    padding-left: 25pt;
}

li {
    margin-bottom: 6pt;
    line-height: 1.5;
}

/* Nested lists */
ul ul, ol ol, ul ol, ol ul {
    margin-top: 6pt;
    margin-bottom: 6pt;
}

/* Strong and emphasis */
strong, b {
    font-weight: bold;
    color: #2c3e50;
}

em, i {
    font-style: italic;
    color: #7f8c8d;
}

/* Code */
code {
    font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
    background-color: #f8f9fa;
    padding: 2pt 4pt;
    border-radius: 3pt;
    font-size: 10pt;
    color: #e74c3c;
}

pre {
    background-color: #f8f9fa;
    border: 1pt solid #dee2e6;
    border-radius: 5pt;
    padding: 15pt;
    margin: 15pt 0;
    font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
    font-size: 10pt;
    line-height: 1.4;
    overflow-x: auto;
    page-break-inside: avoid;
}

/* Blockquotes */
blockquote {
    border-left: 4pt solid #3498db;
    margin: 20pt 0;
    padding: 10pt 20pt;
    background-color: #f8f9fa;
    font-style: italic;
    color: #555;
    page-break-inside: avoid;
}

/* Tables */
table {
    width: 100%;
    border-collapse: collapse;
    margin: 20pt 0;
    page-break-inside: avoid;
}

th, td {
    border: 1pt solid #dee2e6;
    padding: 8pt 12pt;
    text-align: left;
    vertical-align: top;
}

th {
    background-color: #f8f9fa;
    font-weight: bold;
    color: #2c3e50;
}

/* Horizontal rules */
hr {
    border: none;
    height: 2pt;
    background: linear-gradient(90deg, #3498db, #e74c3c);
    margin: 25pt 0;
    page-break-after: avoid;
}

/* Links */
a {
    color: #3498db;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

/* Print-specific styles */
@media print {
    body {
        font-size: 11pt;
    }
    
    h1 {
        page-break-before: auto;
    }
    
    h2, h3, h4, h5, h6 {
        page-break-after: avoid;
    }
    
    img {
        max-width: 100%;
        page-break-inside: avoid;
    }
    
    pre, blockquote {
        page-break-inside: avoid;
    }
}

/* Special classes for program structure */
.section-info {
    background-color: #e8f4f8;
    border: 1pt solid #3498db;
    border-radius: 5pt;
    padding: 15pt;
    margin: 20pt 0;
    page-break-inside: avoid;
}

.objectives {
    background-color: #f0f8e8;
    border: 1pt solid #27ae60;
    border-radius: 5pt;
    padding: 15pt;
    margin: 20pt 0;
}

.prerequisites {
    background-color: #fdf2e8;
    border: 1pt solid #f39c12;
    border-radius: 5pt;
    padding: 15pt;
    margin: 20pt 0;
}

.contact-info {
    background-color: #f8f0ff;
    border: 1pt solid #9b59b6;
    border-radius: 5pt;
    padding: 15pt;
    margin: 20pt 0;
}

/* Emoji support */
.emoji {
    font-family: 'Apple Color Emoji', 'Segoe UI Emoji', 'Noto Color Emoji', sans-serif;
    font-size: 1.2em;
    vertical-align: middle;
}
"""

def convert_program_to_pdf(theme_path, output_path=None, verbose=False):
    """Convert program.md to PDF using theme-specific styling"""
    
    theme_path = Path(theme_path)
    program_md_path = theme_path / "program.md"
    
    if not program_md_path.exists():
        raise FileNotFoundError(f"program.md not found in {theme_path}")
    
    # Determine output path
    if output_path is None:
        output_path = theme_path / "program.pdf"
    else:
        output_path = Path(output_path)
    
    if verbose:
        print(f"Converting {program_md_path} to {output_path}")
    
    # Read markdown content
    with open(program_md_path, 'r', encoding='utf-8') as f:
        markdown_content = f.read()
    
    # Convert markdown to HTML
    md = markdown.Markdown(extensions=[
        'extra',           # Tables, footnotes, etc.
        'codehilite',      # Syntax highlighting
        'toc',             # Table of contents
        'attr_list',       # Attribute lists
        'def_list',        # Definition lists
        'abbr',            # Abbreviations
        'footnotes',       # Footnotes
        'md_in_html'       # Markdown inside HTML
    ])
    
    html_content = md.convert(markdown_content)
    
    # Find and load CSS
    program_css_path = find_program_css(theme_path)
    
    if program_css_path and verbose:
        print(f"Using CSS from: {program_css_path}")
    elif verbose:
        print("Using default CSS styling")
    
    if program_css_path:
        with open(program_css_path, 'r', encoding='utf-8') as f:
            css_content = f.read()
    else:
        css_content = get_default_css()
    
    # Create complete HTML document
    html_document = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Program</title>
    <style>
        {css_content}
    </style>
</head>
<body>
    {html_content}
</body>
</html>"""
    
    # Convert HTML to PDF using weasyprint
    try:
        from weasyprint import HTML, CSS
        from weasyprint.text.fonts import FontConfiguration
        
        font_config = FontConfiguration()
        
        # Create HTML object
        html_obj = HTML(string=html_document)
        
        # Generate PDF
        html_obj.write_pdf(
            str(output_path),
            font_config=font_config,
            optimize_images=True
        )
        
        if verbose:
            print(f"PDF generated successfully: {output_path}")
        
        return True
        
    except ImportError:
        print("Error: weasyprint is not installed.")
        print("Please install it with: pip install weasyprint")
        print("Alternative: pip install pdfkit (requires wkhtmltopdf)")
        return False
        
    except Exception as e:
        print(f"Error generating PDF: {e}")
        
        # Fallback to pdfkit if weasyprint fails
        try:
            import pdfkit
            
            options = {
                'page-size': 'A4',
                'margin-top': '2.5cm',
                'margin-right': '2.5cm',
                'margin-bottom': '2.5cm',
                'margin-left': '2.5cm',
                'encoding': "UTF-8",
                'no-outline': None,
                'enable-local-file-access': None
            }
            
            pdfkit.from_string(html_document, str(output_path), options=options)
            
            if verbose:
                print(f"PDF generated successfully using pdfkit: {output_path}")
            
            return True
            
        except ImportError:
            print("Error: Neither weasyprint nor pdfkit is available.")
            print("Please install one of them:")
            print("  pip install weasyprint")
            print("  pip install pdfkit (requires wkhtmltopdf)")
            return False
            
        except Exception as e2:
            print(f"Error with pdfkit fallback: {e2}")
            return False

def main():
    """Main function"""
    parser = argparse.ArgumentParser(
        description="Convert program.md to PDF with theme-specific styling",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s themes/example
  %(prog)s themes/fine-tuning --output /tmp/program.pdf
  %(prog)s themes/my-theme --verbose
        """
    )
    
    parser.add_argument(
        'theme_path',
        help='Path to theme directory containing program.md'
    )
    
    parser.add_argument(
        '-o', '--output',
        help='Output PDF path (default: theme_path/program.pdf)'
    )
    
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Enable verbose output'
    )
    
    args = parser.parse_args()
    
    try:
        success = convert_program_to_pdf(
            theme_path=args.theme_path,
            output_path=args.output,
            verbose=args.verbose
        )
        
        if success:
            print("Conversion completed successfully!")
            sys.exit(0)
        else:
            print("Conversion failed!")
            sys.exit(1)
            
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
