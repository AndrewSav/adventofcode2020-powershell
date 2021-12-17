$i = Get-Content input.txt
$t = "shiny gold"

$containedin = @{}

[regex]$rcontainer = "^(?<container>.*bag)s contain "
[regex]$rpart = "(?<num>\d+) (?<part>.*?bag)"

foreach ($x in $i) {
  $container = $rcontainer.Match($x).Groups["container"].Value
  $rpart.Matches($x) | ForEach-Object {
    if (!$containedin.ContainsKey($_.Groups["part"].Value)) {
      $containedin[$_.Groups["part"].Value] = @()
    }
    $containedin[$_.Groups["part"].Value] += @($container)
  }
}

$result = @($containedin["$t bag"])
do {
  $lastResult = $result.count
  $newResult = @()
  $result.foreach({ $newResult += @($containedin[$_]) })
  $result = @($result + $newResult | Select-Object -Unique)
} while ($result.count -ne $lastResult)
$result.Count
