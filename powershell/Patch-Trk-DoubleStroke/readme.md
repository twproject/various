# Patch-Trk-DoubleStroke

Script PowerShell per applicare un **doppio stroke** a una traccia SVG (tipicamente generata da strumenti GPS):
- **Outer** (sotto): bordo/contorno esterno, colore e spessore personalizzabili  
- **Inner** (sopra): traccia interna, colore e spessore personalizzabili  

Opzionalmente rimuove watermark testuali tipo _"created by gps..."_.

---

## ⚙️ Requisiti
- Windows PowerShell 5.1 o PowerShell 7+
- File SVG con la traccia dentro un gruppo con `id` noto (es. `trk1`)

---

## 🚀 Uso base

```powershell
.\Patch-Trk-DoubleStroke.ps1 `
  -InputSvg 'C:\path\to\input.svg' `
  -OutputSvg 'C:\path\to\output.svg' `
  -OuterFactor 3 `
  -InnerFactor 0.7 `
  -OuterColor 'red' `
  -InnerColor 'yellow' `
  -GroupId 'trk1' `
  -OpenAfter
```

---

## 🧩 Parametri

| Parametro | Tipo | Default | Descrizione |
|------------|------|----------|--------------|
| `-InputSvg` | string | — | Percorso del file SVG sorgente |
| `-OutputSvg` | string | — | Percorso del file SVG risultante |
| `-OuterFactor` | double | `3.0` | Moltiplicatore per lo spessore del bordo esterno (sotto) |
| `-InnerFactor` | double | `0.7` | Moltiplicatore per lo spessore del tratto interno (sopra) |
| `-OuterColor` | string | `'red'` | Colore bordo esterno |
| `-InnerColor` | string | `'yellow'` | Colore tratto interno |
| `-GroupId` | string | `'trk1'` | Id del gruppo SVG che contiene la traccia |
| `-NoWatermark` | switch | — | Rimuove `<text>` che contengono la stringa “created by gps” (case-insensitive) |
| `-OpenAfter` | switch | — | Apre l’SVG di output a fine esecuzione |

---

## 🎨 Formati di colore supportati

I parametri `-OuterColor` e `-InnerColor` accettano **qualsiasi formato SVG/CSS valido**, ad esempio:

| Tipo              | Esempio                    | Descrizione |
|-------------------|-----------------------------|--------------|
| Nome HTML         | `red`, `yellow`, `blue`, `green` | Colori standard riconosciuti dal browser |
| Esadecimale breve | `#f00`, `#0f0`, `#ff0`     | Forma abbreviata `#rgb` |
| Esadecimale pieno | `#ff0000`, `#00ff00`, `#ffff00` | Forma completa `#rrggbb` |
| RGB numerico      | `rgb(255,0,0)`, `rgb(0,255,0)` | Definisce i valori espliciti R,G,B |
| RGBA con alpha    | `rgba(255,0,0,0.7)`        | Supporta trasparenze (0–1) |

Esempi:
```powershell
-OuterColor '#ff0000' -InnerColor '#ffff00'
-OuterColor 'rgb(0,0,255)' -InnerColor 'rgba(255,255,0,0.6)'
-OuterColor 'black' -InnerColor 'lime'
```

---

## 🧪 Esempi pratici

### 🔴 Giallo con bordo rosso
```powershell
.\Patch-Trk-DoubleStroke.ps1 `
  -InputSvg 'C:\...\20251102101135-96183-map.svg' `
  -OutputSvg 'C:\...\map-giallo-rosso.svg' `
  -OuterFactor 2 `
  -InnerFactor 0.7 `
  -OuterColor 'red' `
  -InnerColor 'yellow' `
  -GroupId 'trk1' `
  -OpenAfter
```

### 🟠 Più contorno (bordo più spesso)
```powershell
-OuterFactor 3 -InnerFactor 0.5 -OuterColor 'red' -InnerColor 'yellow'
```

### 🔵 Bordi blu e traccia gialla
```powershell
-OuterColor 'blue' -InnerColor 'yellow' -OuterFactor 3 -InnerFactor 0.5
```

### 🟢 Bordi blu e traccia verde
```powershell
-OuterColor 'blue' -InnerColor 'green' -OuterFactor 3 -InnerFactor 0.5
```

### 💧 Rimuovere watermark "created by gps..."
```powershell
-NoWatermark
```

---

## 📝 Note
- Lo script **non** modifica altri elementi SVG (legende, testi, simboli) a meno che non si usi `-NoWatermark`.  
- Gli spessori sono calcolati come:  
  - `stroke_originale * OuterFactor` (sotto)  
  - `stroke_originale * InnerFactor` (sopra)  
- Gli attributi aggiunti:  
  - `stroke`, `stroke-width`, `fill="none"`, `stroke-linecap="round"`, `stroke-linejoin="round"`

---

## 📄 Licenza
MIT
