#!/bin/bash

# Script to create a new project with the recommended structure
# Author: AI Assistant

# Configuration
VERBOSE=false
THEME_NAME=""

# Help function
show_help() {
    echo "Usage: $0 THEME_NAME [OPTIONS]"
    echo ""
    echo "Creates a new project with the recommended structure for Marp presentations"
    echo ""
    echo "Arguments:"
    echo "  THEME_NAME               Name of the theme/project"
    echo ""
    echo "Options:"
    echo "  -v, --verbose            Verbose mode"
    echo "  -h, --help               Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 my-ai-course          # Create project 'my-ai-course'"
    echo "  $0 machine-learning -v   # Create project with verbose mode"
    echo ""
}

# Process arguments
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
            echo "❌ Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            if [ -z "$THEME_NAME" ]; then
                THEME_NAME="$1"
            else
                echo "❌ Only one theme name can be specified"
                show_help
                exit 1
            fi
            shift
            ;;
    esac
done

# Verify that theme name was provided
if [ -z "$THEME_NAME" ]; then
    echo "❌ Error: Theme name is required"
    show_help
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Creating project: $THEME_NAME"

# Create directory structure
if [ "$VERBOSE" = true ]; then
    echo "📁 Creating directory structure..."
fi

mkdir -p "$THEME_NAME/presentation/md_src"
mkdir -p "$THEME_NAME/presentation/marp_slides"
mkdir -p "$THEME_NAME/presentation/pdf_slides"
mkdir -p "$THEME_NAME/presentation/img_src"

# Copy scripts
if [ "$VERBOSE" = true ]; then
    echo "📋 Copying scripts..."
fi

cp -r "$SCRIPT_DIR" "$THEME_NAME/"

# Create programa.md file
if [ "$VERBOSE" = true ]; then
    echo "📝 Creating programa.md file..."
fi

cat > "$THEME_NAME/programa.md" << EOF
# Course Program: $THEME_NAME

## Module 1: Introduction
- Basic concepts
- Necessary tools
- Environment setup

## Module 2: Development
- Step-by-step implementation
- Best practices
- Use cases

## Module 3: Practice
- Practical exercises
- Final project
- Evaluation

---

*This file contains the general course program. Detailed presentations are in presentation/md_src/*
EOF

# Create CSS styles file
if [ "$VERBOSE" = true ]; then
    echo "🎨 Creating styles file..."
fi

cat > "$THEME_NAME/presentation/style.css" << 'EOF'
/* Custom styles for presentations */

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

/* Slide separator */
hr {
    border: none;
    height: 3px;
    background: linear-gradient(90deg, #ffd700, #ff6b6b, #4ecdc4, #45b7d1);
    margin: 40px 0;
}
EOF

# Create configuration file
if [ "$VERBOSE" = true ]; then
    echo "⚙️  Creating configuration file..."
fi

cat > "$THEME_NAME/marp.config.sh" << EOF
#!/bin/bash

# Configuration file for $THEME_NAME
# Modify according to your needs

# Project directories
DEFAULT_MD_SRC_DIR="presentation/md_src"
DEFAULT_MARP_SLIDES_DIR="presentation/marp_slides"
DEFAULT_PDF_SLIDES_DIR="presentation/pdf_slides"
DEFAULT_IMG_SRC_DIR="presentation/img_src"
DEFAULT_STYLE_CSS="presentation/style.css"
DEFAULT_PROGRAMA="programa.md"

# Logo and background configuration
# Uncomment and modify paths according to your needs
# DEFAULT_LOGO_LEFT="presentation/img_src/left_logo.png"
# DEFAULT_LOGO_RIGHT="presentation/img_src/right_logo.png"
# DEFAULT_BACKGROUND="presentation/img_src/background.jpg"

# Header and footer configuration
# Uncomment and modify texts according to your needs
# DEFAULT_HEADER_TEXT="My Company - Training Course"
# DEFAULT_FOOTER_TEXT="Confidential - All rights reserved"

# Marp options
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

# Create example file in md_src
if [ "$VERBOSE" = true ]; then
    echo "📄 Creating example file..."
fi

cat > "$THEME_NAME/presentation/md_src/introduccion.md" << EOF
# Introduction to $THEME_NAME

## What will we learn?

- Fundamental concepts
- Main tools
- Real use cases

---

## Course Objectives

1. **Understand** basic concepts
2. **Apply** tools in real projects
3. **Develop** practical skills

---

## Prerequisites

- Basic programming knowledge
- Terminal/console experience
- Motivation to learn
EOF

# Create README file for the project
if [ "$VERBOSE" = true ]; then
    echo "📖 Creating project README..."
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
echo "🎉 Project created successfully!"
echo ""
echo "📁 Structure created:"
echo "   $THEME_NAME/"
echo "   ├── programa.md"
echo "   ├── presentation/"
echo "   │   ├── md_src/introduccion.md"
echo "   │   ├── marp_slides/ (empty)"
echo "   │   ├── pdf_slides/ (empty)"
echo "   │   ├── img_src/ (empty)"
echo "   │   └── style.css"
echo "   ├── scripts/ (copied)"
echo "   └── README.md"
echo ""
echo "📝 Next steps:"
echo "   1. cd $THEME_NAME"
echo "   2. ./scripts/setup_marp.sh"
echo "   3. ./scripts/marp_tools.sh all"
echo "   4. Edit files in presentation/md_src/"
echo ""
echo "💡 To view presentations:"
echo "   - Open PDFs in presentation/pdf_slides/"
echo "   - Or use: ./scripts/marp_tools.sh watch"
