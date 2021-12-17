$i = Get-Content input.txt 

[regex]$rr = "(?<name>[^:]+): (?<n1>\d+)-(?<n2>\d+) or (?<n3>\d+)-(?<n4>\d+)"

class Rule {
  [string]$name
  [int]$n1;
  [int]$n2;
  [int]$n3;
  [int]$n4;
}

$rules = $i.foreach({
    $m = $rr.Match($_)
    if ($m.Success) {
      [Rule]@{name = $m.Groups["name"].Value; n1 = $m.Groups["n1"].Value; n2 = $m.Groups["n2"].Value; n3 = $m.Groups["n3"].Value; n4 = $m.Groups["n4"].Value }
    }
  })

[regex]$rt = "^(?:(?<num>\d+)(?:,|$)){20}"

$tickets = $i.foreach({
    $m = $rt.Match($_)
    if ($m.Success) {
      $m
    }
  })

function getMatchingRules($num) {
  $rules.where({ $_.n1 -le $num -and $_.n2 -ge $num -or $_.n3 -le $num -and $_.n4 -ge $num })
}

$nearby = $tickets | Select-Object -Skip 1

$nearby.foreach({
 ($_.Groups["num"].Captures | Select-Object -ExpandProperty Value).where({
        !(getMatchingRules $_)
      })
  }) | Measure-Object -Sum | Select-Object -ExpandProperty Sum
