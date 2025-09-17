#!/usr/bin/env python3
"""
Script to convert Marp files to PDF
Converts .md files from marp_slides/ to PDFs in pdf_slides/
Reusable for different projects/themes
"""

import os
import subprocess
import argparse
from pathlib import Path
from typing import List

def generate_pdfs_from_marp(marp_dir: str, pdf_dir: str = None, theme: str = None) -> List[str]:
    """Generate PDF files from Marp files"""
    
    marp_path = Path(marp_dir)
    if not marp_path.exists():
        raise FileNotFoundError(f"Directory {marp_dir} does not exist")
    
    if not pdf_dir:
        pdf_dir = Path.cwd() / "presentation/pdf_slides"
    
    pdf_path = Path(pdf_dir)
    pdf_path.mkdir(exist_ok=True)
    
    # Find all Marp files (.md files in marp_slides)
    # Exclude program.md as it's converted separately to theme root directory
    marp_files = [f for f in marp_path.glob("*.md") if f.name != "program.md"]
    
    if not marp_files:
        print(f"No .md files found in {marp_dir}")
        return []
    
    print(f"Found {len(marp_files)} Marp files to convert to PDF")
    
    generated_pdfs = []
    
    for marp_file in marp_files:
        try:
            # Create PDF file name
            pdf_file = pdf_path / f"{marp_file.stem}.pdf"
            
            # Generate PDF using Marp CLI
            cmd_parts = ["marp", str(marp_file), "--pdf", "--output", str(pdf_file), "--allow-local-files"]
            
            # Add theme if specified
            if theme:
                # Look for CSS file in project directory
                project_dir = Path.cwd()
                css_file = project_dir / f"{theme}.css"
                if css_file.exists():
                    cmd_parts.extend(["--theme", str(css_file)])
                else:
                    print(f"⚠️  Theme file {css_file} not found, using default theme")
            
            cmd = " ".join(cmd_parts)
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            
            if result.returncode == 0:
                generated_pdfs.append(str(pdf_file))
                print(f"✓ PDF generated: {marp_file.name} -> {pdf_file.name}")
            else:
                print(f"✗ Error generating PDF for {marp_file.name}: {result.stderr}")
                
        except Exception as e:
            print(f"✗ Error generating PDF for {marp_file.name}: {e}")
    
    return generated_pdfs

def main():
    """Main function of the script"""
    parser = argparse.ArgumentParser(description="Convert Marp files to PDF")
    parser.add_argument("input", nargs="?", default="presentation/marp_slides", help="Directory with Marp files (default: presentation/marp_slides)")
    parser.add_argument("-o", "--output", help="Output directory for PDFs (default: presentation/pdf_slides)")
    parser.add_argument("-t", "--theme", help="CSS theme to use (.css file in script directory)")
    parser.add_argument("--project-dir", help="Project directory (default: script parent directory)")
    
    args = parser.parse_args()
    
    # Determine project directory
    if args.project_dir:
        project_dir = Path(args.project_dir)
    else:
        # Look for project directory (where the fine-tuning folder is)
        script_dir = Path(__file__).parent
        project_dir = script_dir.parent
    
    # Resolve paths relative to project directory
    if args.input.startswith("presentation/"):
        input_path = project_dir / args.input
    else:
        input_path = project_dir / "presentation" / args.input
    
    if not input_path.exists():
        print(f"Error: {input_path} does not exist")
        print(f"Looking in: {project_dir}")
        return 1
    
    if not input_path.is_dir():
        print(f"Error: {input_path} is not a directory")
        return 1
    
    # Resolve output directory
    if args.output:
        if args.output.startswith("presentation/"):
            output_path = project_dir / args.output
        else:
            output_path = project_dir / "presentation" / args.output
    else:
        output_path = project_dir / "presentation/pdf_slides"
    
    try:
        # Convert Marp files to PDF
        pdf_files = generate_pdfs_from_marp(str(input_path), str(output_path), args.theme)
        
        if pdf_files:
            print(f"\n🎉 Conversion completed!")
            print(f"Generated PDFs: {len(pdf_files)}")
            print(f"PDF directory: {Path(pdf_files[0]).parent}")
        else:
            print("❌ Could not generate PDFs")
            return 1
        
        print("\n📝 To use the presentations:")
        print(f"1. Open PDF files in {output_path}/")
        print(f"2. Or use Marp directly: marp {input_path}/file.md --watch")
        
        return 0
        
    except Exception as e:
        print(f"Error: {e}")
        return 1

if __name__ == "__main__":
    exit(main())
