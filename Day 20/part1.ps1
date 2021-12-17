$i = Get-Content -Raw input.txt

#http://graphics.stanford.edu/~seander/bithacks.html#ReverseByteWith64BitsDiv
function reverse10($i) { [int](([long]$i * 2254000986523650 -band 1171507928472027168) % 4095) }

function codeEdge($s) {
  [convert]::ToInt32($s.replace(".", "0").replace("#", "1"), 2)
}

function getBorders($s) {
  $top = codeEdge $s[0]
  $bottom = codeEdge $s[$s.length - 1]
  $left = codeEdge ($s.foreach({
        $_[0]
      }) -join "")
  $right = codeEdge ($s.foreach({
        $_[$_.length - 1]
      }) -join "")
  $top
  $bottom
  $left
  $right
  reverse10 $top
  reverse10 $bottom
  reverse10 $left
  reverse10 $right
}

$tiles = @{}
$lookup = @{}

$i.trim("`n").split("`n`n").foreach({
    $lines = $_.split("`n")
    $lines[0] -match "\d+" | Out-Null
    $tile = [int]$matches[0]
    $tiles[$tile] = getBorders ($lines | Select-Object -Skip 1)
    $tiles[$tile].foreach({
        if (!$lookup.ContainsKey($_)) { $lookup[$_] = @() }
        $lookup[$_] = @($lookup[$_]) + @($tile)
      })
  })

[long]$result = 1
$tiles.Keys.where({
    $tiles[$_].where({
        $lookup[$_].count -gt 1
      }).count -eq 4
  }).foreach({ $result *= $_ })

$result
