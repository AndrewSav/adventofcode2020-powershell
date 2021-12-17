$i = Get-Content input.txt | ForEach-Object { [int]$_ }
$card = $i[0]
$door = $i[1]

function findLoopSize($target) {
  $val = 1
  $subject = 7
  $mod = 20201227
  $i = 0
  while ($val -ne $target) {
    $val = $val * $subject % $mod
    $i++
  }
  $i
}

function transform($subject, $loopSize) {
  $val = 1
  $mod = 20201227
  $i = 0
  while ($i -lt $loopSize) {
    $val = $val * $subject % $mod
    $i++
  }
  $val
}

transform $door (findLoopSize $card)
#transform $card (findLoopSize $door)
