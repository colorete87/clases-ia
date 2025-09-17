#!/usr/bin/env python3
"""
Script to convert markdown source files to PDF documents (A4 format)
Processes files from md_src/ and generates pdf_docs/
Ignores slide breaks (----) and creates continuous documents
Uses a4-docs-theme.css for styling
"""

import os
import sys
import argparse
import markdown
import re
from pathlib import Path
from datetime import datetime

def find_docs_css(scripts_dir):
    """Find a4-docs-theme.css file in scripts directory"""
    css_path = scripts_dir / "a4-docs-theme.css"
    
    if css_path.exists():
        return css_path
    
    return None

def get_default_docs_css():
    """Return default CSS for document styling (fallback)"""
    return """
/* Default Document Styling - A4 Format */
@page {
    size: 210mm 297mm;
    margin: 20mm 25mm;
    @top-center {
        content: "Documentación del Curso";
        font-family: Arial, sans-serif;
        font-size: 8pt;
        color: #666;
    }
    @bottom-center {
        content: "Página " counter(page) " de " counter(pages);
        font-family: Arial, sans-serif;
        font-size: 7pt;
        color: #666;
    }
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-size: 11pt;
    line-height: 1.6;
    color: #333;
    text-align: justify;
}

h1 { font-size: 28pt; color: #2c3e50; margin-top: 30pt; margin-bottom: 25pt; }
h2 { font-size: 22pt; color: #34495e; margin-top: 30pt; margin-bottom: 18pt; }
h3 { font-size: 18pt; color: #2c3e50; margin-top: 25pt; margin-bottom: 15pt; }

p { margin-bottom: 15pt; text-align: justify; }
ul, ol { margin-bottom: 18pt; padding-left: 30pt; }
li { margin-bottom: 8pt; line-height: 1.7; }

code {
    font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
    background-color: #f8f9fa;
    padding: 3pt 6pt;
    border-radius: 4pt;
    font-size: 10pt;
    color: #e74c3c;
}

pre {
    background-color: #f8f9fa;
    border: 1pt solid #dee2e6;
    padding: 18pt;
    margin: 20pt 0;
    font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
    font-size: 10pt;
    line-height: 1.5;
}

blockquote {
    border-left: 5pt solid #3498db;
    margin: 25pt 0;
    padding: 15pt 25pt;
    background-color: #f8f9fa;
    font-style: italic;
    color: #555;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin: 25pt 0;
    font-size: 10pt;
}

th, td {
    border: 1pt solid #dee2e6;
    padding: 10pt 15pt;
    text-align: left;
}

th {
    background-color: #f8f9fa;
    font-weight: bold;
    color: #2c3e50;
}

/* Hide slide breaks */
hr { display: none; }
"""

def remove_slide_breaks(content):
    """Remove slide break markers (----) from markdown content"""
    # Remove horizontal rules that are slide breaks
    # This removes lines that contain only dashes and optional whitespace
    lines = content.split('\n')
    filtered_lines = []
    
    for line in lines:
        # Check if line is only dashes and whitespace (slide break)
        stripped = line.strip()
        if stripped and all(c == '-' for c in stripped) and len(stripped) >= 3:
            # This is a slide break, skip it
            continue
        else:
            filtered_lines.append(line)
    
    return '\n'.join(filtered_lines)

def convert_md_to_pdf_doc(md_file_path, output_dir, scripts_dir, verbose=False):
    """Convert a single MD file to PDF document format"""
    
    md_file_path = Path(md_file_path)
    output_dir = Path(output_dir)
    scripts_dir = Path(scripts_dir)
    
    if not md_file_path.exists():
        raise FileNotFoundError(f"Markdown file not found: {md_file_path}")
    
    # Create output directory if it doesn't exist
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Determine output path
    output_filename = md_file_path.stem + ".pdf"
    output_path = output_dir / output_filename
    
    if verbose:
        print(f"Converting {md_file_path} to {output_path}")
    
    # Read markdown content
    with open(md_file_path, 'r', encoding='utf-8') as f:
        markdown_content = f.read()
    
    # Remove slide breaks
    markdown_content = remove_slide_breaks(markdown_content)
    
    if verbose:
        print("  ✓ Slide breaks removed")
    
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
    docs_css_path = find_docs_css(scripts_dir)
    
    if docs_css_path and verbose:
        print(f"  ✓ Using CSS from: {docs_css_path}")
    elif verbose:
        print("  ✓ Using default CSS styling")
    
    if docs_css_path:
        with open(docs_css_path, 'r', encoding='utf-8') as f:
            css_content = f.read()
    else:
        css_content = get_default_docs_css()
    
    # Create complete HTML document
    html_document = f"""<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{md_file_path.stem}</title>
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
            print(f"  ✓ PDF generated successfully: {output_path}")
        
        return True
        
    except ImportError:
        print("Error: weasyprint is not installed.")
        print("Please install it with: pip install weasyprint")
        print("Alternative: pip install pdfkit (requires wkhtmltopdf)")
        return False
        
    except Exception as e:
        print(f"Error generating PDF with weasyprint: {e}")
        
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
                print(f"  ✓ PDF generated successfully using pdfkit: {output_path}")
            
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

def convert_all_md_files(theme_path, verbose=False):
    """Convert all MD files from md_src to pdf_docs"""
    
    theme_path = Path(theme_path)
    md_src_dir = theme_path / "presentation" / "md_src"
    pdf_docs_dir = theme_path / "presentation" / "pdf_docs"
    
    # Find scripts directory
    scripts_dir = Path(__file__).parent
    
    if not md_src_dir.exists():
        raise FileNotFoundError(f"md_src directory not found: {md_src_dir}")
    
    # Find all .md files in md_src
    md_files = list(md_src_dir.glob("*.md"))
    
    if not md_files:
        print(f"No markdown files found in {md_src_dir}")
        return False
    
    if verbose:
        print(f"Found {len(md_files)} markdown files to convert:")
        for md_file in md_files:
            print(f"  - {md_file.name}")
        print()
    
    success_count = 0
    total_files = len(md_files)
    
    for md_file in md_files:
        try:
            success = convert_md_to_pdf_doc(
                md_file, 
                pdf_docs_dir, 
                scripts_dir, 
                verbose
            )
            if success:
                success_count += 1
        except Exception as e:
            print(f"Error converting {md_file.name}: {e}")
    
    print(f"\nConversion completed: {success_count}/{total_files} files successful")
    
    if success_count > 0:
        print(f"PDF documents generated in: {pdf_docs_dir}")
    
    return success_count == total_files

def main():
    """Main function"""
    parser = argparse.ArgumentParser(
        description="Convert MD source files to PDF documents (A4 format)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s themes/example
  %(prog)s themes/fine-tuning --verbose
  %(prog)s themes/my-theme -v
        """
    )
    
    parser.add_argument(
        'theme_path',
        help='Path to theme directory containing presentation/md_src/'
    )
    
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Enable verbose output'
    )
    
    args = parser.parse_args()
    
    try:
        success = convert_all_md_files(
            theme_path=args.theme_path,
            verbose=args.verbose
        )
        
        if success:
            print("✅ All conversions completed successfully!")
            sys.exit(0)
        else:
            print("❌ Some conversions failed!")
            sys.exit(1)
            
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
