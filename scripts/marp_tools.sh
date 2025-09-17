#!/bin/bash

# Main tools for Marp
# Unified script for all Marp operations
# Reusable for different projects/themes
# Author: AI Assistant

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Configuration
VERBOSE=false
DRY_RUN=false

# Help function
show_help() {
    echo "Marp Tools - Unified script"
    echo ""
    echo "Usage: $0 COMMAND [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  setup                    Install Marp CLI"
    echo "  md-to-marp               Convert MD files to Marp format"
    echo "  convert                  Convert Marp files to PDF"
    echo "  convert-program          Convert program.md directly to PDF"
    echo "  convert-html             Convert Marp files to HTML"
    echo "  convert-pptx             Convert Marp files to PowerPoint"
    echo "  watch                    Watch mode (auto-regenerate)"
    echo "  all                      Convert MD to Marp then to PDF"
    echo "  config                   Show current configuration"
    echo "  validate                 Validate configuration"
    echo "  create-example           Create example configuration file"
    echo ""
    echo "Global options:"
    echo "  -v, --verbose            Verbose mode"
    echo "  -d, --dry-run            Show commands without executing"
    echo "  -h, --help               Show this help"
    echo ""
    echo "Conversion options:"
    echo "  -i, --input DIR          Input directory (default: $DEFAULT_INPUT_DIR)"
    echo "  -o, --output DIR         Output directory (default: $DEFAULT_OUTPUT_DIR)"
    echo "  -t, --theme THEME        CSS theme to use"
    echo "  --logo-left PATH         Path to left logo (upper-left)"
    echo "  --logo-right PATH        Path to right logo (upper-right)"
    echo "  --background PATH        Path to background image"
    echo "  --header TEXT            Header text (top part)"
    echo "  --footer TEXT            Footer text (bottom part)"
    echo "  -p, --project-dir DIR    Project directory"
    echo ""
    echo "Examples:"
    echo "  $0 setup                              # Install Marp"
    echo "  $0 convert                            # Convert to PDF"
    echo "  $0 convert -i slides -o pdfs          # Custom directories"
    echo "  $0 convert-html -t custom-theme       # Convert to HTML with theme"
    echo "  $0 md-to-marp --logo-left logo1.png --logo-right logo2.png --background bg.jpg --header 'My Company' --footer 'Confidential'"
    echo "  $0 watch -i slides                    # Watch mode"
    echo ""
}

# Function to execute command with options
run_command() {
    local cmd="$1"
    shift
    
    if [ "$VERBOSE" = true ]; then
        echo "🔧 Executing: $cmd $*"
    fi
    
    if [ "$DRY_RUN" = true ]; then
        echo "🔍 [DRY RUN] $cmd $*"
        return 0
    fi
    
    eval "$cmd $*"
    return $?
}

# Function for setup
cmd_setup() {
    echo "🚀 Setting up Marp..."
    run_command "bash $SCRIPT_DIR/setup_marp.sh" "$@"
}

# Function to convert MD to Marp
cmd_md_to_marp() {
    echo "📝 Converting Markdown files to Marp format..."
    
    # Process specific arguments
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
    
    # Load theme-specific configuration if project_dir is specified
    if [ -n "$project_dir" ]; then
        load_theme_config "$project_dir"
    fi
    
    # Build command
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

# Function to convert to PDF
cmd_convert() {
    echo "🔄 Converting Marp files to PDF..."
    
    # Process specific convert arguments
    local convert_args=()
    local project_dir=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --project-dir)
                project_dir="$2"
                convert_args+=("$1" "$2")
                shift 2
                ;;
            -v|--verbose)
                convert_args+=("$1")
                shift
                ;;
            -d|--dry-run)
                # Convert dry-run to verbose for run_conversion.sh
                convert_args+=("-v")
                shift
                ;;
            *)
                convert_args+=("$1")
                shift
                ;;
        esac
    done
    
    # Load theme-specific configuration if project_dir is specified
    if [ -n "$project_dir" ]; then
        load_theme_config "$project_dir"
    fi
    
    run_command "bash $SCRIPT_DIR/run_conversion.sh" "${convert_args[@]}"
}

# Function to convert program.md directly to PDF
cmd_convert_program() {
    echo "📄 Converting program.md directly to PDF..."
    
    # Process specific arguments
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
    
    # If project_dir is not specified, use current directory
    if [ -z "$project_dir" ]; then
        project_dir="."
    fi
    
    # Load theme-specific configuration
    load_theme_config "$project_dir"
    
    # Look for program.md in project directory
    local program_file="$project_dir/program.md"
    
    if [ ! -f "$program_file" ]; then
        echo "❌ program.md not found in $project_dir"
        return 1
    fi
    
    echo "📄 Found: $program_file"
    
    # Create marp command with A4 theme
    local a4_theme="$SCRIPT_DIR/a4-theme.css"
    local cmd="marp '$program_file' --pdf --output '$project_dir/program.pdf' --allow-local-files --theme '$a4_theme'"
    
    if [ "$verbose" = true ]; then
        cmd="$cmd --verbose"
    fi
    
    # Execute conversion
    echo "🔄 Executing: $cmd"
    eval $cmd
    
    if [ $? -eq 0 ]; then
        echo "✅ program.pdf generated successfully in $project_dir/"
    else
        echo "❌ Error converting program.md to PDF"
        return 1
    fi
}

# Function to convert to HTML
cmd_convert_html() {
    local input_dir="$DEFAULT_INPUT_DIR"
    local output_dir="$DEFAULT_OUTPUT_DIR"
    local theme="$DEFAULT_THEME"
    local project_dir=""
    
    # Process arguments
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
    
    # Resolve project directory
    if [ -z "$project_dir" ]; then
        project_dir="$(dirname "$SCRIPT_DIR")"
    fi
    
    # Create output directory
    mkdir -p "$project_dir/$output_dir"
    
    # Convert files
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

# Function to convert to PowerPoint
cmd_convert_pptx() {
    local input_dir="$DEFAULT_INPUT_DIR"
    local output_dir="$DEFAULT_OUTPUT_DIR"
    local project_dir=""
    
    # Process arguments
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
    
    # Resolve project directory
    if [ -z "$project_dir" ]; then
        project_dir="$(dirname "$SCRIPT_DIR")"
    fi
    
    # Create output directory
    mkdir -p "$project_dir/$output_dir"
    
    # Convert files
    for file in "$project_dir/$input_dir"/*.md; do
        if [ -f "$file" ]; then
            local basename=$(basename "$file" .md)
            local output_file="$project_dir/$output_dir/$basename.pptx"
            
            run_command "marp $file --pptx --output $output_file"
        fi
    done
}

# Function for watch mode
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
    
    # Resolve project directory
    if [ -z "$project_dir" ]; then
        project_dir="$(dirname "$SCRIPT_DIR")"
    fi
    
    echo "👀 Starting watch mode in $project_dir/$input_dir"
    echo "   Press Ctrl+C to exit"
    echo ""
    
    run_command "marp $project_dir/$input_dir --watch"
}

# Function to convert everything (MD -> Marp -> PDF)
cmd_all() {
    echo "🔄 Converting everything: MD -> Marp -> PDF + program.md -> PDF..."
    
    # Step 1: Convert files from md_src/ to Marp then to PDF
    echo "📝 Step 1: Converting files from md_src/ (MD -> Marp -> PDF)..."
    cmd_md_to_marp "$@"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🔄 Step 2: Converting Marp files to PDF..."
        cmd_convert "$@"
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "📄 Step 3: Converting program.md directly to PDF..."
            cmd_convert_program "$@"
        else
            echo "❌ Error in Marp to PDF conversion"
            return 1
        fi
    else
        echo "❌ Error in MD to Marp conversion"
        return 1
    fi
}

# Main function
main() {
    # Process global arguments
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
                echo "❌ Unknown command: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Verify that a command was provided
    if [ $# -eq 0 ]; then
        echo "❌ Error: A command is required"
        show_help
        exit 1
    fi
    
    local command="$1"
    shift
    
    # Execute corresponding command
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
            echo "❌ Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Execute main function
main "$@"
