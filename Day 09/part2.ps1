$i = Get-Content input.txt | ForEach-Object { [long]$_ }

function run {
  foreach ( $c in 25..($i.Count - 1)) {
    if ((($c - 25)..($c - 1)).foreach({
          $x = $_
          if ($x + 1 -lt $c - 1) {
        ($x + 1)..($c - 1) | ForEach-Object {
              if ($i[$x] -ne $i[$_] -and $i[$x] + $i[$_] -eq $i[$c]) {
                $true
              }
            }
          }
        }).count -eq 0) {
      return $i[$c]
    }
  }
}

$target = run

foreach ($c in 0..($i.Count - 1)) {
  $acc = $i[$c]
  $j = $c
  while ($acc -lt $target) {
    $j++
    $acc += $i[$j]
  }
  if ($acc -eq $target) {
    $m = $i[$c..$j] | Measure-Object -Minimum -Maximum
    return $m.Minimum + $m.Maximum
  }
}
