Function Set-RandomWallpaper
{
	<#
	.SYNOPSIS
	Randomise the wallpaper of the current user

	.PARAMETER Path
	The directory recursively searched to source wallpaper images

	.Parameter Style
	The style used for the new wallpaper

	.EXAMPLE
	Randomise-Wallpaper -Path C:\Pictures\Wallpapers
	Picks an image from the Wallpapers directory and sets it as the current user's wallpaper

	.EXAMPLE
	Randomise-Wallpaper -Path C:\Pictures\Wallpapers -Style Fit
	Picks an image from the Wallpapers directory and sets it as the current user's wallpaper using the fit style which may result in black bars around it

	.OUTPUTS
	Path to the set wallpaper

	.FORWARDHELPTARGETNAME Set-Wallpaper
	#>

	param(
		[parameter(Mandatory)]
		[string]$Path,
		[parameter()]
		[string]$Style = "Fill"
	)

	Import-Module $PSScriptRoot/Select-FilesByKind.psm1
	Write-Debug "searching for wallpapers: $Path"
	$wallpapers = Get-ChildItem -Path $Path -Recurse -Name -File | Select-FilesByKind -Kind "*Image"
	Write-Debug "found wallpapers: $wallpapers"

	$wallpaper = Get-Random -InputObject $wallpapers
	Write-Debug "randomly selected wallpaper: $wallpaper"

	$path = ((Join-Path $Path $wallpaper) | Resolve-Path).Path
	Write-Debug "resolved wallpaper path: $path"

	Import-Module $PSScriptRoot/Set-Wallpaper.psm1
	Set-WallPaper -Image $path -Style $Style
	Write-Debug "set wallpaper with style: $Style"

	return $path
}