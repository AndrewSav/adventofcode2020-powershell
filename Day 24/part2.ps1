$i = Get-Content input.txt

$state = @{}
$directions = "nw", "ne", "e", "se", "sw", "w"

class Helper { 
  static [int[]] adjacent([string]$direction, [int]$q, [int]$s, [int]$r) {
    switch ($direction) {
      "se" { $q += 0; $s += -1; $r += +1 }
      "sw" { $q += -1; $s += 0; $r += +1 }
      "ne" { $q += +1; $s += 0; $r += -1 }
      "nw" { $q += 0; $s += +1; $r += -1 }
      "e" { $q += +1; $s += -1; $r += 0 }
      "w" { $q += -1; $s += +1; $r += 0 }
    }
    return $q, $s, $r
  }
}

[regex]$rr = "se|sw|ne|nw|e|w"
$i.foreach({
    $q = 0; $s = 0; $r = 0
  ($rr.Matches($_) | Select-Object -ExpandProperty Value).foreach({
        $q, $s, $r = [Helper]::adjacent($_, $q, $s, $r)
      })
    if ($state.ContainsKey("$q,$s,$r")) {
      $state["$q,$s,$r"] = !$state["$q,$s,$r"]
    }
    else {
      $state["$q,$s,$r"] = $true
    }
  })

$($state.Keys).foreach({ if (!$state[$_]) { $state.Remove($_) } })

1..100 | Foreach-Object {
  $($state.Keys).foreach({
      $q, $s, $r = [int[]]($_ -split ',') 
      foreach ($d in $directions) {
        $q1, $s1, $r1 = [Helper]::adjacent($d, $q, $s, $r)
        if (!$state.ContainsKey("$q1,$s1,$r1")) {
          $state["$q1,$s1,$r1"] = $false
        }    
      }
    })

  $nextState = @{}

  $($state.Keys).foreach({
      $q, $s, $r = [int[]]($_ -split ',') 
      $nb = $directions.where({
          $q1, $s1, $r1 = [Helper]::adjacent($_, $q, $s, $r)
          $state["$q1,$s1,$r1"]
        }).count
      if ($state["$q,$s,$r"]) {
        if ($nb -eq 1 -or $nb -eq 2) {
          $nextState["$q,$s,$r"] = $true
        }
      }
      else {
        if ($nb -eq 2) {
          $nextState["$q,$s,$r"] = $true
        }
      }
    })
  $state = $nextState
}

$state.Count
