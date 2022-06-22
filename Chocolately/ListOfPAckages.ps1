$packagesRaw = Get-ChildItem C:\ProgramData\chocolatey\lib\ -Recurse *.nuspec | select fullname,name 
$packagesInclDependencies = $packagesRaw | % {
	[XML]$xml=get-content $_.fullname
	$xml.package.metadata.dependencies.dependency | % {
        [PSCustomObject]@{
            Package           = $xml.package.metadata.id
            PackageVersion    = $xml.package.metadata.version
            Dependency        = $_.id
            DependencyVersion = $_.version
        }
    }
}
$packagesInclDependencies | % {
    $Package              = $_.Package
    [PSCustomObject]@{
        Package           = $_.Package          
        PackageVersion    = $_.PackageVersion 
        RebuiredBy        = $packagesInclDependencies | where Dependency -eq $Package | % {
                                $_.Package
                            }  
        Dependency        = $packagesInclDependencies | where Package    -eq $Package | % { 
                                $DependencyVersion =  $string
                                "$($_.Dependency)  [[[[[$($_.DependencyVersion)]]]]]"  -replace '\[+(\[[^[\]]*])\]+', '$1' -replace '^  \[\]', '' -replace '  \[\]', ''

                            } 
    }
} | ft 


$packagesRaw = Get-ChildItem C:\ProgramData\chocolatey\lib\ -Recurse *.nuspec | select fullname,name 
$packagesInclDependencies = $packagesRaw | % {
	[XML]$xml=get-content $_.fullname
    [PSCustomObject]@{
        Package           = $xml.package.metadata.id
        PackageVersion    = $xml.package.metadata.version
        DependencyID      = $xml.package.metadata.dependencies.dependency | % {
                                $("$($_.id)")
                            }
        Dependency        = $xml.package.metadata.dependencies.dependency | % {
                                $("$($_.id)  [[$($_.version)]]" -replace '\[+(\[[^[\]]*])\]+', '$1' -replace '^  \[\]', '' -replace '  \[\]', '')
                            }
        }
    }
$packagesInclDependencies | % {
    $Package              = $_.Package
    [PSCustomObject]@{
        Package           = $_.Package          
        PackageVersion    = $_.PackageVersion 
        DependencyID = $_.DependencyID
        RebuiredBy        = $packagesInclDependencies | % {
                                $_.DependencyID -contains $Package 
                                    }
                                }
                             
#        Dependency        = $_.Dependency
    
} | ft 