$i = Get-Content input.txt
[regex]$r = "(?<min>\d+)-(?<max>\d+) (?<char>\w): (?<pwd>\w+)"
$i.where({
    $m = $r.Match($_)
    $c = ([char[]]$m.Groups["pwd"].Value).where({ $_ -eq $m.Groups["char"].Value }).count
    $c -ge $m.Groups["min"].Value -and $c -le $m.Groups["max"].Value
  }).Count
