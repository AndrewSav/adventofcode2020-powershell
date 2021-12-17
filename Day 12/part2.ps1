$i = Get-Content input.txt
$x = 0; $y = 0;
$wx = 10; $wy = 1

function x($n) { 
  switch ($n) {
    90 { 1 }
    180 { 2 }
    270 { 3 }
  }
}

function left($n) {
  (1..$(x $n)).foreach({ $script:wx, $script:wy = - $script:wy, $script:wx })
}

function right($n) {
  (1..$(x $n)).foreach({ $script:wx, $script:wy = $script:wy, - $script:wx })
}

function mov($c) {
  $w = $c[0]
  $n = [int]$c.substring(1)
  switch ($w) {
    "N" { $script:wy += $n }
    "S" { $script:wy -= $n }
    "E" { $script:wx += $n }
    "W" { $script:wx -= $n }
    "L" { left $n }
    "R" { right $n }
    "F" { (1..$n).foreach({ $script:x += $wx; $script:y += $wy }) }
  }
}

foreach ($l in $i) {
  mov $l  
}

[math]::Abs($x) + [math]::Abs($y)
