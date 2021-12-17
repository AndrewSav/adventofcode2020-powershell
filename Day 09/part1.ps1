$i = Get-Content input.txt | ForEach-Object { [long]$_ }
25..($i.Count - 1) | ForEach-Object {
  $c = $_
  if ((($_ - 25)..($_ - 1)).foreach({
        $x = $_
        if ($x + 1 -lt $c - 1) {
      ($x + 1)..($c - 1) | ForEach-Object {
            if ($i[$x] -ne $i[$_] -and $i[$x] + $i[$_] -eq $i[$c]) {
              $true
            }
          }
        }
      }).count -eq 0) {
    $i[$c]
    exit
  }
}
