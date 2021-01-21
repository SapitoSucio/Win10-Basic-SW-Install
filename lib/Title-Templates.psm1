function SimpleTitleTemplate ([String] $Text = "TestText") {
	Write-Host "" # Skip line
	Write-Host "<====================< $Text >====================>"
	Write-Host "" # Skip line
}

function BeautyTitleTemplate ([String] $Text = "TestText") {
	Write-Host "" # Skip line
	Write-Host "<====================[ $Text ]====================>"
	Write-Host "" # Skip line
}

function BeautySectionTemplate ([String] $Text = "TestText") {
	Write-Host "" # Skip line
	Write-Host "<==========[ $Text ]==========>"
	Write-Host "" # Skip line
}


function CaptionTemplate ([String] $Text = "TestText") {
	Write-Host "--> $Text"
	Write-Host "" # Skip line
}

function TitleWithContinuousCounter ([String] $Text = "TestTextCOUNTER") {
	if ($null -eq $Counter) {
		# Initialize Global variables
		$Global:Counter = 0
		$Global:MaxNum = 6
	}
	$Global:Counter = $Counter + 1
	SimpleTitleTemplate "( $Counter/$MaxNum ) - [$Text]"
}

# Demo:
# SimpleTitleTemplate -Text "Text"
# BeautyTitleTemplate -Text "Text"
# BeautySectionTemplate -Text "Text"
# CaptionTemplate -Text "Text"
# TitleWithContinuousCounter -Text "Text"