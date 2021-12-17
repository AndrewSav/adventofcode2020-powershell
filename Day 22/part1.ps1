$i = Get-Content  -Raw input.txt

$x = $i.split("`n`n")
$p1 = $x[0].trim("`n").split("`n") | Select-Object -skip 1 | Foreach-Object { [int]$_ }
$p2 = $x[1].trim("`n").split("`n") | Select-Object -skip 1 | Foreach-Object { [int]$_ }

while ($true) {
  if ($p1.count -eq 0 -or $p2.count -eq 0) {
    $final = @($p1) + @($p2)
    [array]::Reverse($final)
    [long]$result = 0
    (0..($final.count - 1)).foreach({
        $result += $final[$_] * ($_ + 1)
      })
    $result
    exit
  }
  $t1 = $p1 | Select-Object -First 1
  $p1 = $p1 | Select-Object -Skip 1
  $t2 = $p2 | Select-Object -First 1
  $p2 = $p2 | Select-Object -Skip 1
  if ($t1 -gt $t2) {
    $p1 = @($p1) + @($t1) + @($t2)
  }
  else {
    $p2 = @($p2) + @($t2) + @($t1)
  }
}
