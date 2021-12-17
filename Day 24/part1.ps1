$i = Get-Content input.txt

#https://www.redblobgames.com/grids/hexagons/#coordinates

$state = @{}

[regex]$rr = "se|sw|ne|nw|e|w"
$i.foreach({
    $q = 0; $s = 0; $r = 0
  ($rr.Matches($_) | Select-Object -ExpandProperty Value).foreach({
        switch ($_) {
          "se" { $q += 0; $s += -1; $r += +1 }
          "sw" { $q += -1; $s += 0; $r += +1 }
          "ne" { $q += +1; $s += 0; $r += -1 }
          "nw" { $q += 0; $s += +1; $r += -1 }
          "e" { $q += +1; $s += -1; $r += 0 }
          "w" { $q += -1; $s += +1; $r += 0 }
        }
      })
    if ($state.ContainsKey("$q,$s,$r")) {
      $state["$q,$s,$r"] = !$state["$q,$s,$r"]
    }
    else {
      $state["$q,$s,$r"] = $true
    }
  })

$state.Values.where({ $_ }).count
