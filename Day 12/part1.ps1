$i = Get-Content input.txt
$x = 0; $y = 0; $d = "E"
$dd = "ESWN"

function x($n) { 
  switch ($n) {
    90 { 1 }
    180 { 2 }
    270 { 3 }
  }
}

function left($n) {
  (1..$(x $n)).foreach({ $script:d = $dd[($dd.indexof($d) - 1) % 4] })
}

function right($n) {
  (1..$(x $n)).foreach({ $script:d = $dd[($dd.indexof($d) + 1) % 4] })
}

function mov($c) {
  $w = $c[0]
  $n = [int]$c.substring(1)
  switch ($w) {
    "N" { $script:y += $n }
    "S" { $script:y -= $n }
    "E" { $script:x += $n }
    "W" { $script:x -= $n }
    "L" { left $n }
    "R" { right $n }
    "F" { mov "$d$n" }
  }
}

foreach ($l in $i) {
  mov $l  
}

[math]::Abs($x) + [math]::Abs($y)
