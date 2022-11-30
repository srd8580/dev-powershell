function Expand-MsgAttachment
{
    [CmdletBinding()]

    Param
    (
        [Parameter(ParameterSetName="Path", Position=0, Mandatory=$True)]
        [String]$Path
    )

    Begin
    {
        # Load application
        Write-Verbose "Loading Microsoft Outlook..."
        $outlook = New-Object -ComObject Outlook.Application
    }

    Process
    {
        $files = Get-ChildItem -Path $Path
        
        $files | % {
            # Work out file names
            $msgFn = $_.FullName

            # Skip non-.msg files
            if ($msgFn -notlike "*.msg" -and $msgFn -notlike "*.eml") {
                Write-Verbose "Skipping $_ (not an .msg file)..."
                return
            }

            # Extract message body
            Write-Verbose "Extracting attachments from $_..."
            $msg = $outlook.CreateItemFromTemplate($msgFn)
            $msg.Attachments | % {
                # Work out attachment file name
                $attFn = $msgFn -replace '\.msg$', " - Attachment - $($_.FileName)"

                # Do not try to overwrite existing files
                if (Test-Path -literalPath $attFn) {
                    Write-Verbose "Skipping $($_.FileName) (file already exists)..."
                    return
                }

                # Save attachment
                Write-Verbose "Saving $($_.FileName)..."
                $_.SaveAsFile($attFn)

                # Output to pipeline
                Get-ChildItem -LiteralPath $attFn
            }
        }
    }

    End
    {
        Write-Verbose "Done."
    }
}