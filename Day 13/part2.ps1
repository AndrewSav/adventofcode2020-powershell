# https://rosettacode.org/wiki/Chinese_remainder_theorem
$i = Get-Content input.txt

function modinv([long]$a, [long]$mod) {
  $b = $a % $mod
  for ([long]$x = 1; $x -lt $mod; $x++) {
    if (($b * $x) % $mod -eq 1) {
      return $x
    }
  }
  1
}

$ii = $i[1].split(",")
$d = (0..$($ii.length - 1)).foreach({ if ($ii[$_] -ne "x") { [pscustomobject]@{id = $ii[$_]; offset = ($ii[$_] - $_ % $ii[$_]) % $ii[$_] } } })

[long]$prod = 1
[long]$sm = 0
$d.foreach({ $prod *= $_.id })
$d.foreach({ $p = $prod / $_.id; $sm += $_.offset * (modinv $p $_.id) * $p })
$sm % $prod
