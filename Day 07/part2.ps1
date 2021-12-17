$i = Get-Content input.txt
$t = "shiny gold"

class Part {
  [string]$name
  [int]$number;
}

$contains = @{}

[regex]$rcontainer = "^(?<container>.*bag)s contain "
[regex]$rpart = "(?<num>\d+) (?<part>.*?bag)"

foreach ($x in $i) {
  $container = $rcontainer.Match($x).Groups["container"].Value
  $rpart.Matches($x) | ForEach-Object {
    if (!$contains.ContainsKey($container)) {
      $contains[$container] = @()
    }
    $contains[$container] += @([Part]@{name = $_.Groups["part"].Value; number = $_.Groups["num"].Value })
  }
}

function sumthem($bag) {
  ($contains[$bag].foreach({
    (sumthem $_.name) * $_.number
    }) | Measure-Object -Sum | Select-Object -ExpandProperty Sum) + 1
}

(sumthem "$t bag") - 1
