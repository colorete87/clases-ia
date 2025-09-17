#!/usr/bin/env python3
"""
Script para convertir archivos Marp a PDF
Convierte archivos .md de marp_slides/ a PDFs en pdf_slides/
Reutilizable para diferentes proyectos/temas
"""

import os
import subprocess
import argparse
from pathlib import Path
from typing import List

def generate_pdfs_from_marp(marp_dir: str, pdf_dir: str = None, theme: str = None) -> List[str]:
    """Genera archivos PDF a partir de archivos Marp"""
    
    marp_path = Path(marp_dir)
    if not marp_path.exists():
        raise FileNotFoundError(f"El directorio {marp_dir} no existe")
    
    if not pdf_dir:
        pdf_dir = Path.cwd() / "presentation/pdf_slides"
    
    pdf_path = Path(pdf_dir)
    pdf_path.mkdir(exist_ok=True)
    
    # Buscar todos los archivos Marp (.md files in marp_slides)
    # Excluir program.md ya que se convierte por separado al directorio raíz del tema
    marp_files = [f for f in marp_path.glob("*.md") if f.name != "program.md"]
    
    if not marp_files:
        print(f"No se encontraron archivos .md en {marp_dir}")
        return []
    
    print(f"Encontrados {len(marp_files)} archivos Marp para convertir a PDF")
    
    generated_pdfs = []
    
    for marp_file in marp_files:
        try:
            # Crear nombre de archivo PDF
            pdf_file = pdf_path / f"{marp_file.stem}.pdf"
            
            # Generar PDF usando Marp CLI
            cmd_parts = ["marp", str(marp_file), "--pdf", "--output", str(pdf_file), "--allow-local-files"]
            
            # Agregar tema si se especifica
            if theme:
                # Buscar el archivo CSS en el directorio del proyecto
                project_dir = Path.cwd()
                css_file = project_dir / f"{theme}.css"
                if css_file.exists():
                    cmd_parts.extend(["--theme", str(css_file)])
                else:
                    print(f"⚠️  Archivo de tema {css_file} no encontrado, usando tema por defecto")
            
            cmd = " ".join(cmd_parts)
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            
            if result.returncode == 0:
                generated_pdfs.append(str(pdf_file))
                print(f"✓ PDF generado: {marp_file.name} -> {pdf_file.name}")
            else:
                print(f"✗ Error generando PDF para {marp_file.name}: {result.stderr}")
                
        except Exception as e:
            print(f"✗ Error generando PDF para {marp_file.name}: {e}")
    
    return generated_pdfs

def main():
    """Función principal del script"""
    parser = argparse.ArgumentParser(description="Convierte archivos Marp a PDF")
    parser.add_argument("input", nargs="?", default="presentation/marp_slides", help="Directorio con archivos Marp (default: presentation/marp_slides)")
    parser.add_argument("-o", "--output", help="Directorio de salida para PDFs (default: presentation/pdf_slides)")
    parser.add_argument("-t", "--theme", help="Tema CSS a usar (archivo .css en el directorio del script)")
    parser.add_argument("--project-dir", help="Directorio del proyecto (default: directorio padre del script)")
    
    args = parser.parse_args()
    
    # Determinar directorio del proyecto
    if args.project_dir:
        project_dir = Path(args.project_dir)
    else:
        # Buscar el directorio del proyecto (donde está la carpeta fine-tuning)
        script_dir = Path(__file__).parent
        project_dir = script_dir.parent
    
    # Resolver rutas relativas al directorio del proyecto
    if args.input.startswith("presentation/"):
        input_path = project_dir / args.input
    else:
        input_path = project_dir / "presentation" / args.input
    
    if not input_path.exists():
        print(f"Error: {input_path} no existe")
        print(f"Buscando en: {project_dir}")
        return 1
    
    if not input_path.is_dir():
        print(f"Error: {input_path} no es un directorio")
        return 1
    
    # Resolver directorio de salida
    if args.output:
        if args.output.startswith("presentation/"):
            output_path = project_dir / args.output
        else:
            output_path = project_dir / "presentation" / args.output
    else:
        output_path = project_dir / "presentation/pdf_slides"
    
    try:
        # Convertir archivos Marp a PDF
        pdf_files = generate_pdfs_from_marp(str(input_path), str(output_path), args.theme)
        
        if pdf_files:
            print(f"\n🎉 Conversión completada!")
            print(f"PDFs generados: {len(pdf_files)}")
            print(f"Directorio PDF: {Path(pdf_files[0]).parent}")
        else:
            print("❌ No se pudieron generar PDFs")
            return 1
        
        print("\n📝 Para usar las presentaciones:")
        print(f"1. Abre los archivos PDF en {output_path}/")
        print(f"2. O usa Marp directamente: marp {input_path}/archivo.md --watch")
        
        return 0
        
    except Exception as e:
        print(f"Error: {e}")
        return 1

if __name__ == "__main__":
    exit(main())
