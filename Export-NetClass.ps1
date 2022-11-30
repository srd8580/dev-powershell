#creates a .NET class from a database table

function Get-NetType($sqlType, $isNullable) {
    $type = $sqlType
    
    #massage sql data types 
    if ($type.ToUpper() -eq "BIGINT") {
        $type = "long"
    }
    elseif ($type.ToUpper() -eq "VARCHAR" -or $type -eq "NVARCHAR" -or $type -eq "CHAR" -or $type -eq "NCHAR") {
        $type = "string"
    }
    elseif ($type.ToUpper() -eq "TINYINT") {
        $type = "byte"
    }
    elseif ($type.ToUpper() -eq "SMALLINT") {
        $type = "short"
    }
    elseif ($type.ToUpper() -eq "BIT") {
        $type = "bool"
    }
    elseif ($type.ToUpper() -eq "DATETIME" -or $type.ToUpper() -eq "DATETIME2" -or $type.ToUpper() -eq "DATE") {
        $type = "DateTime"
    }
    else {
        $type = $type.ToLower()
    }

    if ($isNullable.ToUpper() -eq "YES" -and $type -ne "string") {
        $type = "$($type)?"
    }

    Write-Output $type
}

function Export-NetClass () {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$TableName,

        [Parameter(Mandatory = $false)]    
        [string]$DBName = "master",

        [Parameter(Mandatory = $false)]
        [string]$ClassName,    

        [Parameter(Mandatory = $false)]
        [string]$ServerInstance = "(local)",
        
        [Parameter(Mandatory = $false)]
        [string]$UserName = "sa",

        [Parameter(Mandatory = $false)]
        [string]$Password = "password"
    )

    if ([string]::IsNullOrEmpty($ClassName)) {
        $ClassName = $TableName
    }

    $columnSchemas = Invoke-SqlCmd -ServerInstance $ServerInstance -UserName $UserName -Password $Password -Database $DBName -Query "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_CATALOG = '$DBName' AND TABLE_NAME = '$TableName'" 

    Write-Host ""
    Write-Host "public class $ClassName"
    Write-Host "{"

    $columnSchemas | %{
        $typeName = (Get-NetType $_.DATA_TYPE $_.IS_NULLABLE)
        Write-Host "`tpublic $typeName $($_.COLUMN_NAME) { get; set; }"
    }
    Write-Host "}"
}