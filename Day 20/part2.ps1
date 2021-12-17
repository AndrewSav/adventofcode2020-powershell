$i = Get-Content -Raw input.txt

enum Directions {
  top
  right
  bottom
  left
}

class Edge {
  [int]$value
  [Directions]$direction
  [bool]$reverse
}

class Tile {
  [Edge[]]$edges
  [string[]]$data
  [void] flip([bool]$horizontal) {
    if ($horizontal) {
      [array]::Reverse($this.data)
    }
    else {
      $this.data = $this.data.foreach({ $_[-1.. - $_.Length] -join '' })
    }
    if ($this.edges) { $this.edges = getEdges $this.data }
  }
  [void] rotate([bool]$clockwise) {
    $indices = $clockwise ? 0..($this.data[0].length - 1) : ($this.data[0].length - 1)..0
    $this.data = $indices.foreach({
        $index = $_
        $this.data.foreach({ $_[$index] }) -join ""
      })
    if ($clockwise) { $this.flip($false) }
    if ($this.edges) { $this.edges = getEdges $this.data }
  }
  [void] removeEdges() {
    $this.data = $this.data[1..($this.data[0].length - 2)]
    $this.data = $this.data.foreach({ $_.substring(1, $_.length - 2) })
  }
}

function reverse10($i) { [int](([long]$i * 2254000986523650 -band 1171507928472027168) % 4095) }

function codeEdge($s) {
  [convert]::ToInt32($s.replace(".", "0").replace("#", "1"), 2)
}

function getEdges($s) {
  $top = codeEdge $s[0]
  $bottom = codeEdge $s[$s.length - 1]
  $left = codeEdge ($s.foreach({
        $_[0]
      }) -join "")
  $right = codeEdge ($s.foreach({
        $_[$_.length - 1]
      }) -join "")
  [Edge]@{value = $top; direction = "top"; reverse = $false }
  [Edge]@{value = $bottom; direction = "bottom"; reverse = $false }
  [Edge]@{value = $left; direction = "left"; reverse = $false }
  [Edge]@{value = $right; direction = "right"; reverse = $false }
  [Edge]@{value = (reverse10 $top); direction = "top"; reverse = $true }
  [Edge]@{value = (reverse10 $bottom); direction = "bottom"; reverse = $true }
  [Edge]@{value = (reverse10 $left); direction = "left"; reverse = $true }
  [Edge]@{value = (reverse10 $right); direction = "right"; reverse = $true }
}

$tiles = @{}
$lookup = @{}

$i.trim("`n").split("`n`n").foreach({
    $lines = $_.split("`n")
    $lines[0] -match "\d+" | Out-Null
    $tile = [int]$matches[0]
    $data = $lines | Select-Object -Skip 1
    $tiles[$tile] = [Tile]@{data = $data; edges = (getEdges $data) }
    $tiles[$tile].edges.foreach({
        if (!$lookup.ContainsKey($_.value)) { $lookup[$_.value] = @() }
        $lookup[$_.value] = @($lookup[$_.value]) + @($tile)
      })
  })

$corners = $tiles.Keys.where({
    $tiles[$_].edges.where({
        $lookup[$_.value].count -gt 1
      }).count -eq 4
  })

$upperLeft = $corners[0]

while ($lookup[$tiles[$upperLeft].edges.where({ $_.direction -eq "top" })[0].value].Count -ne 1 -or
  $lookup[$tiles[$upperLeft].edges.where({ $_.direction -eq "left" })[0].value].Count -ne 1) {
  $tiles[$upperLeft].rotate($true)
}

$placedTiles = @()
$current = $upperLeft

function rotateUntilClicks($tile, $connection, $direction) {
  $connectedEdge = $tiles[$tile].edges.where({ $_.value -eq $connection })
  while ($connectedEdge.reverse -or $connectedEdge.direction -ne $direction) {
    if ($connectedEdge.direction -ne $direction) {
      $tiles[$tile].rotate($true)
    }
    else {
      $tiles[$tile].flip($true)
    }
    $connectedEdge = $tiles[$tile].edges.where({ $_.value -eq $connection })
  }
}

$grid = while ($true) {
  $line = @()

  while ($true) {
    $line = @($line) + @($current)
    $placedTiles = @($placedTiles) + @($current)
    $connection = $tiles[$current].edges.where({ $_.direction -eq "right" -and !$_.reverse }).Value
    $next = $lookup[$connection].where({ $placedTiles -notcontains $_ })
    if (!$next) { break; }
    rotateUntilClicks $next $connection "left"
    $current = $next
  }
  @(, $line)
  #Write-Host @(,$line)
  $current = $line[0]
  $connection = $tiles[$current].edges.where({ $_.direction -eq "bottom" -and !$_.reverse }).Value
  $current = $lookup[$connection].where({ $placedTiles -notcontains $_ })
  if (!$current) { break; }
  rotateUntilClicks $current $connection "top"
}

$tiles.Keys.foreach({ $tiles[$_].removeEdges() })

$theTile = [Tile]@{data = $grid.foreach({
      $row = $_
  (0..($tiles[$_][0].data.count - 1)).foreach({
          $index = $_
          $row.foreach({
              $tiles[$_].data[$index]
            }) -join ""
        })
    })
}


function intersect([object[]] $a) {
  if ($a.count -eq 0) { return $a }
  if ($a.count -eq 1) { return $a[0] }
  $current = $a[0]
  (1..($a.count - 1)).foreach({
      $index = $_
      $current = $current | Where-Object { $a[$index] -contains $_ }
    })
  $current
}

$monster = "..................#.",
"#....##....##....###",
".#..#..#..#..#..#..."

function getOnes([object[]] $a) {
  $a.foreach({ $_.ToCharArray().where({ $_ -eq "#" }).count }) | Measure-Object -Sum | Select-Object -ExpandProperty Sum
}

function getMonstersNumber {

  $monster = $monster.foreach({ [regex]"(?=$_)" })

  (0..($theTile.data.count - $monster.count)).foreach({
      $line = $_
      $t = (0..($monster.count - 1)).foreach({
          @(, $monster[$_].Matches($theTile.data[$line + $_]).foreach({ $_.index }))
        })
      (intersect $t).count
    }) | Measure-Object -Sum | Select -ExpandProperty Sum
}

function final {
  $num = getMonstersNumber
  if ($num) {
    (getOnes $theTile.data) - (getOnes $monster) * $num
    exit
  }
}

final
$theTile.rotate($true); final
$theTile.rotate($true); final
$theTile.rotate($true); final
$theTile.flip($true); final
$theTile.rotate($true); final
$theTile.rotate($true); final
$theTile.rotate($true); final
