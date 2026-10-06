$d = (Get-Volume -FileSystemLabel CIRCUITPY -ErrorAction SilentlyContinue).DriveLetter
if (-not $d) { Write-Host "Placa CIRCUITPY não encontrada"; exit 1 }
Copy-Item "$PSScriptRoot\..\firmware\*" "${d}:\" -Recurse -Force
Write-Host "Copiado para ${d}:"