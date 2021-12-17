$i = Get-Content -Raw input.txt 
$pp = $i -split "`n`n"
$pp | ForEach-Object {
 ($_.replace("`n", "").ToCharArray() | Select-Object -Unique).Count
} | Measure-Object -Sum | Select-Object -ExpandProperty Sum
