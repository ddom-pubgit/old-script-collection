<#Code block to handle Location association with proxies. 
Only really works  with Virtual proxies, right now not a "convenient" way of associating
a Location to physical proxies
Change the first line in the foreach loop if the environment is not VMware
#>

Add-PSSnapin VeeamPSSnapin

$validProxy = @()
$proxyselect = @()
$vm = Find-VBRvientity -VMsandTemplates -Name "DDom-tag-test"
$vmlocation = Get-VBRLocation -Object $vm
$currentProxies = Get-VBRviProxy

function Find-ProxyViEntity {
param (
	[object[]]$proxy
	)
	$proxyEntity = Find-VBRViEntity -VMsandTemplates -Name $($proxy.GetHost().Name)
        if(!($proxyEntity)){
               $proxyEntity = Find-VBRViEntity -VMsandTemplates -Name $($proxy.GetHost().Name.Split(".")[0])
               }
	Return $proxyEntity
}


foreach($proxy in Get-VBRViProxy){
    if($proxy.ChassisType -ne 'ViVirtual'){
        $proxyselect += $proxy
    } else {
		$foundProxy = Find-ProxyViEntity -proxy $proxy
		if(!($foundProxy)){
			$proxyselect += $proxy
			} else {
				if($vmlocation.Name -eq (Get-VBRLocation -Object $foundProxy).name){
            $validProxy += $proxy
            }
        }
     }
}
	 
if ($proxyselect){
    $validproxy += ($proxyselect | Out-Gridview -passthru)
}