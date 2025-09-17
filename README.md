# Makefile para Scripts de Marp

Este Makefile facilita el uso de los scripts de conversión de presentaciones Marp desde el directorio raíz del proyecto.

## 🚀 Uso Básico

```bash
# Mostrar ayuda
make help

# Instalar Marp CLI
make setup

# Convertir todo (tema por defecto: fine-tuning)
make all

# Convertir tema específico
make all THEME=mi-curso

# Modo verboso
make all VERBOSE=true
```

## 📋 Comandos Disponibles

### Comandos Principales

| Comando | Descripción |
|---------|-------------|
| `make help` | Mostrar ayuda completa |
| `make setup` | Instalar Marp CLI |
| `make all` | Convertir todo: MD → Marp → PDF |
| `make convert` | Convertir Marp a PDF |
| `make md-to-marp` | Convertir MD a Marp |
| `make watch` | Modo watch (auto-regenera) |

### Comandos de Gestión

| Comando | Descripción |
|---------|-------------|
| `make create-project NAME=tema` | Crear nuevo proyecto |
| `make clean` | Limpiar archivos generados |
| `make clean-all` | Limpiar todos los archivos generados |
| `make status` | Mostrar estado de archivos |
| `make list-themes` | Listar temas disponibles |
| `make images` | Mostrar imágenes disponibles |
| `make copy-images` | Copiar imágenes a marp_slides |

### Comandos de Información

| Comando | Descripción |
|---------|-------------|
| `make config` | Mostrar configuración |
| `make validate` | Validar configuración |
| `make info` | Información del sistema |
| `make help-scripts` | Ayuda de scripts |
| `make help-create` | Ayuda para crear proyectos |

### Comandos de Desarrollo

| Comando | Descripción |
|---------|-------------|
| `make dev-setup` | Configuración completa |
| `make test` | Probar scripts |
| `make backup` | Crear respaldo |
| `make install-deps` | Instalar dependencias |

## ⚙️ Variables

### THEME
Especifica el tema/proyecto a usar.

```bash
make all THEME=mi-curso-ia
make convert THEME=machine-learning
make status THEME=deep-learning
```

**Valor por defecto:** `fine-tuning`

### VERBOSE
Activa el modo verboso para ver más detalles.

```bash
make all VERBOSE=true
make convert THEME=mi-curso VERBOSE=true
```

**Valor por defecto:** `false`

## 📁 Estructura de Proyecto

El Makefile espera la siguiente estructura:

```
proyecto/
├── Makefile                    # Este archivo
├── scripts/                    # Scripts de Marp
├── tema1/                      # Primer tema
│   ├── programa.md
│   └── presentacion/
│       ├── md_src/            # Archivos MD fuente
│       ├── marp_slides/       # Archivos Marp generados
│       ├── pdf_slides/        # PDFs generados
│       ├── img_src/           # Imágenes para presentaciones
│       └── style.css          # Estilos personalizados
└── tema2/                      # Segundo tema
    └── ...
```

## 🔧 Ejemplos de Uso

### Crear y Configurar Nuevo Proyecto

```bash
# 1. Crear nuevo tema
make create-project NAME=mi-curso-ia

# 2. Ir al directorio del tema
cd mi-curso-ia

# 3. Instalar Marp
make setup

# 4. Convertir todo
make all
```

### Trabajar con Múltiples Temas

```bash
# Listar temas disponibles
make list-themes

# Convertir tema específico
make all THEME=deep-learning

# Ver estado de un tema
make status THEME=machine-learning

# Limpiar archivos generados de un tema
make clean THEME=deep-learning
```

### Desarrollo y Pruebas

```bash
# Configuración completa para desarrollo
make dev-setup

# Probar scripts con tema de ejemplo
make test

# Crear respaldo de archivos MD
make backup

# Ver información del sistema
make info
```

### Modo Watch (Desarrollo)

```bash
# Modo watch para tema por defecto
make watch

# Modo watch para tema específico
make watch THEME=mi-curso

# Modo watch con verboso
make watch THEME=mi-curso VERBOSE=true
```

### Manejo de Imágenes

```bash
# Ver imágenes disponibles
make images

# Ver imágenes de tema específico
make images THEME=mi-curso

# Copiar imágenes a marp_slides
make copy-images

# Convertir todo (incluye copia de imágenes)
make all
```

## 🛠️ Comandos de Mantenimiento

### Limpieza

```bash
# Limpiar archivos generados del tema actual
make clean

# Limpiar archivos generados de tema específico
make clean THEME=mi-curso

# Limpiar todos los archivos generados
make clean-all
```

### Respaldo

```bash
# Crear respaldo de archivos MD
make backup

# Los respaldos se guardan en backups/
ls backups/
```

### Actualización

```bash
# Actualizar scripts desde Git
make update-scripts

# Instalar dependencias del sistema
make install-deps
```

## 🔍 Diagnóstico

### Verificar Estado

```bash
# Estado del tema actual
make status

# Estado de tema específico
make status THEME=mi-curso

# Listar todos los temas
make list-themes
```

### Validar Configuración

```bash
# Validar configuración
make validate

# Ver configuración actual
make config

# Información del sistema
make info
```

## 📝 Notas Importantes

1. **Directorio de trabajo**: El Makefile debe ejecutarse desde el directorio raíz del proyecto.

2. **Estructura requerida**: Cada tema debe tener la estructura `tema/presentacion/md_src/`.

3. **Scripts**: Los scripts deben estar en el directorio `scripts/`.

4. **Temas**: Los temas se detectan automáticamente buscando directorios con `presentacion/`.

5. **Variables**: Las variables se pueden sobrescribir en la línea de comandos o en un archivo `.env`.

## 🚨 Solución de Problemas

### Error: "No rule to make target"
- Asegúrate de estar en el directorio raíz del proyecto
- Verifica que el Makefile esté presente

### Error: "THEME no existe"
- Usa `make list-themes` para ver temas disponibles
- Verifica la estructura del directorio del tema

### Error: "Scripts no encontrados"
- Verifica que el directorio `scripts/` existe
- Asegúrate de que los scripts son ejecutables

### Error: "Marp no instalado"
- Ejecuta `make setup` para instalar Marp CLI
- O instala manualmente: `npm install -g @marp-team/marp-cli`

## 🤝 Contribuir

Para mejorar este Makefile:

1. Edita el archivo `Makefile`
2. Prueba los comandos
3. Documenta los cambios
4. Comparte las mejoras

## 📄 Licencia

Este Makefile es de dominio público. Úsalo libremente en tus proyectos.
