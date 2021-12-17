$i = Get-Content input.txt
$i = $i.split(",") | ForEach-Object { [int]$_ }

$lookup = @{}
(0..$($i.count - 1)).foreach({
    $lookup[$i[$_]] = $_
  })

$c = 0
($i.count..29999998).foreach({
    $d = if ($lookup.ContainsKey($c)) { $_ - $lookup[$c] } else { 0 }
    $lookup[$c], $c = $_, $d
  })
$c
