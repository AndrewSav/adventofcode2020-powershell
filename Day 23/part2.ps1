$i = Get-Content input.txt

$lookup = @{}

class Cup {
  [Cup]$next
  [Cup]$previous
  [int]$value
  [bool]$moving
}

$cup = $null
$previous = $null

# https://github.com/PowerShell/PowerShell/issues/8482#issuecomment-457347691
class Helper { 
  static [void] initVal([int]$val) {
    $c = [Cup]@{previous = $script:previous; value = $val }
    $script:lookup[$val] = $c
    if (!$script:cup) { $script:cup = $c } 
    if ($script:previous) {
      $script:previous.next = $c
    }
    $script:previous = $c
  }
}

$i.ToCharArray().foreach({
    [Helper]::initVal([int][string]$_)
  })

for ($val = $lookup.keys.count + 1; $val -le 1000000; $val++) {
  [Helper]::initVal($val)
}

$previous.next = $cup
$cup.previous = $previous

for ($a = 0; $a -lt 10000000; $a++) {
  $c = $cup
  $first = $cup.next
  $middle = $first.next
  $last = $middle.next
  $first.moving = $true
  $middle.moving = $true
  $last.moving = $true
  $nextValue = $null
  do {
    if (!$nextValue) { $nextValue = $cup.value }
    $nextValue--
    if ($nextValue -eq 0) { $nextValue = $lookup.Keys.Count }
  } while ($lookup[$nextValue].moving)
  $next = $lookup[$nextValue]
  $first.moving = $false
  $middle.moving = $false
  $last.moving = $false 
  $cup.next = $last.next
  $last.next.previous = $cup
  $first.previous = $next
  $last.next = $next.next
  $next.next = $first
  $last.next.previous = $last
  $cup = $cup.next
}
[long]$lookup[1].next.value * [long]$lookup[1].next.next.value
