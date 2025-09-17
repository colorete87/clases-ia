#!/bin/bash

# Archivo de configuración para theme-example
# Demuestra el uso de logos y fondos

# Directorios del proyecto
DEFAULT_MD_SRC_DIR="presentation/md_src"
DEFAULT_MARP_SLIDES_DIR="presentation/marp_slides"
DEFAULT_PDF_SLIDES_DIR="presentation/pdf_slides"
DEFAULT_IMG_SRC_DIR="presentation/img_src"
DEFAULT_STYLE_CSS="presentation/style.css"
DEFAULT_PROGRAMA="programa.md"

# Configuración de logos y fondo
DEFAULT_LOGO_LEFT="presentation/img_src/logo_left.png"
DEFAULT_LOGO_RIGHT="presentation/img_src/logo_right.png"
DEFAULT_BACKGROUND="presentation/img_src/background.png"

# Configuración de header y footer
DEFAULT_HEADER_TEXT="Mi Empresa - Curso de Capacitación"
DEFAULT_FOOTER_TEXT="Confidencial - Todos los derechos reservados"

# Opciones de Marp
MARP_OPTIONS="--pdf --allow-local-files"
MARP_HTML_OPTIONS="--html --allow-local-files"
MARP_PPTX_OPTIONS="--pptx --allow-local-files"

# Configuración de Python
PYTHON_CMD="python3"

# Configuración de Node.js
NPM_CMD="npm"
MARP_PACKAGE="@marp-team/marp-cli"
