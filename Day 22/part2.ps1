$i = Get-Content  -Raw input.txt

$x = $i.split("`n`n")
$p1 = $x[0].trim("`n").split("`n") | Select-Object -skip 1 | Foreach-Object { [int]$_ }
$p2 = $x[1].trim("`n").split("`n") | Select-Object -skip 1 | Foreach-Object { [int]$_ }

class Victory {
  [string]$winner
  [long]$score
}

function score($final) {
  [array]::Reverse($final)
  [long]$result = 0
    (0..($final.count - 1)).foreach({
      $result += $final[$_] * ($_ + 1)
    })
  $result
}

function pos($p1, $p2) {
  "$($p1 -join ',')|$($p2 -join ',')"
}

function game($p1, $p2) {
  $positions = @{}
  while ($true) {
    $pos = pos $p1 $p2
    if ($positions.ContainsKey($pos)) {
      $winner = "Player 1"
      $score = score @($p1)
      [Victory]@{winner = $winner; score = $score }      
      break 
    }
    else {
      $positions[$pos] = $true
    }
    if ($p1.count -eq 0 -or $p2.count -eq 0) {
      $winner = $p1.count -eq 0 ? "Player 2" : "Player 1"
      $score = score (@($p1) + @($p2))
      [Victory]@{winner = $winner; score = $score }
      break
    }
    $t1 = $p1 | Select-Object -First 1
    $p1 = $p1 | Select-Object -Skip 1
    $t2 = $p2 | Select-Object -First 1
    $p2 = $p2 | Select-Object -Skip 1
    if ($t1 -le $p1.count -and $t2 -le $p2.count) {
      $newp1 = $p1 | Select-Object -First $t1
      $newp2 = $p2 | Select-Object -First $t2
      $result = game $newp1 $newp2
      if ($result.winner -eq "Player 1") {
        $p1 = @($p1) + @($t1) + @($t2)
      }
      else {
        $p2 = @($p2) + @($t2) + @($t1)
      }
    }
    else {
      if ($t1 -gt $t2) {
        $p1 = @($p1) + @($t1) + @($t2)
      }
      else {
        $p2 = @($p2) + @($t2) + @($t1)
      }
    }
  }
}

(game $p1 $p2).score
