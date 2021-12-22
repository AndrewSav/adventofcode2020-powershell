$i = Get-Content input.txt

class Result {
  [string]$remainder
  $value
}

function paren($in) { # paren => ( expr )
  if ($in[0] -ne "(") { return }
  $r = &$expr $in.substring(1)
  if (!$r) { return }
  if ($r.remainder[0] -ne ")") { return }
  [Result]@{remainder=$r.remainder.substring(1);value=$r.value}
}

function factor($in) { # factor => paren | const
  $r = paren $in
  if ($r) { return $r }
  if (![char]::isDigit($in[0])) { return }
  [Result]@{remainder=$in.substring(1);value=[long][string]$in[0]}
}

function term($in) { # term => factor * term | factor
  $r = factor $in
  if (!$r) { return }
  if ($r.remainder[0] -ne "+") { return $r }
  $r2 = term $r.remainder.substring(1)
  if (!$r2) { return $r }
  [Result]@{remainder=$r2.remainder;value=$r.value+$r2.value}
}

function expr($in) { # expr -> term + expr | term
  $r = term $in
  if (!$r) { return }
  if ($r.remainder[0] -ne "*") { return $r }
  $r2 = expr $r.remainder.substring(1)
  if (!$r2) { return }
  [Result]@{remainder=$r2.remainder;value=$r.value*$r2.value}
}
$expr = $function:expr

$i.foreach({
  (expr $_.replace(" ","")).value
  }) | Measure-Object -Sum | Select-Object -ExpandProperty Sum
