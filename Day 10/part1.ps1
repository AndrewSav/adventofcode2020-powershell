$i = Get-Content input.txt | ForEach-Object { [int]$_ } | Sort-Object
$one = 0
$three = 1
if ($i[0] -eq 3) { $three++ }
if ($i[0] -eq 1) { $one++ }
foreach ($c in 1..($i.Count - 1)) {
  if ($i[$c] - $i[$c - 1] -eq 3) { $three++ }
  if ($i[$c] - $i[$c - 1] -eq 1) { $one++ }
}
$one * $three
