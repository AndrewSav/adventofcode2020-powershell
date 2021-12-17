$i = Get-Content input.txt

function getSub([string]$s, [int]$i) {
  $ss = $s.ToCharArray()
  $c = 0
  $j = $i
  while ($true) {
    if ($ss[$j] -eq "(") {
      $c++;
    }
    if ($ss[$j] -eq ")") {
      $c--
      if ($c -eq 0) {
        return $s.substring($i + 1, $j - $i - 1)
      }
    }
    $j++
  }
}

function applyOp($r, $op, $v) {
  switch ($op) {
    "+" { $r + $v }
    "*" { $r * $v }
  }
}

function calc([string]$s) {
  $ss = $s.ToCharArray()
  $op = "+"
  $r = 0
  $i = 0
  while ($i -lt $s.Length) {
    switch ($ss[$i]) {
      "+" { $op = "+" }
      "*" { $op = "*" }
      "(" { 
        $sub = getSub $s $i  
        $r = applyOp $r $op (calc $sub)
        $i = $i + $sub.Length + 1
      }
      default { $r = applyOp $r $op ([int][string]$ss[$i]) }
    }
    $i++
  }
  $r
}

$i.foreach({
    calc $_.replace(" ", "")
  }) | Measure-Object -Sum | Select-Object -ExpandProperty Sum

