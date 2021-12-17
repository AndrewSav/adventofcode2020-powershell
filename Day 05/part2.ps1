$i = Get-Content input.txt
$s = $i.foreach({
    [convert]::ToInt32($_.Replace("F", "0").Replace("L", "0").Replace("B", "1").Replace("R", "1"), 2)
  }) | Sort-Object
$s[(0..($s.count - 2)).where({ $s[$_] + 1 -ne $s[$_ + 1] })[0]] + 1
