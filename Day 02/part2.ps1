$i = Get-Content input.txt
[regex]$r = "(?<min>\d+)-(?<max>\d+) (?<char>\w): (?<pwd>\w+)"
$i.where({
    $m = $r.Match($_)
    $d = ([char[]]$m.Groups["pwd"].Value)
    $d[$m.Groups["min"].Value - 1] -eq $m.Groups["char"].Value -xor $d[$m.Groups["max"].Value - 1] -eq $m.Groups["char"].Value
  }).Count
