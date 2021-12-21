$i = Get-Content input.txt

class Result {
  [string]$remainder
  $value
  [bool]$success
}

$char = {
  param(
      [string]$in,
      $checkDigit
  )
  if ($in.length -gt 0 -and (&$checkDigit $in[0])) {
    [Result]@{remainder=$in.substring(1);value=$in[0];success=$true}
  } else {
    [Result]@{remainder=$in;success=$false}
  }
}

$num      =  { param([string]$in)&$char $in { param($in)[char]::isDigit($in) } }
$open     =  { param([string]$in)&$char $in { param($in)$in -eq "(" } }
$close    =  { param([string]$in)&$char $in { param($in)$in -eq ")" } }
$plus     =  { param([string]$in)&$char $in { param($in)$in -eq "+" } }
$asterisk =  { param([string]$in)&$char $in { param($in)$in -eq "*" } }

function then($first, $second) {
  { param([string]$in)
    $r1 = &$first $in
    if (!$r1.success) {
      return $r1
    }
    $r2 = &$second $r1.remainder
    if (!$r2.success) {
      return $r2
    }
    [Result]@{remainder=$r2.remainder;value=@($r1.value) + @($r2.value);success=$true}
  }.GetNewClosure()
}

function or($first, $second) {
  { param([string]$in)
    $r1 = &$first $in
    if ($r1.success) {
      return $r1
    }
    &$second $in
  }.GetNewClosure()
}

function chain($operator, $operand) {
  { param([string]$in)
    $acc = &$operand $in
    if (!$acc.success) {
      return $acc
    }
    $op = &$operator $acc.remainder
    while ($op.success) {
      $cur = &$operand $op.remainder
      if (!$cur.success) {
        return $cur
      }
      $acc = [Result]@{remainder=$cur.remainder;value=($op.value -eq "*" ? [long][string]$acc.Value * [long][string]$cur.Value : [long][string]$acc.Value + [long][string]$cur.Value);success=$true}
      $op = &$operator $cur.remainder
    }
    $acc
  }.GetNewClosure()
}

# forward declaration
function exp {
  { param([string]$in)
    &$exp $in
  }
}

$parenTemp = then $open (then (exp) $close)

$paren = {
  param([string]$in)
  $r1 = &$parenTemp $in
  if (!$r1.success) {
    return $r1
  }
  [Result]@{remainder=$r1.remainder;value=($r1.value.where({$_-ne"("-and$_-ne")"})|%{$_});success=$true}
}

$term1 = or $paren $num
$term2 = chain $plus $term1
$exp = chain $asterisk $term2

$i.foreach({
  (&$exp $_.replace(" ","")).value
  }) | Measure-Object -Sum | Select-Object -ExpandProperty Sum
