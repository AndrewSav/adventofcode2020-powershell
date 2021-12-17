$i = Get-Content input.txt
$right = 3; $down = 1; $x = 0; $y = $down; $result = 0
while ($y -le $i.count - 1) {
  $l = $i[$y]
  $x = ($x + $right) % $l.Length
  if ($l[$x] -eq '#') { $result++ }
  $y += $down
}
$result
