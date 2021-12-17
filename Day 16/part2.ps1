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

[regex]$rt = "^(?:(?<num>\d+)(?:,|$)){$($rules.count)}"

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

$valid = $nearby.where({
    !($_.Groups["num"].Captures | Select-Object -ExpandProperty Value).where({
        !(getMatchingRules $_)
      })
  })

$validRules = ($tickets[0].Groups["num"].Captures | Select-Object -ExpandProperty Value).foreach({
    @(, (getMatchingRules $_))
  })

$valid.foreach({
    $m = $_
 (0..$($rules.count - 1)).foreach({
        $i = $_
        $validRules[$i] = $validRules[$i].where({ (getMatchingRules ($m.Groups["num"].Captures[$i].Value)) -contains $_ })
      })
  })

do {
  $settled = $validRules.where({ $_.count -eq 1 })
  $validRules = $validRules.foreach({ @(, $(if ($_.Count -eq 1) { $_ } else { $_.where({ ($settled | ForEach-Object { $_ }) -notcontains $_ }) })) })
} while ($settled.count -ne $rules.count)

[long]$result = 1
(0..$($rules.count - 1)).foreach({
    if ($validRules[$_][0].name.startsWith("departure")) {
      $result *= $tickets[0].Groups["num"].Captures[$_].Value    
    }
  })

$result
