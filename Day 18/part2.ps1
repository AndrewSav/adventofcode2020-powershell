$i = Get-Content input.txt

#https://web.archive.org/web/20201108113604/http://effbot.org/zone/simple-top-down-parsing.htm
class Literal { 
  [char]$c
  Literal([char]$c) {
    $this.c = $c
  }
  [long] nud() {
    return [long][string]$this.c
  }
}

class Paren { 
  [long] nud() {
    $r = expression
    $script:token = next
    return $r
  }
}

class Add { 
  [long]$lbp = 2
  [long] led($left) {
    $right = expression $this.lbp 
    return $left + $right
  }
}

class Mul { 
  [long]$lbp = 1
  [long] led($left) {
    $right = expression $this.lbp
    return $left * $right
  }
}

class Eof { 
}

function next {
  if ($i -lt $ss.count) {
    switch ($ss[$i]) {
      "+" { [Add]::new() }
      "*" { [Mul]::new() }
      "(" { [Paren]::new() }
      default { [Literal]::new($ss[$i]) }
    }
    $script:i++
  }
  else {
    [Eof]::new()
  }
}

function expression([long]$rbp=0) {
  $t = $token
  $script:token = next
  $left = $t.nud()
  while ($rbp -lt $token.lbp) {
    $t = $token
    $script:token = next $ss
    $left = $t.led($left)
  }
  return $left
}

$i.foreach({
    $script:ss = $_.replace(" ", "").ToCharArray()
    $script:i = 0
    $script:token = next
    expression
  }) | Measure-Object -Sum | Select-Object -ExpandProperty Sum
