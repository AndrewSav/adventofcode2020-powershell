$i = Get-Content input.txt | ForEach-Object { [int]$_ }
foreach ($x in $i) {
  foreach ($y in $i) {
    foreach ($z in $i) {
      if ($x + $y + $z -eq 2020) {
        return $x * $y * $z
      }
    }
  }
}
