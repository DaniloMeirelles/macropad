$d = (Get-Volume -FileSystemLabel CIRCUITPY).DriveLetter
Copy-Item "$PSScriptRoot\..\firmware\*" "${d}:\" -Recurse -Force
Write-Host "Copiado para ${d}:"