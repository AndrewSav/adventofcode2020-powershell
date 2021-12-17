$i = Get-Content input.txt

function sitsOccupied($x, $y) {
  $r = 0
  if ($x -gt 0 -and $y -gt 0) {
    if ($i[$y - 1][$x - 1] -eq '#') { $r++ }
  }
  if ($y -gt 0) {
    if ($i[$y - 1][$x] -eq '#') { $r++ }
  }
  if ($x -lt $i[$y].Length - 1 -and $y -gt 0) {
    if ($i[$y - 1][$x + 1] -eq '#') { $r++ }
  }
  if ($x -gt 0) {
    if ($i[$y][$x - 1] -eq '#') { $r++ }
  }
  if ($x -lt $i[$y].Length - 1) {
    if ($i[$y][$x + 1] -eq '#') { $r++ }
  }
  if ($x -gt 0 -and $y -lt $i.count - 1) {
    if ($i[$y + 1][$x - 1] -eq '#') { $r++ }
  }
  if ($y -lt $i.count - 1) {
    if ($i[$y + 1][$x] -eq '#') { $r++ }
  }
  if ($x -lt $i[$y].Length - 1 -and $y -lt $i.count - 1) {
    if ($i[$y + 1][$x + 1] -eq '#') { $r++ }
  }
  $r
}


do {
  $changed = $false
  $occupied = 0
  $i = for ($y = 0; $y -le $i.count - 1; $y++) {
    $j = for ($x = 0; $x -le $i[$y].Length - 1; $x++) {
      $s = $i[$y][$x]
      switch ($s) {
        "." { $r = "." }
        "#" { if ((sitsOccupied $x $y) -ge 4) { $r = "L"; $changed = $true; } else { $r = "#"; $occupied++ } }
        "L" { if ((sitsOccupied $x $y) -eq 0) { $r = "#"; $changed = $true; $occupied++ } else { $r = "L" } }     
      }
      $r
    }
    $j -join ""
  }
} while ($changed)
$occupied
