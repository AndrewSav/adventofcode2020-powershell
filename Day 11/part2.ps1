$first = (Get-Content input.txt).foreach({ @(, $_.ToCharArray()) })
$second = (Get-Content input.txt).foreach({ @(, $_.ToCharArray()) })

# https://github.com/PowerShell/PowerShell/issues/8482#issuecomment-457347691
class Helper { 
  static [bool] checkDirection($i, $x, $y, $dx, $dy) {
    $nx = $x + $dx
    $ny = $y + $dy
    if ($ny -ge 0 -and $ny -le $i.count - 1) {
      $l = $i[$ny]
      if ($nx -ge 0 -and $nx -le $l.count - 1) {
        switch ($l[$nx]) {
          "#" { return $true }
          "L" { return $false }
          "." { return [Helper]::checkDirection($i, $nx, $ny, $dx, $dy) }
        }
      }
    }
    return $false
  }
  static [int] sitsOccupied($i, $x, $y) {
    $dirs = ((-1, -1), (-1, 0) , (-1, 1), (0, -1) , (0, 1), (1, -1), (1, 0), (1, 1))
    return $dirs.where({
        $dx, $dy = $_
        [Helper]::checkDirection($i, $x, $y, $dx, $dy)
      }).count
  }
}

do {
  $changed = $false
  $occupied = 0
  for ($y = 0; $y -le $first.count - 1; $y++) {
    for ($x = 0; $x -le $first[$y].count - 1; $x++) {
      switch ($first[$y][$x]) {
        "#" { if (([Helper]::sitsOccupied($first, $x, $y)) -ge 5) { $second[$y][$x] = "L"; $changed = $true; } else { $second[$y][$x] = "#"; $occupied++ } }
        "L" { if (([Helper]::sitsOccupied($first, $x, $y)) -eq 0) { $second[$y][$x] = "#"; $changed = $true; $occupied++ } else { $second[$y][$x] = "L" } }     
      }
    }
  }
  $first, $second = $second, $first
} while ($changed)
$occupied
