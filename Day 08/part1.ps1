$i = Get-Content input.txt
$acc = 0
$pc = 0
$visited = @{}

while (!$visited.ContainsKey($pc)) {
  $visited[$pc] = $true
  switch ($i[$pc].Substring(0, 3)) {
    "nop" { $pc++ }
    "acc" { $acc += [int]$i[$pc].Substring(4); $pc++ }
    "jmp" { $pc += [int]$i[$pc].Substring(4) }
  }
}
$acc
