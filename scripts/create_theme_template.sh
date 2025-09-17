#!/bin/bash

# Script to create a new theme based on the example theme
# Author: AI Assistant

# Configuration
VERBOSE=false
THEME_NAME=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
THEMES_DIR="$PROJECT_ROOT/themes"
EXAMPLE_THEME_DIR="$THEMES_DIR/example"

# Help function
show_help() {
    echo "Usage: $0 THEME_NAME [OPTIONS]"
    echo ""
    echo "Creates a new theme in the themes/ directory based on the example theme"
    echo ""
    echo "Arguments:"
    echo "  THEME_NAME               Name of the new theme"
    echo ""
    echo "Options:"
    echo "  -v, --verbose            Verbose mode"
    echo "  -h, --help               Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 fine-tuning           # Create theme 'fine-tuning'"
    echo "  $0 machine-learning -v   # Create theme with verbose mode"
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

# Check if example theme exists
if [ ! -d "$EXAMPLE_THEME_DIR" ]; then
    echo "❌ Error: Example theme not found at $EXAMPLE_THEME_DIR"
    exit 1
fi

# Target theme directory
TARGET_THEME_DIR="$THEMES_DIR/$THEME_NAME"

# Check if theme already exists
if [ -d "$TARGET_THEME_DIR" ]; then
    echo "❌ Error: Theme '$THEME_NAME' already exists at $TARGET_THEME_DIR"
    exit 1
fi

echo "🚀 Creating theme: $THEME_NAME"

# Create themes directory if it doesn't exist
mkdir -p "$THEMES_DIR"

# Create the target theme directory structure
if [ "$VERBOSE" = true ]; then
    echo "📁 Creating theme directory structure..."
fi

mkdir -p "$TARGET_THEME_DIR/presentation/img_src"
mkdir -p "$TARGET_THEME_DIR/presentation/md_src"
mkdir -p "$TARGET_THEME_DIR/presentation/marp_slides"
mkdir -p "$TARGET_THEME_DIR/presentation/pdf_slides"

# Copy specific files only (source files, not generated ones)
if [ "$VERBOSE" = true ]; then
    echo "📄 Copying source files..."
fi

# Copy configuration file
cp "$EXAMPLE_THEME_DIR/marp.config.sh" "$TARGET_THEME_DIR/"

# Copy program.md (will be updated later)
cp "$EXAMPLE_THEME_DIR/program.md" "$TARGET_THEME_DIR/"

# Copy style.css
cp "$EXAMPLE_THEME_DIR/presentation/style.css" "$TARGET_THEME_DIR/presentation/"

# Copy all images from img_src
cp "$EXAMPLE_THEME_DIR/presentation/img_src/"* "$TARGET_THEME_DIR/presentation/img_src/"

# Copy only the introduction.md file from md_src (not all md files)
cp "$EXAMPLE_THEME_DIR/presentation/md_src/introduction.md" "$TARGET_THEME_DIR/presentation/md_src/"

# Update the marp.config.sh file with the new theme name
if [ "$VERBOSE" = true ]; then
    echo "⚙️  Updating configuration file..."
fi

sed -i "s/theme-example/$THEME_NAME/g" "$TARGET_THEME_DIR/marp.config.sh"

# Update program.md with a generic template
if [ "$VERBOSE" = true ]; then
    echo "📄 Creating program template..."
fi

cat > "$TARGET_THEME_DIR/program.md" << EOF
# $THEME_NAME Program

## Module 1: Introduction
- Basic concepts
- Required tools
- Environment setup

## Module 2: Development
- Step-by-step implementation
- Best practices
- Use cases

## Module 3: Practice
- Practical exercises
- Final project
- Evaluation
EOF

# Update the markdown file to reference the new theme
if [ "$VERBOSE" = true ]; then
    echo "📝 Updating introduction.md..."
fi

# Update introduction.md with theme-specific content
cat > "$TARGET_THEME_DIR/presentation/md_src/introduction.md" << EOF
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

echo ""
echo "🎉 Theme created successfully!"
echo ""
echo "📁 Structure created in themes/$THEME_NAME/:"
echo "   ├── program.md"
echo "   ├── marp.config.sh"
echo "   └── presentation/"
echo "       ├── img_src/ (logos and images copied)"
echo "       │   ├── background.png"
echo "       │   ├── example.jpg"
echo "       │   ├── logo_left.png"
echo "       │   └── logo_right.png"
echo "       ├── md_src/"
echo "       │   └── introduction.md"
echo "       ├── marp_slides/ (empty)"
echo "       ├── pdf_slides/ (empty)"
echo "       └── style.css"
echo ""
echo "📝 Next steps:"
echo "   1. make all THEME=$THEME_NAME"
echo "   2. Edit files in themes/$THEME_NAME/presentation/md_src/"
echo "   3. Customize logos in themes/$THEME_NAME/presentation/img_src/"
echo ""
echo "💡 To use this theme:"
echo "   - make all THEME=$THEME_NAME"
echo "   - make watch THEME=$THEME_NAME"
