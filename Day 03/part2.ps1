$i = Get-Content input.txt
function t($right, $down) {
  $x = 0; $y = $down; $result = 0
  while ($y -le $i.count - 1) {
    $l = $i[$y]
    $x = ($x + $right) % $l.Length
    if ($l[$x] -eq '#') { $result++ }
    $y += $down
  }
  $result
}
(t 1 1) * (t 3 1) * (t 5 1) * (t 7 1) * (t 1 2)
