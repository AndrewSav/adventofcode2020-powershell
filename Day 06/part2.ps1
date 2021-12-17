$i = Get-Content -Raw input.txt 
$pp = $i -split "`n`n"
$pp | ForEach-Object {
  $l = @($_ -split "`n" | Where-Object { $_ })
  $c = $l[0].ToCharArray()
  if ($l.Length -gt 1) {
    1..($l.count - 1) | ForEach-Object {
      $a = $l[$_].ToCharArray()
      $c = $c.where({ $a -contains $_ })  
    }
  }
  $c.Count
} | Measure-Object -Sum | Select-Object -ExpandProperty Sum
