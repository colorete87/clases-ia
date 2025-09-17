#!/bin/bash

# Herramientas principales para Marp
# Script unificado para todas las operaciones de Marp
# Reutilizable para diferentes proyectos/temas
# Autor: Asistente IA

# Cargar configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Configuración
VERBOSE=false
DRY_RUN=false

# Función de ayuda
show_help() {
    echo "Herramientas de Marp - Script unificado"
    echo ""
    echo "Uso: $0 COMANDO [OPCIONES]"
    echo ""
    echo "Comandos:"
    echo "  setup                    Instalar Marp CLI"
    echo "  md-to-marp               Convertir archivos MD a formato Marp"
    echo "  convert                  Convertir archivos Marp a PDF"
    echo "  convert-program          Convertir program.md directamente a PDF"
    echo "  convert-html             Convertir archivos Marp a HTML"
    echo "  convert-pptx             Convertir archivos Marp a PowerPoint"
    echo "  watch                    Modo watch (auto-regenera)"
    echo "  all                      Convertir MD a Marp y luego a PDF"
    echo "  config                   Mostrar configuración actual"
    echo "  validate                 Validar configuración"
    echo "  create-example           Crear archivo de configuración de ejemplo"
    echo ""
    echo "Opciones globales:"
    echo "  -v, --verbose            Modo verboso"
    echo "  -d, --dry-run            Mostrar comandos sin ejecutar"
    echo "  -h, --help               Mostrar esta ayuda"
    echo ""
    echo "Opciones de conversión:"
    echo "  -i, --input DIR          Directorio de entrada (default: $DEFAULT_INPUT_DIR)"
    echo "  -o, --output DIR         Directorio de salida (default: $DEFAULT_OUTPUT_DIR)"
    echo "  -t, --theme THEME        Tema CSS a usar"
    echo "  --logo-left PATH         Ruta al logo izquierdo (upper-left)"
    echo "  --logo-right PATH        Ruta al logo derecho (upper-right)"
    echo "  --background PATH        Ruta a la imagen de fondo"
    echo "  --header TEXT            Texto del header (parte superior)"
    echo "  --footer TEXT            Texto del footer (parte inferior)"
    echo "  -p, --project-dir DIR    Directorio del proyecto"
    echo ""
    echo "Ejemplos:"
    echo "  $0 setup                              # Instalar Marp"
    echo "  $0 convert                            # Convertir a PDF"
    echo "  $0 convert -i slides -o pdfs          # Directorios personalizados"
    echo "  $0 convert-html -t custom-theme       # Convertir a HTML con tema"
    echo "  $0 md-to-marp --logo-left logo1.png --logo-right logo2.png --background bg.jpg --header 'My Company' --footer 'Confidential'"
    echo "  $0 watch -i slides                    # Modo watch"
    echo ""
}

# Función para ejecutar comando con opciones
run_command() {
    local cmd="$1"
    shift
    
    if [ "$VERBOSE" = true ]; then
        echo "🔧 Ejecutando: $cmd $*"
    fi
    
    if [ "$DRY_RUN" = true ]; then
        echo "🔍 [DRY RUN] $cmd $*"
        return 0
    fi
    
    eval "$cmd $*"
    return $?
}

# Función para setup
cmd_setup() {
    echo "🚀 Configurando Marp..."
    run_command "bash $SCRIPT_DIR/setup_marp.sh" "$@"
}

# Función para convertir MD a Marp
cmd_md_to_marp() {
    echo "📝 Convirtiendo archivos Markdown a formato Marp..."
    
    # Procesar argumentos específicos
    local md_src="$DEFAULT_MD_SRC_DIR"
    local marp_slides="$DEFAULT_MARP_SLIDES_DIR"
    local theme="$DEFAULT_THEME"
    local style_css="$DEFAULT_STYLE_CSS"
    local programa="$DEFAULT_PROGRAMA"
    local logo_left="$DEFAULT_LOGO_LEFT"
    local logo_right="$DEFAULT_LOGO_RIGHT"
    local background="$DEFAULT_BACKGROUND"
    local header_text="$DEFAULT_HEADER_TEXT"
    local footer_text="$DEFAULT_FOOTER_TEXT"
    local project_dir=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--input)
                md_src="$2"
                shift 2
                ;;
            -o|--output)
                marp_slides="$2"
                shift 2
                ;;
            -t|--theme)
                theme="$2"
                shift 2
                ;;
            -s|--style)
                style_css="$2"
                shift 2
                ;;
            -p|--programa)
                programa="$2"
                shift 2
                ;;
            --logo-left)
                logo_left="$2"
                shift 2
                ;;
            --logo-right)
                logo_right="$2"
                shift 2
                ;;
            --background)
                background="$2"
                shift 2
                ;;
            --header)
                header_text="$2"
                shift 2
                ;;
            --footer)
                footer_text="$2"
                shift 2
                ;;
            --project-dir)
                project_dir="$2"
                shift 2
                ;;
            -v|--verbose)
                shift
                ;;
            -d|--dry-run)
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
    
    # Construir comando
    local cmd="python3 $SCRIPT_DIR/convert_md_to_marp.py"
    cmd="$cmd '$md_src'"
    cmd="$cmd -o '$marp_slides'"
    
    if [ -n "$theme" ]; then
        cmd="$cmd -t '$theme'"
    fi
    
    if [ -n "$style_css" ]; then
        cmd="$cmd -s '$style_css'"
    fi
    
    if [ -n "$programa" ]; then
        cmd="$cmd -p '$programa'"
    fi
    
    if [ -n "$logo_left" ]; then
        cmd="$cmd --logo-left '$logo_left'"
    fi
    
    if [ -n "$logo_right" ]; then
        cmd="$cmd --logo-right '$logo_right'"
    fi
    
    if [ -n "$background" ]; then
        cmd="$cmd --background '$background'"
    fi
    
    if [ -n "$header_text" ]; then
        cmd="$cmd --header '$header_text'"
    fi
    
    if [ -n "$footer_text" ]; then
        cmd="$cmd --footer '$footer_text'"
    fi
    
    if [ -n "$project_dir" ]; then
        cmd="$cmd --project-dir '$project_dir'"
    fi
    
    run_command "$cmd"
}

# Función para convertir a PDF
cmd_convert() {
    echo "🔄 Convirtiendo archivos Marp a PDF..."
    
    # Procesar argumentos específicos de convert
    local convert_args=()
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                convert_args+=("$1")
                shift
                ;;
            -d|--dry-run)
                # Convertir dry-run a verbose para run_conversion.sh
                convert_args+=("-v")
                shift
                ;;
            *)
                convert_args+=("$1")
                shift
                ;;
        esac
    done
    
    run_command "bash $SCRIPT_DIR/run_conversion.sh" "${convert_args[@]}"
}

# Función para convertir program.md directamente a PDF
cmd_convert_program() {
    echo "📄 Convirtiendo program.md directamente a PDF..."
    
    # Procesar argumentos específicos
    local project_dir=""
    local theme=""
    local verbose=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --project-dir)
                project_dir="$2"
                shift 2
                ;;
            -t|--theme)
                theme="$2"
                shift 2
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
    
    # Si no se especifica project_dir, usar el directorio actual
    if [ -z "$project_dir" ]; then
        project_dir="."
    fi
    
    # Buscar program.md en el directorio del proyecto
    local program_file="$project_dir/program.md"
    
    if [ ! -f "$program_file" ]; then
        echo "❌ No se encontró program.md en $project_dir"
        return 1
    fi
    
    echo "📄 Encontrado: $program_file"
    
    # Crear comando marp con tema A4
    local a4_theme="$SCRIPT_DIR/a4-theme.css"
    local cmd="marp '$program_file' --pdf --output '$project_dir/program.pdf' --allow-local-files --theme '$a4_theme'"
    
    if [ "$verbose" = true ]; then
        cmd="$cmd --verbose"
    fi
    
    # Ejecutar conversión
    echo "🔄 Ejecutando: $cmd"
    eval $cmd
    
    if [ $? -eq 0 ]; then
        echo "✅ program.pdf generado exitosamente en $project_dir/"
    else
        echo "❌ Error al convertir program.md a PDF"
        return 1
    fi
}

# Función para convertir a HTML
cmd_convert_html() {
    local input_dir="$DEFAULT_INPUT_DIR"
    local output_dir="$DEFAULT_OUTPUT_DIR"
    local theme="$DEFAULT_THEME"
    local project_dir=""
    
    # Procesar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--input)
                input_dir="$2"
                shift 2
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            -t|--theme)
                theme="$2"
                shift 2
                ;;
            -p|--project-dir)
                project_dir="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    
    # Resolver directorio del proyecto
    if [ -z "$project_dir" ]; then
        project_dir="$(dirname "$SCRIPT_DIR")"
    fi
    
    # Crear directorio de salida
    mkdir -p "$project_dir/$output_dir"
    
    # Convertir archivos
    for file in "$project_dir/$input_dir"/*.md; do
        if [ -f "$file" ]; then
            local basename=$(basename "$file" .md)
            local output_file="$project_dir/$output_dir/$basename.html"
            
            local cmd="marp $file --html --output $output_file"
            if [ -n "$theme" ]; then
                local css_file="$SCRIPT_DIR/$theme.css"
                if [ -f "$css_file" ]; then
                    cmd="$cmd --theme $css_file"
                fi
            fi
            
            run_command "$cmd"
        fi
    done
}

# Función para convertir a PowerPoint
cmd_convert_pptx() {
    local input_dir="$DEFAULT_INPUT_DIR"
    local output_dir="$DEFAULT_OUTPUT_DIR"
    local project_dir=""
    
    # Procesar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--input)
                input_dir="$2"
                shift 2
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            -p|--project-dir)
                project_dir="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    
    # Resolver directorio del proyecto
    if [ -z "$project_dir" ]; then
        project_dir="$(dirname "$SCRIPT_DIR")"
    fi
    
    # Crear directorio de salida
    mkdir -p "$project_dir/$output_dir"
    
    # Convertir archivos
    for file in "$project_dir/$input_dir"/*.md; do
        if [ -f "$file" ]; then
            local basename=$(basename "$file" .md)
            local output_file="$project_dir/$output_dir/$basename.pptx"
            
            run_command "marp $file --pptx --output $output_file"
        fi
    done
}

# Función para modo watch
cmd_watch() {
    local input_dir="$DEFAULT_INPUT_DIR"
    local project_dir=""
    
    # Procesar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--input)
                input_dir="$2"
                shift 2
                ;;
            -p|--project-dir)
                project_dir="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    
    # Resolver directorio del proyecto
    if [ -z "$project_dir" ]; then
        project_dir="$(dirname "$SCRIPT_DIR")"
    fi
    
    echo "👀 Iniciando modo watch en $project_dir/$input_dir"
    echo "   Presiona Ctrl+C para salir"
    echo ""
    
    run_command "marp $project_dir/$input_dir --watch"
}

# Función para convertir todo (MD -> Marp -> PDF)
cmd_all() {
    echo "🔄 Convirtiendo todo: MD -> Marp -> PDF + program.md -> PDF..."
    
    # Paso 1: Convertir archivos de md_src/ a Marp y luego a PDF
    echo "📝 Paso 1: Convirtiendo archivos de md_src/ (MD -> Marp -> PDF)..."
    cmd_md_to_marp "$@"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🔄 Paso 2: Convirtiendo archivos Marp a PDF..."
        cmd_convert "$@"
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "📄 Paso 3: Convirtiendo program.md directamente a PDF..."
            cmd_convert_program "$@"
        else
            echo "❌ Error en la conversión Marp a PDF"
            return 1
        fi
    else
        echo "❌ Error en la conversión MD a Marp"
        return 1
    fi
}

# Función principal
main() {
    # Procesar argumentos globales
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            setup|md-to-marp|convert|convert-program|convert-html|convert-pptx|watch|all|config|validate|create-example)
                break
                ;;
            *)
                echo "❌ Comando desconocido: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Verificar que se proporcionó un comando
    if [ $# -eq 0 ]; then
        echo "❌ Error: Se requiere un comando"
        show_help
        exit 1
    fi
    
    local command="$1"
    shift
    
    # Ejecutar comando correspondiente
    case $command in
        setup)
            cmd_setup "$@"
            ;;
        md-to-marp)
            cmd_md_to_marp "$@"
            ;;
        convert)
            cmd_convert "$@"
            ;;
        convert-program)
            cmd_convert_program "$@"
            ;;
        convert-html)
            cmd_convert_html "$@"
            ;;
        convert-pptx)
            cmd_convert_pptx "$@"
            ;;
        watch)
            cmd_watch "$@"
            ;;
        all)
            cmd_all "$@"
            ;;
        config)
            show_config
            ;;
        validate)
            validate_config
            ;;
        create-example)
            create_example_config "$(dirname "$SCRIPT_DIR")/marp.config.example.sh"
            ;;
        *)
            echo "❌ Comando desconocido: $command"
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"
