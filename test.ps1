$return = Get-Location
$threshold = 10
(Get-ChildItem -Directory) | ForEach-Object {
  Set-Location $_
  if ((Test-Path '.\part1.ps1') -and (Test-Path '.\input.txt')) {
    [int]$sec = Measure-Command { $script:result = & '.\part1.ps1' } | Select-Object -ExpandProperty TotalSeconds
    if ($sec -gt $threshold) {
      Write-Host -ForegroundColor Red "$($_.Name) Part 1 $script:result ($($sec)s)"
    } else {
      Write-Host "$($_.Name) Part 1 $script:result ($($sec)s)"
    }
  }
  if ((Test-Path '.\part2.ps1') -and (Test-Path '.\input.txt')) {
    [int]$sec = Measure-Command { $script:result = & '.\part2.ps1' } | Select-Object -ExpandProperty TotalSeconds
    if ($sec -gt $threshold) {
      Write-Host -ForegroundColor Red "$($_.Name) Part 2 $script:result ($($sec)s)"
    } else {
      Write-Host "$($_.Name) Part 2 $script:result ($($sec)s)"
    }
  }
}
Set-Location $return
