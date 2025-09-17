#!/bin/bash

# Script para convertir archivos Marp a PDF
# Reutilizable para diferentes proyectos/temas
# Autor: Asistente IA
# Fecha: $(date)

# Configuración por defecto
PROJECT_DIR=""
INPUT_DIR="presentation/marp_slides"
OUTPUT_DIR="presentation/pdf_slides"
THEME=""
VERBOSE=false

# Función de ayuda
show_help() {
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "Opciones:"
    echo "  -p, --project-dir DIR    Directorio del proyecto (default: directorio padre)"
    echo "  -i, --input DIR          Directorio con archivos Marp (default: presentation/marp_slides)"
    echo "  -o, --output DIR         Directorio de salida para PDFs (default: presentation/pdf_slides)"
    echo "  -t, --theme THEME        Tema CSS a usar (archivo .css en scripts/)"
    echo "  -v, --verbose            Modo verboso"
    echo "  -h, --help               Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0                                    # Usar configuración por defecto"
    echo "  $0 -p /path/to/project               # Especificar directorio del proyecto"
    echo "  $0 -i slides -o output -t custom     # Directorios y tema personalizados"
    echo ""
}

# Procesar argumentos
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
            echo "❌ Opción desconocida: $1"
            show_help
            exit 1
            ;;
    esac
done

# Determinar directorio del proyecto
if [ -z "$PROJECT_DIR" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
fi

# Verificar que el directorio del proyecto existe
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Error: El directorio del proyecto '$PROJECT_DIR' no existe"
    exit 1
fi

# Guardar la ruta del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# No cambiar al directorio del proyecto, trabajar desde el directorio raíz

if [ "$VERBOSE" = true ]; then
    echo "📁 Directorio del proyecto: $PROJECT_DIR"
    echo "📁 Directorio de entrada: $INPUT_DIR"
    echo "📁 Directorio de salida: $OUTPUT_DIR"
    echo "🎨 Tema: ${THEME:-por defecto}"
    echo ""
fi

echo "🚀 Iniciando conversión de archivos Marp a PDF..."
echo ""

# Verificar que Marp está instalado
if ! command -v marp &> /dev/null; then
    echo "❌ Marp no está instalado. Ejecutando setup..."
    bash "$(dirname "${BASH_SOURCE[0]}")/setup_marp.sh"
    echo ""
fi

# Crear directorios si no existen
echo "📁 Creando directorios necesarios..."
mkdir -p "$PROJECT_DIR/$INPUT_DIR" "$PROJECT_DIR/$OUTPUT_DIR"

# Verificar que existen archivos Marp
if [ ! -d "$PROJECT_DIR/$INPUT_DIR" ] || [ -z "$(ls -A "$PROJECT_DIR/$INPUT_DIR"/*.md 2>/dev/null)" ]; then
    echo "❌ No se encontraron archivos Marp en $PROJECT_DIR/$INPUT_DIR/"
    echo "   Asegúrate de que los archivos .md estén en $PROJECT_DIR/$INPUT_DIR/"
    exit 1
fi

# Convertir archivos Marp a PDF
echo "🔄 Convirtiendo archivos Marp a PDF..."

# Construir comando con rutas absolutas
CMD="python3 $SCRIPT_DIR/convert_marp_to_pdf.py"
CMD="$CMD --project-dir '$PROJECT_DIR'"
CMD="$CMD '$INPUT_DIR'"
CMD="$CMD -o '$OUTPUT_DIR'"

if [ -n "$THEME" ]; then
    CMD="$CMD -t '$THEME'"
fi

# Ejecutar comando
echo "🔄 Ejecutando: $CMD"
eval $CMD

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ¡Conversión completada!"
    echo ""
    echo "📁 Archivos generados:"
    echo "   - $INPUT_DIR/: Archivos Marp (entrada)"
    echo "   - $OUTPUT_DIR/: Archivos PDF generados"
    echo ""
    echo "📝 Para ver las presentaciones:"
    echo "   - Abre los archivos .pdf en $OUTPUT_DIR/"
    echo "   - O usa: marp $INPUT_DIR/archivo.md --watch"
    echo ""
else
    echo "❌ Error durante la conversión"
    exit 1
fi
