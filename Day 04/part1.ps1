$i = Get-Content -Raw input.txt 
$req = "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"
$pp = $i -split "`n`n"
[regex]$r = "(?<code>\w{3}):(?<data>\S+)"
$pp.where({  
    $cc = $r.Matches($_).foreach({ $_.Groups["code"].Value })
    $req.where({ $cc -contains $_ }).Count -eq $req.Count  
  }).Count
