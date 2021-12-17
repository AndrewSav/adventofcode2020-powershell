$i = Get-Content input.txt
$i.foreach({
    [convert]::ToInt32($_.Replace("F", "0").Replace("L", "0").Replace("B", "1").Replace("R", "1"), 2)
  }) | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum



