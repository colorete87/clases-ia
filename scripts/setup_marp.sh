#!/bin/bash

# Script para configurar Marp y convertir archivos Markdown a presentaciones
# Reutilizable para diferentes proyectos/temas
# Autor: Asistente IA
# Fecha: $(date)

# Configuración
VERBOSE=false
FORCE=false

# Función de ayuda
show_help() {
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "Opciones:"
    echo "  -v, --verbose    Modo verboso"
    echo "  -f, --force      Forzar reinstalación de Marp CLI"
    echo "  -h, --help       Mostrar esta ayuda"
    echo ""
    echo "Este script instala Marp CLI globalmente para convertir archivos Markdown a presentaciones."
    echo ""
}

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--force)
            FORCE=true
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

echo "🚀 Configurando Marp para conversión de Markdown a presentaciones..."

# Verificar si Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado. Por favor instala Node.js primero:"
    echo "   https://nodejs.org/"
    echo ""
    echo "💡 En Ubuntu/Debian: sudo apt install nodejs npm"
    echo "💡 En macOS: brew install node"
    echo "💡 En Windows: Descarga desde https://nodejs.org/"
    exit 1
fi

# Verificar si npm está disponible
if ! command -v npm &> /dev/null; then
    echo "❌ npm no está disponible. Por favor instala npm primero."
    exit 1
fi

if [ "$VERBOSE" = true ]; then
    echo "✅ Node.js versión: $(node --version)"
    echo "✅ npm versión: $(npm --version)"
fi

# Verificar si Marp ya está instalado
if command -v marp &> /dev/null && [ "$FORCE" = false ]; then
    echo "✅ Marp CLI ya está instalado: $(marp --version)"
    echo "💡 Usa -f o --force para reinstalar"
    echo ""
    echo "🎉 ¡Marp está listo para usar!"
    show_usage_info
    exit 0
fi

# Instalar Marp CLI globalmente
echo "📦 Instalando Marp CLI..."
if [ "$FORCE" = true ]; then
    echo "🔄 Reinstalando Marp CLI..."
    npm uninstall -g @marp-team/marp-cli 2>/dev/null || true
fi

npm install -g @marp-team/marp-cli

if [ $? -eq 0 ]; then
    echo "✅ Marp CLI instalado correctamente"
else
    echo "❌ Error instalando Marp CLI"
    echo "💡 Intenta ejecutar: sudo npm install -g @marp-team/marp-cli"
    exit 1
fi

# Verificar instalación
echo "🔍 Verificando instalación..."
marp --version

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ¡Marp está listo para usar!"
    show_usage_info
else
    echo "❌ Error verificando la instalación de Marp"
    exit 1
fi

# Función para mostrar información de uso
show_usage_info() {
    echo ""
    echo "📝 Comandos útiles de Marp:"
    echo "   marp archivo.md --pdf          # Generar PDF"
    echo "   marp archivo.md --html         # Generar HTML"
    echo "   marp archivo.md --pptx         # Generar PowerPoint"
    echo "   marp archivo.md --watch        # Modo watch (auto-regenera)"
    echo ""
    echo "🔧 Scripts disponibles en este proyecto:"
    echo "   ./scripts/run_conversion.sh                    # Convertir archivos Marp a PDF"
    echo "   ./scripts/run_conversion.sh -h                 # Ver ayuda del script"
    echo "   ./scripts/run_conversion.sh -i slides -o pdf   # Directorios personalizados"
    echo ""
    echo "📁 Estructura típica de carpetas:"
    echo "   - marp_slides/: Archivos Marp (.md)"
    echo "   - pdf_slides/: Archivos PDF generados"
    echo "   - scripts/: Scripts de conversión"
    echo ""
    echo "💡 Para usar en otros proyectos:"
    echo "   1. Copia la carpeta scripts/ a tu nuevo proyecto"
    echo "   2. Ejecuta: ./scripts/setup_marp.sh"
    echo "   3. Ejecuta: ./scripts/run_conversion.sh"
    echo ""
}
