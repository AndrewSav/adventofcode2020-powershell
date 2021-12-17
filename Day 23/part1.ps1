$i = Get-Content input.txt

$lookup = @{}

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

class Cup {
  [Cup]$next
  [Cup]$previous
  [int]$value
  [bool]$moving
}

$cup = $null
$previous = $null

$i.ToCharArray().foreach({
    [Helper]::initVal([int][string]$_)
  })

$previous.next = $cup
$cup.previous = $previous

$linkLength = 3

for ($a = 0; $a -lt 100; $a++) {
  $c = $cup
  for ($b = 0; $b -lt $linkLength; $b++) {
    $c = $c.next
    if ($b -eq 0) { $first = $c } 
    if ($b -eq ($linkLength - 1)) { $last = $c } 
    $c.moving = $true
  }
  $nextValue = $null
  do {
    if (!$nextValue) { $nextValue = $cup.value }
    $nextValue--
    if ($nextValue -eq 0) { $nextValue = $lookup.Keys.Count }
  } while ($lookup[$nextValue].moving)
  $next = $lookup[$nextValue]
  $c = $cup
  for ($b = 0; $b -lt $linkLength; $b++) {
    $c = $c.next
    $c.moving = $false
  }
  
  $cup.next = $last.next
  $last.next.previous = $cup

  $first.previous = $next
  $last.next = $next.next

  $next.next = $first
  $last.next.previous = $last

  $cup = $cup.next
}
$c = $lookup[1].next
$(while ($c.value -ne 1) { $c.value; $c = $c.next }) -join ""
