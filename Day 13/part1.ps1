$i = Get-Content input.txt
$t = [int]$i[0]

$i[1].split(",").where({ $_ -ne "x" }).foreach({ [pscustomobject]@{wait = ($_ - $t % $_); id = $_ } }) |
sort-object wait | select-object -first 1 @{label = "r"; expression = { $_.wait * $_.id } } | select-object -ExpandProperty r
