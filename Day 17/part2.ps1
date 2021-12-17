$i = (Get-Content input.txt).foreach({ @(, $_.ToCharArray()) })

class Helper { 
  static [bool] checkDirection($pocket, $x, $y, $z, $w, $dx, $dy, $dz, $dw, $neighboursInventory) {
    $nx, $ny, $nz, $nw = ($x + $dx), ($y + $dy), ($z + $dz), ($w + $dw)
    if ($pocket.ContainsKey("$nx,$ny,$nz,$nw")) {
      return $true
    }
    else {
      if ($neighboursInventory) {
        $neighboursInventory["$nx,$ny,$nz,$nw"] = "."
      }
      return $false
    }
  }
  static [int] neighboursCount($pocket, $x, $y, $z, $w, $neighboursInventory) {
    return $script:dirs.where({
        $dx, $dy, $dz, $dw = $_
        [Helper]::checkDirection($pocket, $x, $y, $z, $w, $dx, $dy, $dz, $dw, $neighboursInventory)
      }).count
  }
  static [int[]] unpackCoords([string]$s) {
    return ($s.split(",") | ForEach-Object { [int]$_ })
  }
  static [object[]] getDirs([int]$dimensions) {
    return (1..$([math]::Pow(3, $dimensions) - 1)).foreach({
        $n = $_
        @(, (1..$dimensions).foreach({
              $divrem = [system.math]::DivRem($n, 3)
              $n = $divrem.Item1
              if ($divrem.Item2 -eq 2) { -1 } else { $divrem.Item2 }
            }))
      })
  }
}

$dirs = [Helper]::getDirs(4)

$pocket = @{}
$y = 0;
$i.foreach({
    $x = 0
    $_.foreach({
        if ($_ -eq "#") { $pocket["$x,$y,0,0"] = "#" }
        $x++
      })
    $y++
  })

(0..5).foreach({
    $nextPocket = @{}
    $neighboursInventory = @{}
    $pocket.Keys.foreach({
        $x, $y, $z, $w = [Helper]::unpackCoords($_)
        $count = [Helper]::neighboursCount($pocket, $x, $y, $z, $w, $neighboursInventory)
        if ($count -eq 2 -or $count -eq 3) {
          $nextPocket[$_] = "#"
        }
      })
    $neighboursInventory.Keys.foreach({
        $x, $y, $z, $w = [Helper]::unpackCoords($_)
        $count = [Helper]::neighboursCount($pocket, $x, $y, $z, $w, $null)
        if ($count -eq 3) {
          $nextPocket[$_] = "#"
        }
      })
    $pocket = $nextPocket
  })
$pocket.Count
