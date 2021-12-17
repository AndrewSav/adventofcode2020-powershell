$i = Get-Content input.txt

function run {
  $acc = 0
  $pc = 0
  $visited = @{}

  while (!$visited.ContainsKey($pc) -and $pc -ne $i.Count) {
    $visited[$pc] = $true
    switch ($i[$pc].Substring(0, 3)) {
      "nop" { $pc++ }
      "acc" { $acc += [int]$i[$pc].Substring(4); $pc++ }
      "jmp" { $pc += [int]$i[$pc].Substring(4) }
    }
  }
  $pc -eq $i.Count
  $acc
}

0..($i.count - 1) | ForEach-Object {
  $i = Get-Content input.txt
  $j = $_
  switch ($i[$_].Substring(0, 3)) {
    "nop" { $i[$j] = $i[$j].Replace("nop", "jmp") }
    "jmp" { $i[$j] = $i[$j].Replace("jmp", "nop") }
  }
  $succes, $acc = run
  if ($succes) {
    $acc
    exit
  }
}
