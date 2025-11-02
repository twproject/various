<#
.SYNOPSIS
  Doppio stroke su una traccia SVG: bordo esterno + tratto interno, con colori e fattori personalizzabili.
.DESCRIPTION
  Clona ogni <polyline>/<path> dentro un gruppo SVG (es. id='trk1') creando:
    - un tratto esterno (sotto) con colore/spessore "Outer"
    - un tratto interno (sopra) con colore/spessore "Inner"
  Opzionalmente rimuove il watermark testuale "created by gps ...".
#>

param(
  [Parameter(Mandatory=$true)] [string]$InputSvg,
  [Parameter(Mandatory=$true)] [string]$OutputSvg,

  # Spessore moltiplicativo per il bordo esterno (sotto)
  [double]$OuterFactor = 3.0,

  # Spessore moltiplicativo per il tratto interno (sopra)
  [double]$InnerFactor = 0.7,

  # Colori personalizzabili: nomi HTML (es. 'red'), esadecimali ('#ff0000'), o 'rgb(r,g,b)'
  [string]$OuterColor = "red",
  [string]$InnerColor = "yellow",

  # Id del gruppo che contiene la traccia (es. 'trk1')
  [string]$GroupId = "trk1",

  # Rimuove eventuali watermark di testo contenenti "created by gps"
  [switch]$NoWatermark,

  # Apre il file di output a fine esecuzione
  [switch]$OpenAfter
)

function Parse-DoubleInvariant {
  param([string]$s, [double]$fallback = 3.0)
  if ([string]::IsNullOrWhiteSpace($s)) { return $fallback }
  $n = 0.0
  if ([double]::TryParse($s, [System.Globalization.NumberStyles]::Float,
      [System.Globalization.CultureInfo]::InvariantCulture, [ref]$n)) { return $n }
  return $fallback
}

# --- Carica file ---
if (-not (Test-Path -LiteralPath $InputSvg)) {
  throw "File non trovato: $InputSvg"
}
$xmlText = [System.IO.File]::ReadAllText($InputSvg)
[xml]$doc = $xmlText
if (-not $doc.DocumentElement) {
  throw "Impossibile caricare/parsing dell'SVG (documento nullo)."
}

# --- Rimozione watermark opzionale ---
if ($NoWatermark) {
  # Cerca qualunque <text> che contenga "created by gps" (case-insensitive).
  $wmNodes = $doc.SelectNodes("//*[local-name()='text'][contains(translate(normalize-space(string(.)),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'created by gps')]")
  if ($wmNodes -and $wmNodes.Count -gt 0) {
    foreach ($t in @($wmNodes)) {
      $null = $t.ParentNode.RemoveChild($t)
    }
  }
}

# --- Trova il gruppo target (ignorando namespace SVG) ---
$trk = $doc.SelectSingleNode("//*[local-name()='g' and @id='$GroupId']")
if (-not $trk) {
  throw "Gruppo con id='$GroupId' non trovato. (Controlla che l'ID coincida)"
}

# --- Seleziona polyline e path dentro il gruppo ---
$nodes = $trk.SelectNodes(".//*[local-name()='polyline' or local-name()='path']")
if (-not $nodes -or $nodes.Count -eq 0) {
  throw "Nessun <polyline> o <path> trovato dentro id='$GroupId'."
}

foreach ($n in @($nodes)) {
  $parent = $n.ParentNode

  # Stroke-width originale (default 3.0 se assente)
  $w = 3.0
  if ($n.HasAttribute("stroke-width")) {
    $w = Parse-DoubleInvariant -s $n.GetAttribute("stroke-width") -fallback 3.0
  }

  # Cloni
  $outer = $n.Clone()
  $inner = $n.Clone()

  # --- BORDO ESTERNO (sotto) ---
  $outer.SetAttribute("stroke", $OuterColor)
  $outer.SetAttribute("stroke-width",
    ([math]::Round($w * $OuterFactor, 3)).ToString([System.Globalization.CultureInfo]::InvariantCulture))
  $outer.SetAttribute("fill", "none")
  $outer.SetAttribute("stroke-linecap", "round")
  $outer.SetAttribute("stroke-linejoin", "round")

  # --- TRACCIA INTERNA (sopra) ---
  $inner.SetAttribute("stroke", $InnerColor)
  $inner.SetAttribute("stroke-width",
    ([math]::Round($w * $InnerFactor, 3)).ToString([System.Globalization.CultureInfo]::InvariantCulture))
  $inner.SetAttribute("fill", "none")
  $inner.SetAttribute("stroke-linecap", "round")
  $inner.SetAttribute("stroke-linejoin", "round")

  # Inserisci i nuovi layer e rimuovi l’originale
  [void]$parent.InsertBefore($outer, $n)   # sotto
  [void]$parent.InsertBefore($inner, $n)   # sopra
  [void]$parent.RemoveChild($n)
}

# --- Salva UTF-8 senza BOM ---
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$sw = New-Object System.IO.StreamWriter($OutputSvg, $false, $utf8NoBom)
$doc.Save($sw)
$sw.Close()

Write-Host "OK -> $OutputSvg"
if ($OpenAfter) { Start-Process $OutputSvg }
