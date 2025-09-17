#!/bin/bash

# Script para crear un nuevo proyecto con la estructura recomendada
# Autor: Asistente IA

# Configuración
VERBOSE=false
THEME_NAME=""

# Función de ayuda
show_help() {
    echo "Uso: $0 NOMBRE_TEMA [OPCIONES]"
    echo ""
    echo "Crea un nuevo proyecto con la estructura recomendada para presentaciones Marp"
    echo ""
    echo "Argumentos:"
    echo "  NOMBRE_TEMA              Nombre del tema/proyecto"
    echo ""
    echo "Opciones:"
    echo "  -v, --verbose            Modo verboso"
    echo "  -h, --help               Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 mi-curso-ia           # Crear proyecto 'mi-curso-ia'"
    echo "  $0 machine-learning -v   # Crear proyecto con modo verboso"
    echo ""
}

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "❌ Opción desconocida: $1"
            show_help
            exit 1
            ;;
        *)
            if [ -z "$THEME_NAME" ]; then
                THEME_NAME="$1"
            else
                echo "❌ Solo se puede especificar un nombre de tema"
                show_help
                exit 1
            fi
            shift
            ;;
    esac
done

# Verificar que se proporcionó el nombre del tema
if [ -z "$THEME_NAME" ]; then
    echo "❌ Error: Se requiere el nombre del tema"
    show_help
    exit 1
fi

# Obtener directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Creando proyecto: $THEME_NAME"

# Crear estructura de directorios
if [ "$VERBOSE" = true ]; then
    echo "📁 Creando estructura de directorios..."
fi

mkdir -p "$THEME_NAME/presentation/md_src"
mkdir -p "$THEME_NAME/presentation/marp_slides"
mkdir -p "$THEME_NAME/presentation/pdf_slides"
mkdir -p "$THEME_NAME/presentation/img_src"

# Copiar scripts
if [ "$VERBOSE" = true ]; then
    echo "📋 Copiando scripts..."
fi

cp -r "$SCRIPT_DIR" "$THEME_NAME/"

# Crear archivo programa.md
if [ "$VERBOSE" = true ]; then
    echo "📝 Creando archivo programa.md..."
fi

cat > "$THEME_NAME/programa.md" << EOF
# Programa del Curso: $THEME_NAME

## Módulo 1: Introducción
- Conceptos básicos
- Herramientas necesarias
- Configuración del entorno

## Módulo 2: Desarrollo
- Implementación paso a paso
- Mejores prácticas
- Casos de uso

## Módulo 3: Práctica
- Ejercicios prácticos
- Proyecto final
- Evaluación

---

*Este archivo contiene el programa general del curso. Las presentaciones detalladas están en presentation/md_src/*
EOF

# Crear archivo de estilos CSS
if [ "$VERBOSE" = true ]; then
    echo "🎨 Creando archivo de estilos..."
fi

cat > "$THEME_NAME/presentation/style.css" << 'EOF'
/* Estilos personalizados para las presentaciones */

section {
    font-family: 'Arial', sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 60px;
    position: relative;
}

/* Background image support */
section[data-background] {
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
}

/* Logo positioning */
section::before {
    content: '';
    position: absolute;
    top: 20px;
    left: 20px;
    width: 120px;
    height: 60px;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: left center;
    z-index: 10;
}

section::after {
    content: '';
    position: absolute;
    top: 20px;
    right: 20px;
    width: 120px;
    height: 60px;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: right center;
    z-index: 10;
}

/* Logo classes for specific positioning */
.logo-left {
    position: absolute;
    top: 20px;
    left: 20px;
    width: 120px;
    height: 60px;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: left center;
    z-index: 10;
}

.logo-right {
    position: absolute;
    top: 20px;
    right: 20px;
    width: 120px;
    height: 60px;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: right center;
    z-index: 10;
}

/* Header and Footer support */
section[data-header]::before {
    content: attr(data-header);
    background-image: none;
    width: auto;
    height: auto;
    top: 10px;
    left: 20px;
    right: 20px;
    text-align: left;
    font-size: 14px;
    font-weight: bold;
    color: #333;
    background: rgba(255, 255, 255, 0.9);
    padding: 8px 16px;
    border-radius: 4px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

/* Footer text */
section[data-footer]::after {
    content: attr(data-footer);
    background-image: none;
    width: auto;
    height: auto;
    bottom: 10px;
    left: 20px;
    right: 20px;
    top: auto;
    text-align: center;
    font-size: 12px;
    color: #666;
    background: rgba(255, 255, 255, 0.8);
    padding: 6px 12px;
    border-radius: 4px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

/* Ensure content doesn't overlap with logos, headers, and footers */
section h1:first-child {
    margin-top: 100px;
}

section[data-header] h1:first-child {
    margin-top: 120px;
}

section[data-footer] {
    padding-bottom: 60px;
}

h1, h2, h3 {
    color: #ffd700;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
}

h1 {
    font-size: 3em;
    margin-bottom: 30px;
}

h2 {
    font-size: 2.2em;
    margin-bottom: 20px;
}

h3 {
    font-size: 1.8em;
    margin-bottom: 15px;
}

p, li {
    font-size: 1.2em;
    line-height: 1.6;
}

code {
    background: rgba(0,0,0,0.3);
    padding: 2px 6px;
    border-radius: 4px;
    font-family: 'Courier New', monospace;
}

pre {
    background: rgba(0,0,0,0.4);
    padding: 20px;
    border-radius: 8px;
    border-left: 4px solid #ffd700;
}

ul, ol {
    margin: 20px 0;
}

li {
    margin: 10px 0;
}

/* Separador de diapositivas */
hr {
    border: none;
    height: 3px;
    background: linear-gradient(90deg, #ffd700, #ff6b6b, #4ecdc4, #45b7d1);
    margin: 40px 0;
}
EOF

# Crear archivo de configuración
if [ "$VERBOSE" = true ]; then
    echo "⚙️  Creando archivo de configuración..."
fi

cat > "$THEME_NAME/marp.config.sh" << EOF
#!/bin/bash

# Archivo de configuración para $THEME_NAME
# Modifica según tus necesidades

# Directorios del proyecto
DEFAULT_MD_SRC_DIR="presentation/md_src"
DEFAULT_MARP_SLIDES_DIR="presentation/marp_slides"
DEFAULT_PDF_SLIDES_DIR="presentation/pdf_slides"
DEFAULT_IMG_SRC_DIR="presentation/img_src"
DEFAULT_STYLE_CSS="presentation/style.css"
DEFAULT_PROGRAMA="programa.md"

# Configuración de logos y fondo
# Descomenta y modifica las rutas según tus necesidades
# DEFAULT_LOGO_LEFT="presentation/img_src/logo_izquierdo.png"
# DEFAULT_LOGO_RIGHT="presentation/img_src/logo_derecho.png"
# DEFAULT_BACKGROUND="presentation/img_src/fondo.jpg"

# Configuración de header y footer
# Descomenta y modifica los textos según tus necesidades
# DEFAULT_HEADER_TEXT="Mi Empresa - Curso de Capacitación"
# DEFAULT_FOOTER_TEXT="Confidencial - Todos los derechos reservados"

# Opciones de Marp
MARP_OPTIONS="--pdf --allow-local-files"
MARP_HTML_OPTIONS="--html --allow-local-files"
MARP_PPTX_OPTIONS="--pptx --allow-local-files"

# Configuración de Python
PYTHON_CMD="python3"

# Configuración de Node.js
NPM_CMD="npm"
MARP_PACKAGE="@marp-team/marp-cli"
EOF

chmod +x "$THEME_NAME/marp.config.sh"

# Crear archivo de ejemplo en md_src
if [ "$VERBOSE" = true ]; then
    echo "📄 Creando archivo de ejemplo..."
fi

cat > "$THEME_NAME/presentation/md_src/introduccion.md" << EOF
# Introducción a $THEME_NAME

## ¿Qué aprenderemos?

- Conceptos fundamentales
- Herramientas principales
- Casos de uso reales

---

## Objetivos del Curso

1. **Comprender** los conceptos básicos
2. **Aplicar** las herramientas en proyectos reales
3. **Desarrollar** habilidades prácticas

---

## Prerrequisitos

- Conocimientos básicos de programación
- Experiencia con terminal/consola
- Motivación para aprender
EOF

# Crear archivo README para el proyecto
if [ "$VERBOSE" = true ]; then
    echo "📖 Creando README del proyecto..."
fi

cat > "$THEME_NAME/README.md" << EOF
# $THEME_NAME

Proyecto de presentaciones creado con los scripts de Marp.

## Estructura del Proyecto

\`\`\`
$THEME_NAME/
├── programa.md                    # Programa del curso
├── marp.config.sh                 # Configuración del proyecto (logos, fondos, etc.)
├── presentation/
│   ├── md_src/                   # Archivos Markdown originales
│   ├── img_src/                  # Imágenes (logos, fondos, etc.)
│   ├── marp_slides/              # Archivos Marp generados
│   ├── pdf_slides/               # PDFs generados
│   ├── img_src/                  # Imágenes para las presentaciones
│   └── style.css                 # Estilos personalizados
└── scripts/                      # Scripts de conversión
\`\`\`

## Uso Rápido

1. **Instalar Marp CLI**:
   \`\`\`bash
   ./scripts/setup_marp.sh
   \`\`\`

2. **Configurar logos, fondos, headers y footers** (opcional):
   - Edita \`marp.config.sh\` y descomenta las líneas de configuración
   - Coloca las imágenes en \`presentation/img_src/\`
   - Configura textos de header y footer según necesites

3. **Convertir todo**:
   \`\`\`bash
   ./scripts/marp_tools.sh all
   \`\`\`

4. **Modo watch** (auto-regenera):
   \`\`\`bash
   ./scripts/marp_tools.sh watch
   \`\`\`

## Logos, Fondos, Headers y Footers

Para agregar logos, fondos, headers y footers a tus presentaciones:

1. **Imágenes**: Coloca las imágenes en \`presentation/img_src/\`
2. **Configuración**: Edita \`marp.config.sh\` y descomenta las líneas de configuración:
   - \`DEFAULT_LOGO_LEFT\`: Logo superior izquierdo
   - \`DEFAULT_LOGO_RIGHT\`: Logo superior derecho  
   - \`DEFAULT_BACKGROUND\`: Imagen de fondo
   - \`DEFAULT_HEADER_TEXT\`: Texto del header (parte superior)
   - \`DEFAULT_FOOTER_TEXT\`: Texto del footer (parte inferior)
3. **Conversión**: Ejecuta la conversión normalmente

Los logos se posicionarán automáticamente en las esquinas superiores, y los headers/footers aparecerán en todas las slides.

## Comandos Disponibles

- \`./scripts/marp_tools.sh md-to-marp\` - Convertir MD a Marp
- \`./scripts/marp_tools.sh convert\` - Convertir Marp a PDF
- \`./scripts/marp_tools.sh all\` - Convertir todo de una vez
- \`./scripts/marp_tools.sh watch\` - Modo watch
- \`./scripts/marp_tools.sh config\` - Ver configuración

## Personalización

1. **Editar contenido**: Modifica los archivos en \`presentation/md_src/\`
2. **Personalizar estilos**: Edita \`presentation/style.css\`
3. **Actualizar programa**: Modifica \`programa.md\`

Para más información, consulta \`scripts/README.md\`.
EOF

echo ""
echo "🎉 ¡Proyecto creado exitosamente!"
echo ""
echo "📁 Estructura creada:"
echo "   $THEME_NAME/"
echo "   ├── programa.md"
echo "   ├── presentation/"
echo "   │   ├── md_src/introduccion.md"
echo "   │   ├── marp_slides/ (vacío)"
echo "   │   ├── pdf_slides/ (vacío)"
echo "   │   ├── img_src/ (vacío)"
echo "   │   └── style.css"
echo "   ├── scripts/ (copiados)"
echo "   └── README.md"
echo ""
echo "📝 Próximos pasos:"
echo "   1. cd $THEME_NAME"
echo "   2. ./scripts/setup_marp.sh"
echo "   3. ./scripts/marp_tools.sh all"
echo "   4. Edita los archivos en presentation/md_src/"
echo ""
echo "💡 Para ver las presentaciones:"
echo "   - Abre los PDFs en presentation/pdf_slides/"
echo "   - O usa: ./scripts/marp_tools.sh watch"
