#!/bin/bash

# Archivo de configuración para scripts de Marp
# Reutilizable para diferentes proyectos/temas
# Autor: Asistente IA

# =============================================================================
# CONFIGURACIÓN POR DEFECTO
# =============================================================================

# Estructura de directorios por defecto
DEFAULT_MD_SRC_DIR="presentation/md_src"
DEFAULT_MARP_SLIDES_DIR="presentation/marp_slides"
DEFAULT_PDF_SLIDES_DIR="presentation/pdf_slides"
DEFAULT_IMG_SRC_DIR="presentation/img_src"
DEFAULT_STYLE_CSS="presentation/style.css"
DEFAULT_PROGRAMA="program.md"

# Directorios por defecto (para compatibilidad)
DEFAULT_INPUT_DIR="$DEFAULT_MARP_SLIDES_DIR"
DEFAULT_OUTPUT_DIR="$DEFAULT_PDF_SLIDES_DIR"
DEFAULT_THEME=""

# Configuración de Marp
MARP_OPTIONS="--pdf"
MARP_HTML_OPTIONS="--html"
MARP_PPTX_OPTIONS="--pptx"

# Configuración de logos y fondo
DEFAULT_LOGO_LEFT=""
DEFAULT_LOGO_RIGHT=""
DEFAULT_BACKGROUND=""

# Configuración de header y footer
DEFAULT_HEADER_TEXT=""
DEFAULT_FOOTER_TEXT=""

# Configuración de Python
PYTHON_CMD="python3"

# Configuración de Node.js
NPM_CMD="npm"
MARP_PACKAGE="@marp-team/marp-cli"

# =============================================================================
# CONFIGURACIÓN ESPECÍFICA DEL PROYECTO
# =============================================================================

# Puedes sobrescribir las configuraciones por defecto aquí
# Ejemplo:
# DEFAULT_INPUT_DIR="presentaciones"
# DEFAULT_OUTPUT_DIR="pdfs"
# DEFAULT_THEME="custom-theme"

# =============================================================================
# FUNCIONES DE UTILIDAD
# =============================================================================

# Función para cargar configuración desde archivo
load_config() {
    local config_file="$1"
    
    if [ -f "$config_file" ]; then
        echo "📁 Cargando configuración desde: $config_file"
        source "$config_file"
    else
        echo "⚠️  Archivo de configuración no encontrado: $config_file"
        echo "   Usando configuración por defecto"
    fi
}

# Función para mostrar configuración actual
show_config() {
    echo "📋 Configuración actual:"
    echo "   Estructura de directorios:"
    echo "     - MD fuente: $DEFAULT_MD_SRC_DIR"
    echo "     - Marp slides: $DEFAULT_MARP_SLIDES_DIR"
    echo "     - PDF slides: $DEFAULT_PDF_SLIDES_DIR"
    echo "     - Imágenes: $DEFAULT_IMG_SRC_DIR"
    echo "     - Estilos CSS: $DEFAULT_STYLE_CSS"
    echo "     - Programa: $DEFAULT_PROGRAMA"
    echo "   Tema: ${DEFAULT_THEME:-por defecto}"
    echo "   Comando Python: $PYTHON_CMD"
    echo "   Comando npm: $NPM_CMD"
    echo "   Paquete Marp: $MARP_PACKAGE"
    echo ""
}

# Función para validar configuración
validate_config() {
    local errors=0
    
    # Verificar que Python esté disponible
    if ! command -v "$PYTHON_CMD" &> /dev/null; then
        echo "❌ Error: $PYTHON_CMD no está disponible"
        errors=$((errors + 1))
    fi
    
    # Verificar que npm esté disponible
    if ! command -v "$NPM_CMD" &> /dev/null; then
        echo "❌ Error: $NPM_CMD no está disponible"
        errors=$((errors + 1))
    fi
    
    # Verificar que Marp esté instalado
    if ! command -v marp &> /dev/null; then
        echo "⚠️  Advertencia: Marp CLI no está instalado"
        echo "   Ejecuta: ./scripts/setup_marp.sh"
    fi
    
    if [ $errors -gt 0 ]; then
        echo "❌ Se encontraron $errors errores en la configuración"
        return 1
    else
        echo "✅ Configuración válida"
        return 0
    fi
}

# Función para crear archivo de configuración de ejemplo
create_example_config() {
    local example_file="$1"
    
    cat > "$example_file" << 'EOF'
#!/bin/bash

# Archivo de configuración de ejemplo para scripts de Marp
# Copia este archivo y modifica según tus necesidades

# Directorios personalizados
DEFAULT_INPUT_DIR="mis_presentaciones"
DEFAULT_OUTPUT_DIR="mis_pdfs"
DEFAULT_THEME="mi_tema_personalizado"

# Opciones adicionales de Marp
MARP_OPTIONS="--pdf --allow-local-files"
MARP_HTML_OPTIONS="--html --allow-local-files"
MARP_PPTX_OPTIONS="--pptx --allow-local-files"

# Configuración de Python (si usas un entorno virtual)
# PYTHON_CMD="/path/to/venv/bin/python"

# Configuración de Node.js (si usas nvm o similar)
# NPM_CMD="/path/to/npm"
# MARP_PACKAGE="@marp-team/marp-cli"
EOF

    echo "📝 Archivo de configuración de ejemplo creado: $example_file"
    echo "   Edita el archivo según tus necesidades"
}

# =============================================================================
# CONFIGURACIÓN AUTOMÁTICA
# =============================================================================

# Buscar archivo de configuración del proyecto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Cargar configuración del proyecto si existe
# Prioridad: 1) tema theme-example, 2) proyecto raíz
if [ -f "$PROJECT_DIR/themes/theme-example/marp.config.sh" ]; then
    PROJECT_CONFIG="$PROJECT_DIR/themes/theme-example/marp.config.sh"
elif [ -f "$PROJECT_DIR/marp.config.sh" ]; then
    PROJECT_CONFIG="$PROJECT_DIR/marp.config.sh"
else
    PROJECT_CONFIG="$PROJECT_DIR/marp.config.sh"
fi
load_config "$PROJECT_CONFIG"

# Mostrar configuración si se solicita
if [ "${1:-}" = "--show-config" ]; then
    show_config
    exit 0
fi

# Validar configuración si se solicita
if [ "${1:-}" = "--validate" ]; then
    validate_config
    exit $?
fi

# Crear archivo de ejemplo si se solicita
if [ "${1:-}" = "--create-example" ]; then
    create_example_config "$PROJECT_DIR/marp.config.example.sh"
    exit 0
fi
