$i = Get-Content input.txt

function float($m) {
  $i = (0..$($m.length - 1)).where({ $m[$_] -eq "X" })
  (0..$([math]::Pow(2, $i.Count) - 1)).foreach({
      $c = $_
      $mm = $m
      $i.foreach({
          $mm = $mm.remove($_, 1).insert($_, ($c -band 1))
          $c = $c -shr 1
        })
      [convert]::ToInt64($mm, 2)
    })	
}

function orx($z, $mask) {
  (0..35).foreach({
      if ($mask.ToCharArray()[$_] -eq "X") {
        $z = $z.remove($_, 1).insert($_, "X")
      }
      else {
        $c = [int][string]$mask.ToCharArray()[$_] -bor [int][string]$z.ToCharArray()[$_]
        $z = $z.remove($_, 1).insert($_, $c)
      }
    })
  $z
}

$mem = @{}
[regex]$r = "mem\[(?<addr>\d+)\] = (?<val>\d+)"
$i.foreach({
    if ($_.StartsWith("mask")) { 
      $mask = $_.Substring(7)
    }
    if ($_.StartsWith("mem[")) {
      $m = $r.Match($_)
      $z = orx ([convert]::ToString([long]$m.Groups["addr"].Value, 2).PadLeft(36, "0")) $mask
    (float $z).foreach({     
          $mem[$_] = [long]($m.Groups["val"].Value)
        })
    }
  })

$mem.Values | Measure-Object -Sum | Select-Object -ExpandProperty Sum
