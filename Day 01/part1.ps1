$i = Get-Content input.txt | ForEach-Object { [int]$_ }
foreach ($x in $i) {
  foreach ($y in $i) {
    if ($x + $y -eq 2020) {
      return $x * $y
    }
  }
}
