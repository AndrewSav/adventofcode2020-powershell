$i = Get-Content input.txt

$mem = @{}
[regex]$r = "mem\[(?<addr>\d+)\] = (?<val>\d+)"
$i.foreach({
    if ($_.StartsWith("mask")) { 
      $m = $_.Substring(7)
      $andmask = [convert]::ToInt64($m.Replace("X", "1"), 2)
      $ormask = [convert]::ToInt64($m.Replace("X", "0"), 2)
    }
    if ($_.StartsWith("mem[")) {
      $m = $r.Match($_)
      $mem[$m.Groups["addr"].Value] = [long]($m.Groups["val"].Value) -band $andmask -bor $ormask
    }
  })

$mem.Values | Measure-Object -Sum | Select-Object -ExpandProperty Sum
