function Create-RepositoryObject {
	param(
		[string]$RInput
		)
	$DataSplit = $RInput.Split(",")
	switch($DataSplit.Count)
	{
		24 {$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[0].Split()[12].Substring(0,$($DataSplit[0].Split()[12].Length-1)))"=$DataSplit[0].Split()[13]
				"$($DataSplit[1].Split()[1].Substring(0,$($DataSplit[1].Split()[1].Length-1)))"=$DataSplit[1].Split()[2]
				"$($DataSplit[2].Split()[1].Substring(0,$($DataSplit[2].Split()[1].Length-1)))"=$DataSplit[2].Split()[2]
				"$($DataSplit[3].Split()[1].Substring(0,$($DataSplit[3].Split()[1].Length-1)))"=$DataSplit[3].Split()[2]
				"ConcurrentTaskLimitEnabled"=$DataSplit[4].Split()[3]
				"$($DataSplit[5].Split()[1].Substring(0,$($DataSplit[5].Split()[1].Length-1)))"=$DataSplit[5].Split()[2].Substring(1,1)
				"$($DataSplit[9].Split()[1].Substring(0,$($DataSplit[9].Split()[1].Length-1)))"=$DataSplit[9].Split()[2]
				"$($DataSplit[14].Split()[1].Substring(0,$($DataSplit[14].Split()[1].Length-1)))"=$DataSplit[14].Split()[2]
				"$($DataSplit[15].Split()[1].Substring(0,$($DataSplit[15].Split()[1].Length-1)))"=$DataSplit[15].Split()[2]
				#"$($DataSplit[16].Split()[1].Substring(0,$($DataSplit[16].Split()[1].Length-1)))"=$DataSplit[16].Split()[2]
				#"$($DataSplit[17].Split()[1].Substring(0,$($DataSplit[17].Split()[1].Length-1)))"=$DataSplit[17].Split()[2]
				"$($DataSplit[18].Split()[1].Substring(0,$($DataSplit[18].Split()[1].Length-1)))"=$DataSplit[18].Split()[2]
				"$($DataSplit[19].Split()[1].Substring(0,$($DataSplit[19].Split()[1].Length-1)))"=$DataSplit[19].Split()[2]
			}
		}
		25 {$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[0].Split()[12].Substring(0,$($DataSplit[0].Split()[12].Length-1)))"=$DataSplit[0].Split()[13]
				"$($DataSplit[1].Split()[1].Substring(0,$($DataSplit[1].Split()[1].Length-1)))"=$DataSplit[1].Split()[2]
				"$($DataSplit[2].Split()[1].Substring(0,$($DataSplit[2].Split()[1].Length-1)))"=$DataSplit[2].Split()[2]
				"$($DataSplit[3].Split()[1].Substring(0,$($DataSplit[3].Split()[1].Length-1)))"=$DataSplit[3].Split()[2]
				"ConcurrentTaskLimitEnabled"=$DataSplit[4].Split()[3]
				"$($DataSplit[5].Split()[1].Substring(0,$($DataSplit[5].Split()[1].Length-1)))"=$DataSplit[5].Split()[2].Substring(1,1)
				"$($DataSplit[9].Split()[1].Substring(0,$($DataSplit[9].Split()[1].Length-1)))"=$DataSplit[9].Split()[2]
				"$($DataSplit[14].Split()[1].Substring(0,$($DataSplit[14].Split()[1].Length-1)))"=$DataSplit[14].Split()[2]
				"$($DataSplit[15].Split()[1].Substring(0,$($DataSplit[15].Split()[1].Length-1)))"=$DataSplit[15].Split()[2]
				"$($DataSplit[16].Split()[1].Substring(0,$($DataSplit[16].Split()[1].Length-1)))"=$DataSplit[16].Split()[2]
				"$($DataSplit[17].Split()[1].Substring(0,$($DataSplit[17].Split()[1].Length-1)))"=$DataSplit[17].Split()[2]
				"$($DataSplit[18].Split()[1].Substring(0,$($DataSplit[18].Split()[1].Length-1)))"=$DataSplit[18].Split()[2]
				"$($DataSplit[19].Split()[1].Substring(0,$($DataSplit[19].Split()[1].Length-1)))"=$DataSplit[19].Split()[2]
				#"$($DataSplit[20].Split()[1].Substring(0,$($DataSplit[20].Split()[1].Length-1)))"=$DataSplit[20].Split()[2]
				#"$($DataSplit[21].Split()[1].Substring(0,$($DataSplit[21].Split()[1].Length-1)))"=$DataSplit[21].Split()[2]
				"$($DataSplit[22].Split()[1].Substring(0,$($DataSplit[22].Split()[1].Length-1)))"=$DataSplit[22].Split()[2]
				"$($DataSplit[23].Split()[1].Substring(0,$($DataSplit[23].Split()[1].Length-1)))"=$DataSplit[23].Split()[2]
			}
		}
		21 {$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[0].Split()[12].Substring(0,$($DataSplit[0].Split()[12].Length-1)))"=$DataSplit[0].Split()[13]
				"$($DataSplit[1].Split()[1].Substring(0,$($DataSplit[1].Split()[1].Length-1)))"=$DataSplit[1].Split()[2]
				"$($DataSplit[2].Split()[1].Substring(0,$($DataSplit[2].Split()[1].Length-1)))"=$DataSplit[2].Split()[2]
				"$($DataSplit[3].Split()[1].Substring(0,$($DataSplit[3].Split()[1].Length-1)))"=$DataSplit[3].Split()[2]
				"ConcurrentTaskLimitEnabled"=$DataSplit[4].Split()[3]
				"$($DataSplit[5].Split()[1].Substring(0,$($DataSplit[5].Split()[1].Length-1)))"=$DataSplit[5].Split()[2].Substring(1,1)
				"$($DataSplit[9].Split()[1].Substring(0,$($DataSplit[9].Split()[1].Length-1)))"=$DataSplit[9].Split()[2]
				"$($DataSplit[10].Split()[1].Substring(0,$($DataSplit[10].Split()[1].Length-1)))"=$DataSplit[10].Split()[2]
				"$($DataSplit[14].Split()[1].Substring(0,$($DataSplit[14].Split()[1].Length-1)))"=$DataSplit[14].Split()[2]
				"$($DataSplit[16].Split()[1].Substring(0,$($DataSplit[16].Split()[1].Length-1)))"=$DataSplit[16].Split()[2].Substring(1,$DataSplit[16].Split()[2].Length-1)
				"$($DataSplit[17].Split()[1].Substring(0,$($DataSplit[17].Split()[1].Length-1)))"=$DataSplit[17].Split()[2].SubString(1,$DataSplit[17].Split()[2].Length-3)
				"$($DataSplit[18].Split()[1].Substring(0,$($DataSplit[18].Split()[1].Length-1)))"=$DataSplit[18].Split(":")[1].SubString(1,$DataSplit[18].Split(":")[1].Length-1)
				"$($DataSplit[19].Split()[1].Substring(0,$($DataSplit[19].Split()[1].Length-1)))"=$DataSplit[19].Split(":")[1].SubString(1,$DataSplit[19].Split(":")[1].Length-1)
			}
		}
		15 {if(!($DataSplit.Split(",")[1].Split(":")[1] -like "*NFS*")){Continue}
			$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[0].Split()[12].Substring(0,$($DataSplit[0].Split()[12].Length-1)))"=$DataSplit[0].Split()[13]
				"$($DataSplit[1].Split()[1].Substring(0,$($DataSplit[1].Split()[1].Length-1)))"=$DataSplit[1].Split()[2]
				"$($DataSplit[2].Split()[1].Substring(0,$($DataSplit[2].Split()[1].Length-1)))"=$DataSplit[2].Split()[2]
				"$($DataSplit[3].Split()[1].Substring(0,$($DataSplit[3].Split()[1].Length-1)))"=$DataSplit[3].Split()[2]
				"ConcurrentTaskLimitEnabled"=$DataSplit[4].Split()[3]
				"$($DataSplit[5].Split()[1].Substring(0,$($DataSplit[5].Split()[1].Length-1)))"=$DataSplit[5].Split()[2].Substring(1,1)
				"$($DataSplit[9].Split()[1].Substring(0,$($DataSplit[9].Split()[1].Length-1)))"=$DataSplit[9].Split()[2]
			}
		}
	}
	Return $RepositoryObject
}