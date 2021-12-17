$i = Get-Content -Raw input.txt 
$req = "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"

function byr($x) {
  $x -match "^\d{4}$" -and [int]$x -ge 1920 -and [int]$x -le 2002
}

function iyr($x) {
  $x -match "^\d{4}$" -and [int]$x -ge 2010 -and [int]$x -le 2020
}

function eyr($x) {
  $x -match "^\d{4}$" -and [int]$x -ge 2020 -and [int]$x -le 2030
}

function hgt($x) {
  $m = ([regex]"^(?<h>\d{2,3})(?<u>in|cm)$").Match($x)
  $m.Success -and ( ($m.Groups["u"].Value -eq "in" -and $m.Groups["h"].Value -ge 59 -and $m.Groups["h"].Value -le 76) -or (
      $m.Groups["u"].Value -eq "cm" -and $m.Groups["h"].Value -ge 150 -and $m.Groups["h"].Value -le 193))
}

function hcl($x) {
  $x -match "^#[0-9a-f]{6}$"
}

function ecl($x) {
  $x -match "^amb|blu|brn|gry|grn|hzl|oth$"

}

function pid($x) {
  $x -match "^\d{9}$"
}

$pp = $i -split "`n`n"
[regex]$r = "(?<code>\w{3}):(?<data>\S+)"
$pp.where({
    $a = @{}
    $r.Matches($_).foreach({ $a.Add($_.Groups["code"].Value, $_.Groups["data"].Value) })
    $req.where({ $a.ContainsKey($_) -and (& $_ $a[$_]) }).Count -eq $req.Count  
  }).Count
