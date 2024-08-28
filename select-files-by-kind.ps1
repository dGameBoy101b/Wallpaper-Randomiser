Function Select-FilesByKind {
	<#
	.SYNOPSIS
	Selects files that match the specified kind

	.PARAMETER Kind
	The filetype pattern to match

	.EXAMPLE
	Get-ChildItem -Path C:\Pictures -Name | Select-FilesByType -Kind *image
	Outputs the names of all image files (e.g. .png, .jpg, etc) in the "Pictures" directory.

	.INPUTS
	The file paths to filter

	.OUTPUTS
	The files paths that match the kind pattern

	.LINK
	https://www.reddit.com/r/PowerShell/comments/hchq59/comment/fvfd5fg/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
	#>

	param (
		[parameter(Mandatory)]
		[SupportsWildcards()]
		[string]$Kind,
		[parameter(Mandatory, ValueFromPipeline)]
		[string[]]$Paths
	)

	process
	{
		foreach ($path in $Paths)
		{
			Write-Debug "checking path: $path"
			$extension = ".$(($path -split "\.")[-1])"
			Write-Debug "found extension: $extension"
			$extension_registry = Get-ItemProperty "Registry::HKEY_Classes_root\$extension"
			$type = $extension_registry."(default)"
			Write-Debug "found type: $type"
			$type_registry = Get-ItemProperty "Registry::HKEY_Classes_root\$type"
			$path_kind = $type_registry."(default)"
			Write-Debug "found kind: $path_kind"
			Write-Debug "kind pattern: $Kind"
			if ($path_kind -like $Kind)
			{
				Write-Output $path
			}
		}
	}
}