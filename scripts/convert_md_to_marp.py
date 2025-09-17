#!/usr/bin/env python3
"""
Script to convert Markdown files to Marp format
Converts .md files from md_src/ to marp_slides/ with Marp format
Reusable for different projects/themes
"""

import os
import argparse
from pathlib import Path
from typing import List, Optional

def add_marp_header(content: str, theme: str = None, logo_left: str = None, 
                   logo_right: str = None, background: str = None, 
                   header_text: str = None, footer_text: str = None,
                   marp_slides_dir: str = None) -> str:
    """Add Marp header to Markdown content"""
    marp_header = "---\nmarp: true\n"
    
    if theme:
        marp_header += f"theme: {theme}\n"
    
    # Add logo, background, header, and footer configuration
    if logo_left or logo_right or background or header_text or footer_text:
        marp_header += "style: |\n"
        
        # Convert paths to be relative to the marp_slides directory
        logo_left_path = logo_left
        logo_right_path = logo_right
        background_path = background
        
        if logo_left and marp_slides_dir:
            if Path(logo_left).is_absolute():
                try:
                    rel_path = Path(logo_left).relative_to(Path(marp_slides_dir).parent)
                    logo_left_path = str(rel_path)
                except ValueError:
                    pass
            else:
                # Convert relative path to be relative to marp_slides directory
                # If logo_left is 'themes/theme-example/presentation/img_src/logo_left.png'
                # and marp_slides_dir is 'themes/theme-example/presentation/marp_slides'
                # then we want '../img_src/logo_left.png'
                try:
                    # Use images/ directory which is where Makefile copies the images
                    # Preserve the original filename and extension
                    filename = Path(logo_left).name
                    logo_left_path = f'images/{filename}'
                except ValueError:
                    # If we can't calculate relative path, use the original
                    logo_left_path = logo_left
        
        if logo_right and marp_slides_dir:
            if Path(logo_right).is_absolute():
                try:
                    rel_path = Path(logo_right).relative_to(Path(marp_slides_dir).parent)
                    logo_right_path = str(rel_path)
                except ValueError:
                    pass
            else:
                try:
                    # Use images/ directory which is where Makefile copies the images
                    # Preserve the original filename and extension
                    filename = Path(logo_right).name
                    logo_right_path = f'images/{filename}'
                except ValueError:
                    logo_right_path = logo_right
        
        if background and marp_slides_dir:
            if Path(background).is_absolute():
                try:
                    rel_path = Path(background).relative_to(Path(marp_slides_dir).parent)
                    background_path = str(rel_path)
                except ValueError:
                    pass
            else:
                try:
                    # Use images/ directory which is where Makefile copies the images
                    # Preserve the original filename and extension
                    filename = Path(background).name
                    background_path = f'images/{filename}'
                except ValueError:
                    background_path = background
        
        # Base section styling
        marp_header += f"  section {{ position: relative; }}\n"
        
        # Background
        if background:
            marp_header += f"  section {{ background-image: url('{background_path}'); background-size: cover; background-position: center; background-repeat: no-repeat; }}\n"
        
        # Headers with integrated logos
        if header_text:
            marp_header += f"  section .header-text {{ position: absolute; top: 5mm; left: 10mm; right: 10mm; text-align: center; font-size: 10pt; font-weight: bold; color: #333; background: rgba(255, 255, 255, 0.9); padding: 2mm 4mm; border-radius: 2mm; box-shadow: 0 1px 3px rgba(0,0,0,0.2); z-index: 20; display: flex; align-items: center; justify-content: space-between; }}\n"
            
            # Add logos inside header if they exist
            if logo_left:
                marp_header += f"  section .header-text .logo-left {{ width: 25mm; height: 12mm; background-image: url('{logo_left_path}'); background-size: contain; background-repeat: no-repeat; background-position: left center; flex-shrink: 0; }}\n"
            
            if logo_right:
                marp_header += f"  section .header-text .logo-right {{ width: 25mm; height: 12mm; background-image: url('{logo_right_path}'); background-size: contain; background-repeat: no-repeat; background-position: right center; flex-shrink: 0; }}\n"
            
            # Header text in the center
            marp_header += f"  section .header-text .header-center {{ flex: 1; text-align: center; }}\n"
        
        if footer_text:
            marp_header += f"  section .footer-text {{ position: absolute; bottom: 5mm; left: 10mm; right: 10mm; text-align: center; font-size: 9pt; color: #666; background: rgba(255, 255, 255, 0.8); padding: 2mm 4mm; border-radius: 2mm; box-shadow: 0 1px 3px rgba(0,0,0,0.1); z-index: 20; }}\n"
    
    marp_header += "---\n\n"
    
    # Process content to add HTML elements for logos, headers, and footers
    processed_content = content
    if logo_left or logo_right or header_text or footer_text:
        processed_content = add_data_attributes(content, header_text, footer_text, logo_left, logo_right)
    
    return marp_header + processed_content

def add_data_attributes(content: str, header_text: str = None, footer_text: str = None, logo_left: str = None, logo_right: str = None) -> str:
    """Add HTML elements for logos, headers, and footers to slide content"""
    import re
    
    # Split content by slide separators (---)
    slides = content.split('\n---\n')
    processed_slides = []
    
    for i, slide in enumerate(slides):
        if not slide.strip():
            processed_slides.append(slide)
            continue
            
        # Add HTML elements at the beginning of each slide
        lines = slide.split('\n')
        
        # Find the first heading and add elements after it
        for j, line in enumerate(lines):
            if line.strip().startswith('#'):
                # Add HTML elements after the heading
                elements = []
                
                # Create header with integrated logos
                if header_text:
                    header_html = '<div class="header-text">'
                    
                    # Add left logo if exists
                    if logo_left:
                        header_html += '<div class="logo-left"></div>'
                    
                    # Add center text
                    header_html += f'<div class="header-center">{header_text}</div>'
                    
                    # Add right logo if exists
                    if logo_right:
                        header_html += '<div class="logo-right"></div>'
                    
                    header_html += '</div>'
                    elements.append(header_html)
                
                # Add footer separately
                if footer_text:
                    elements.append(f'<div class="footer-text">{footer_text}</div>')
                
                if elements:
                    # Insert elements after the heading
                    lines.insert(j + 1, ''.join(elements))
                break
        
        processed_slides.append('\n'.join(lines))
    
    return '\n---\n'.join(processed_slides)

def convert_md_to_marp(md_src_dir: str, marp_slides_dir: str, theme: str = None, 
                      style_css: str = None, programa_file: str = None, 
                      logo_left: str = None, logo_right: str = None, 
                      background: str = None, header_text: str = None, 
                      footer_text: str = None) -> List[str]:
    """Convert Markdown files to Marp format"""
    
    md_src_path = Path(md_src_dir)
    if not md_src_path.exists():
        raise FileNotFoundError(f"Directory {md_src_dir} does not exist")
    
    marp_slides_path = Path(marp_slides_dir)
    marp_slides_path.mkdir(parents=True, exist_ok=True)
    
    # Find all Markdown files in md_src
    md_files = list(md_src_path.glob("*.md"))
    
    if not md_files:
        print(f"No .md files found in {md_src_dir}")
        return []
    
    print(f"Found {len(md_files)} Markdown files to convert to Marp")
    
    converted_files = []
    
    for md_file in md_files:
        try:
            # Read file content
            with open(md_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Add Marp header
            marp_content = add_marp_header(content, theme, logo_left, logo_right, background, header_text, footer_text, str(marp_slides_path))
            
            # Create Marp file
            marp_file = marp_slides_path / md_file.name
            with open(marp_file, 'w', encoding='utf-8') as f:
                f.write(marp_content)
            
            converted_files.append(str(marp_file))
            print(f"✓ Converted: {md_file.name} -> {marp_file.name}")
            
        except Exception as e:
            print(f"✗ Error converting {md_file.name}: {e}")
    
    # Process program file if it exists
    if programa_file:
        programa_path = Path(programa_file)
        if programa_path.exists():
            try:
                with open(programa_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                marp_content = add_marp_header(content, theme, logo_left, logo_right, background, header_text, footer_text, str(marp_slides_path))
                
                programa_marp = marp_slides_path / programa_path.name
                with open(programa_marp, 'w', encoding='utf-8') as f:
                    f.write(marp_content)
                
                converted_files.append(str(programa_marp))
                print(f"✓ Converted program: {programa_path.name} -> {programa_marp.name}")
                
            except Exception as e:
                print(f"✗ Error converting program {programa_path.name}: {e}")
    
    return converted_files

def main():
    """Main function of the script"""
    parser = argparse.ArgumentParser(description="Convert Markdown files to Marp format")
    parser.add_argument("md_src", nargs="?", default="presentation/md_src", 
                       help="Directory with source Markdown files (default: presentation/md_src)")
    parser.add_argument("-o", "--output", default="presentation/marp_slides",
                       help="Output directory for Marp files (default: presentation/marp_slides)")
    parser.add_argument("-t", "--theme", help="CSS theme to use")
    parser.add_argument("-s", "--style", help="CSS styles file (default: presentation/style.css)")
    parser.add_argument("-p", "--programa", help="program.md file (default: program.md)")
    parser.add_argument("--logo-left", help="Path to left logo (upper-left)")
    parser.add_argument("--logo-right", help="Path to right logo (upper-right)")
    parser.add_argument("--background", help="Path to background image")
    parser.add_argument("--header", help="Header text (appears at the top)")
    parser.add_argument("--footer", help="Footer text (appears at the bottom)")
    parser.add_argument("--project-dir", help="Project directory (default: script parent directory)")
    
    args = parser.parse_args()
    
    # Determine project directory
    if args.project_dir:
        project_dir = Path(args.project_dir)
    else:
        script_dir = Path(__file__).parent
        project_dir = script_dir.parent
    
    # Resolve paths relative to project directory
    md_src_path = project_dir / args.md_src
    marp_slides_path = project_dir / args.output
    
    if not md_src_path.exists():
        print(f"Error: {md_src_path} does not exist")
        print(f"Looking in: {project_dir}")
        return 1
    
    if not md_src_path.is_dir():
        print(f"Error: {md_src_path} is not a directory")
        return 1
    
    # Resolve program file
    programa_file = None
    if args.programa:
        programa_file = str(project_dir / args.programa)
    else:
        programa_file = str(project_dir / "programa.md")
        if not Path(programa_file).exists():
            programa_file = None
    
    # Resolve styles file
    style_css = None
    if args.style:
        style_css = str(project_dir / args.style)
    else:
        style_css = str(project_dir / "presentation/style.css")
        if not Path(style_css).exists():
            style_css = None
    
    try:
        # Convert Markdown files to Marp
        marp_files = convert_md_to_marp(
            str(md_src_path), 
            str(marp_slides_path), 
            args.theme,
            style_css,
            programa_file,
            args.logo_left,
            args.logo_right,
            args.background,
            args.header,
            args.footer
        )
        
        if marp_files:
            print(f"\n🎉 Conversion completed!")
            print(f"Generated Marp files: {len(marp_files)}")
            print(f"Marp directory: {Path(marp_files[0]).parent}")
        else:
            print("❌ Could not generate Marp files")
            return 1
        
        print("\n📝 Next steps:")
        print("1. Review files in marp_slides/")
        print("2. Run: ./scripts/marp_tools.sh convert")
        print("3. Or use: ./scripts/marp_tools.sh watch")
        
        return 0
        
    except Exception as e:
        print(f"Error: {e}")
        return 1

if __name__ == "__main__":
    exit(main())
