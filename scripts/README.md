# Scripts de Marp - Herramientas Reutilizables

Este conjunto de scripts permite convertir archivos Markdown a presentaciones usando Marp CLI. Los scripts están diseñados para ser reutilizables en diferentes proyectos y temas.

## 📁 Estructura de Archivos

```
scripts/
├── README.md                 # Este archivo
├── config.sh                # Configuración por defecto
├── marp_tools.sh            # Script principal unificado
├── setup_marp.sh            # Instalar Marp CLI
├── run_conversion.sh        # Convertir Marp a PDF
├── convert_marp_to_pdf.py   # Script Python para conversión
├── convert_md_to_marp.py    # Script Python para convertir MD a Marp
└── small-fonts.css          # Tema CSS personalizado (si existe)
```

## 📁 Estructura de Proyecto Recomendada

```
<nombre_del_tema>/
├── programa.md                    # Programa del curso/tema
├── presentacion/
│   ├── md_src/                   # Archivos Markdown originales
│   │   ├── introduccion.md
│   │   ├── desarrollo.md
│   │   └── practica.md
│   ├── marp_slides/              # Archivos Marp generados automáticamente
│   │   ├── introduccion.md
│   │   ├── desarrollo.md
│   │   └── practica.md
│   ├── pdf_slides/               # PDFs generados
│   │   ├── introduccion.pdf
│   │   ├── desarrollo.pdf
│   │   └── practica.pdf
│   ├── img_src/                  # Imágenes para las presentaciones
│   │   ├── diagrama1.png
│   │   ├── logo.png
│   │   └── grafico.svg
│   └── style.css                 # Estilos personalizados para las presentaciones
└── scripts/                      # Scripts de conversión (copiados)
    ├── marp_tools.sh
    ├── config.sh
    └── ...
```

## 🚀 Uso Rápido

### 1. Instalar Marp CLI
```bash
./scripts/setup_marp.sh
```

### 2. Convertir archivos MD a Marp y luego a PDF
```bash
./scripts/marp_tools.sh all        # Convertir todo: MD -> Marp -> PDF
```

### 3. Usar el script unificado (recomendado)
```bash
./scripts/marp_tools.sh setup      # Instalar Marp
./scripts/marp_tools.sh md-to-marp # Convertir MD a Marp
./scripts/marp_tools.sh convert    # Convertir Marp a PDF
./scripts/marp_tools.sh all        # Convertir todo de una vez
./scripts/marp_tools.sh watch      # Modo watch
```

## 📋 Comandos Disponibles

### Script Unificado (`marp_tools.sh`)

```bash
# Instalar Marp CLI
./scripts/marp_tools.sh setup

# Convertir archivos MD a formato Marp
./scripts/marp_tools.sh md-to-marp

# Convertir archivos Marp a PDF
./scripts/marp_tools.sh convert

# Convertir todo de una vez (MD -> Marp -> PDF)
./scripts/marp_tools.sh all

# Convertir a HTML
./scripts/marp_tools.sh convert-html

# Convertir a PowerPoint
./scripts/marp_tools.sh convert-pptx

# Modo watch (auto-regenera)
./scripts/marp_tools.sh watch

# Mostrar configuración
./scripts/marp_tools.sh config

# Validar configuración
./scripts/marp_tools.sh validate

# Crear archivo de configuración de ejemplo
./scripts/marp_tools.sh create-example
```

### Opciones Comunes

```bash
# Especificar directorios personalizados
./scripts/marp_tools.sh convert -i mis_slides -o mis_pdfs

# Usar tema personalizado
./scripts/marp_tools.sh convert -t mi_tema

# Modo verboso
./scripts/marp_tools.sh convert -v

# Modo dry-run (mostrar comandos sin ejecutar)
./scripts/marp_tools.sh convert -d
```

## ⚙️ Configuración

### Configuración por Defecto

Los scripts usan la siguiente configuración por defecto:

- **Directorio de entrada**: `marp_slides/`
- **Directorio de salida**: `pdf_slides/`
- **Tema**: Por defecto de Marp
- **Comando Python**: `python3`
- **Comando npm**: `npm`

### Personalizar Configuración

1. **Crear archivo de configuración del proyecto**:
   ```bash
   ./scripts/marp_tools.sh create-example
   ```

2. **Editar el archivo generado** (`marp.config.example.sh`):
   ```bash
   # Renombrar y editar
   mv marp.config.example.sh marp.config.sh
   nano marp.config.sh
   ```

3. **Ejemplo de configuración personalizada**:
   ```bash
   #!/bin/bash
   
   # Directorios personalizados
   DEFAULT_INPUT_DIR="presentaciones"
   DEFAULT_OUTPUT_DIR="pdfs"
   DEFAULT_THEME="mi_tema"
   
   # Opciones adicionales de Marp
   MARP_OPTIONS="--pdf --allow-local-files"
   ```

## 🎨 Temas Personalizados

Para usar temas personalizados:

1. **Crear archivo CSS** en `scripts/`:
   ```bash
   # Ejemplo: scripts/mi_tema.css
   section {
       font-size: 18px;
       color: #333;
   }
   ```

2. **Usar el tema**:
   ```bash
   ./scripts/marp_tools.sh convert -t mi_tema
   ```

## 🖼️ Manejo de Imágenes

### Estructura de Imágenes

Las imágenes se organizan en la carpeta `img_src/` dentro de cada tema:

```
presentacion/
├── img_src/                    # Imágenes fuente
│   ├── diagrama1.png
│   ├── logo.png
│   ├── grafico.svg
│   └── screenshots/
│       ├── pantalla1.png
│       └── pantalla2.png
└── marp_slides/               # Las imágenes se copian aquí automáticamente
    └── images/
        ├── diagrama1.png
        ├── logo.png
        └── grafico.svg
```

### Uso de Imágenes en Markdown

En tus archivos Markdown, referencia las imágenes desde `images/`:

```markdown
# Mi Presentación

![Diagrama de flujo](images/diagrama1.png)

---

## Captura de pantalla

![Pantalla principal](images/screenshots/pantalla1.png)
```

### Comandos para Imágenes

```bash
# Ver imágenes disponibles
make images

# Copiar imágenes a marp_slides
make copy-images

# Convertir todo (incluye copia de imágenes)
make all
```

## 📁 Estructura de Proyecto Típica

```
mi_proyecto/
├── scripts/                 # Scripts de Marp (copiados)
│   ├── marp_tools.sh
│   ├── config.sh
│   └── mi_tema.css
├── marp_slides/            # Archivos Marp (.md)
│   ├── presentacion1.md
│   └── presentacion2.md
├── pdf_slides/             # PDFs generados
│   ├── presentacion1.pdf
│   └── presentacion2.pdf
└── marp.config.sh          # Configuración del proyecto (opcional)
```

## 🔄 Reutilización en Otros Proyectos

### Método 1: Copiar Scripts
```bash
# En tu nuevo proyecto
cp -r /ruta/a/scripts/ ./scripts/
./scripts/marp_tools.sh setup
./scripts/marp_tools.sh convert
```

### Método 2: Scripts Globales
```bash
# Instalar scripts globalmente
sudo cp scripts/* /usr/local/bin/
sudo chmod +x /usr/local/bin/marp_*

# Usar en cualquier proyecto
marp_tools.sh setup
marp_tools.sh convert
```

## 🛠️ Scripts Individuales

### `setup_marp.sh`
Instala Marp CLI globalmente.

```bash
./scripts/setup_marp.sh              # Instalar
./scripts/setup_marp.sh -f           # Forzar reinstalación
./scripts/setup_marp.sh -v           # Modo verboso
```

### `run_conversion.sh`
Convierte archivos Marp a PDF.

```bash
./scripts/run_conversion.sh                    # Usar configuración por defecto
./scripts/run_conversion.sh -i slides -o pdfs  # Directorios personalizados
./scripts/run_conversion.sh -t tema            # Usar tema personalizado
./scripts/run_conversion.sh -v                 # Modo verboso
```

### `convert_marp_to_pdf.py`
Script Python para conversión (usado internamente).

```bash
python3 scripts/convert_marp_to_pdf.py marp_slides -o pdf_slides -t tema
```

## 🐛 Solución de Problemas

### Marp no está instalado
```bash
./scripts/setup_marp.sh
```

### Error de permisos
```bash
chmod +x scripts/*.sh
```

### Node.js no está instalado
```bash
# Ubuntu/Debian
sudo apt install nodejs npm

# macOS
brew install node

# Windows
# Descargar desde https://nodejs.org/
```

### Error de Python
```bash
# Verificar que Python 3 esté instalado
python3 --version

# Instalar si es necesario
sudo apt install python3  # Ubuntu/Debian
```

## 📝 Ejemplos de Uso

### Crear presentación desde cero
```bash
# 1. Crear directorio de slides
mkdir marp_slides

# 2. Crear archivo de presentación
cat > marp_slides/mi_presentacion.md << 'EOF'
---
marp: true
theme: default
---

# Mi Presentación

Esta es mi primera diapositiva

---

# Segunda Diapositiva

Con más contenido
EOF

# 3. Convertir a PDF
./scripts/marp_tools.sh convert
```

### Usar tema personalizado
```bash
# 1. Crear tema
cat > scripts/mi_tema.css << 'EOF'
section {
    background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
    color: white;
    font-family: 'Arial', sans-serif;
}

h1, h2, h3 {
    color: #ffd700;
}
EOF

# 2. Usar tema
./scripts/marp_tools.sh convert -t mi_tema
```

## 🤝 Contribuir

Para mejorar estos scripts:

1. Edita los archivos en `scripts/`
2. Prueba con diferentes proyectos
3. Documenta los cambios
4. Comparte las mejoras

## 📄 Licencia

Estos scripts son de dominio público. Úsalos libremente en tus proyectos.
