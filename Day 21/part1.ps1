$i = Get-Content input.txt

class Food {
  [string[]]$ingredients
  [string[]]$allergens
}

[regex]$r = "(?:(?<ingredients>\w+) )+\(contains (?:(?<allergens>\w+)(, |))+\)"

$z = $i.foreach({
    $m = $r.Match($_)
    $allergens = @($m.Groups["allergens"].Captures | Select-Object -ExpandProperty value)
    $ingredients = @($m.Groups["ingredients"].Captures | Select-Object -ExpandProperty value)
    [Food]@{ingredients = $ingredients; allergens = $allergens }
  })

function intersectTwo([string[]] $a, [string[]] $b) {
  $a | Where-Object { $b -contains $_ }
}

function intersectMany([object[]] $a) {
  if ($a.count -eq 0) { return $a }
  if ($a.count -eq 1) { return $a[0] }
  $current = $a[0]
  (1..($a.count - 1)).foreach({
      $index = $_
      $current = $current | Where-Object { $a[$index] -contains $_ }
    })
  $current
}

$y = for ($a = 0; $a -le $z.count - 1; $a++) {
  for ($b = $a + 1; $b -le $z.count - 1; $b++) {
    $food = [Food]@{ingredients = @(intersectTwo $z[$a].ingredients  $z[$b].ingredients); allergens = @(intersectTwo $z[$a].allergens  $z[$b].allergens) }
    if ($food.allergens.count -gt 0 ) { $food }
  }
}

$x = ($z.allergens | Select-Object -Unique).foreach({
    $allergen = $_
    $all = $y.where({ $_.allergens.count -eq 1 -and $_.allergens[0] -eq $allergen }).foreach({ @(, $_.ingredients) })
  
    [Food]@{ingredients = @(intersectMany $all ); allergens = @($allergen) }
  })


$ai = @{}

while ($ai.keys.count -lt $x.count ) {
  $x.foreach({
      if ($_.ingredients.count -gt 1) {
        $_.ingredients = $_.ingredients.where({ $ai.values -notcontains $_ }) 
      }
      if ($_.ingredients.count -eq 1) {
        $ai[$_.allergens[0]] = $_.ingredients[0]
      }
    })
}

$z.foreach({
    $_.ingredients.where({ $ai.values -notcontains $_ }).count
  }) | Measure-Object -Sum | Select-Object -ExpandProperty Sum
