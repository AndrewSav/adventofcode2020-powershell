$i = Get-Content input.txt | ForEach-Object { [long]$_ } | Sort-Object

$i = @(0) + $i + @($i[$i.count - 1] + 3)

$a = foreach ($c in 1..($i.Count - 2)) {
  if ($i[$c] - $i[$c - 1] -eq 1 -and $i[$c + 1] - $i[$c] -eq 1) {
    $i[$c]
  }
}

$b = & {
  $counter = 1
  foreach ($c in 1..($a.Count - 1)) {
    if ($a[$c] - $a[$c - 1] -ne 1) {
      $counter
      $counter = 1
    }
    else {
      $counter++
    }
  }
  $counter
}

function check($bits, $num) {
  $counter = 0
  foreach ($c in 0..($bits - 1)) {
    if (($num -band 1) -eq 0) {
      $counter++
      if ($counter -gt 2) {
        return $false
      }
    }
    else {
      $counter = 0
    }
    $num = $num -shr 1
  }
  return $true
}

function run($bits) {
  (0..([math]::Pow(2, $bits) - 1)).where({
      check $bits $_
    }).count
}

$c = @{}
($b | Select-Object -Unique).foreach({ $c[$_] = run $_ })

# Strictly speaking everything starting with function check until here can per replaced by the following line:
#$c = @{1=2;2=4;3=7}

$r = 1
$b.foreach({
    $r *= $c[$_]
  })
$r
