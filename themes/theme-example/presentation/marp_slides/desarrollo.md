---
marp: true
style: |
  section { position: relative; }
  section { background-image: url('images/background.jpg'); background-size: cover; background-position: center; background-repeat: no-repeat; }
  section .header-text { position: absolute; top: 5mm; left: 10mm; right: 10mm; text-align: center; font-size: 10pt; font-weight: bold; color: #333; background: rgba(255, 255, 255, 0.9); padding: 2mm 4mm; border-radius: 2mm; box-shadow: 0 1px 3px rgba(0,0,0,0.2); z-index: 20; display: flex; align-items: center; justify-content: space-between; }
  section .header-text .logo-left { width: 25mm; height: 12mm; background-image: url('images/logo_left.png'); background-size: contain; background-repeat: no-repeat; background-position: left center; flex-shrink: 0; }
  section .header-text .logo-right { width: 25mm; height: 12mm; background-image: url('images/logo_right.png'); background-size: contain; background-repeat: no-repeat; background-position: right center; flex-shrink: 0; }
  section .header-text .header-center { flex: 1; text-align: center; }
  section .footer-text { position: absolute; bottom: 5mm; left: 10mm; right: 10mm; text-align: center; font-size: 9pt; color: #666; background: rgba(255, 255, 255, 0.8); padding: 2mm 4mm; border-radius: 2mm; box-shadow: 0 1px 3px rgba(0,0,0,0.1); z-index: 20; }
---

# Topic Development
<div class="header-text"><div class="logo-left"></div><div class="header-center">Test Company</div><div class="logo-right"></div></div><div class="footer-text">Test Footer</div>

![Example](images/example.jpg)

## Required Tools

### Required Software
- Python 3.8+
- Node.js 16+
- Git

### Main Libraries
- `pandas` for data manipulation
- `numpy` for numerical calculations
- `matplotlib` for visualizations

---

## Environment Setup
<div class="header-text"><div class="logo-left"></div><div class="header-center">Test Company</div><div class="logo-right"></div></div><div class="footer-text">Test Footer</div>

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt
```

---

## First Steps
<div class="header-text"><div class="logo-left"></div><div class="header-center">Test Company</div><div class="logo-right"></div></div><div class="footer-text">Test Footer</div>

1. **Clone the repository**
2. **Set up the environment**
3. **Run basic examples**
4. **Customize according to needs**
