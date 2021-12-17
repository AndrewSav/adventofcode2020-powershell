$i = Get-Content "input.txt"

$e = 0..$($i.length - 1) | Where-Object { !$i[$_] }

$r = $i | select-object -First $e
$m = $i | select-object -Skip ($e + 1)

[regex]$rr = '(?<key>\d+):(?:(?<list>(?: (?<val>\d+))+(?:$| \|))+|(?: "(?<char>\w)"))'

$parsed = @{}

$r.foreach({
    $mm = $rr.Match($_)
    if ($mm.Groups["list"].Success) {
      $list = $mm.Groups["list"].Captures
      $parsed[[int]$mm.Groups["key"].Value] = (0..$($list.count - 1)).foreach({
          $current = $list[$_]
          $next = $list[$_ + 1]
          @(, $mm.Groups["val"].Captures.where({
                $_.index -gt $current.index -and ($next -eq $null -or $_.index -lt $next.index)
              }).foreach({
                [int]$_.Value
              }))
        })
    }
    else {
      $parsed[[int]$mm.Groups["key"].Value] = $mm.Groups["char"].Value
    }
  })


function getExp($j) {
  if ($parsed[$j] -is [string]) {
    return $parsed[$j]
  }
  $alts = @(, $parsed[$j].foreach({
        $_.foreach({
            getExp $_
          }) -join ""
      }))
  "(?<r$j>$(($alts | ForEach-Object{ $_ }) -join '|'))"
}

$rz = getExp 0
$m.where({ $_ -match "^$rz$" }).count
