# dev-powershell
Powershell cmdlets for developer usage

# Contents
## Export-NetClass
- simple cmdlet to export a .NET class from a Database table.  Eliminates the need for heavyweight EF classes, projects and solutions.
- USAGE: 
  - `Export-NetClass -Table MyTable -ServerInstance "localhost" -DbName MyDatabase -ClassName MyClass -UserName sa -Password xxxx > MyClass.cs`

## Expand-MsgAttachment
- cmdlet that uses Office interop to break attachments out of a saved MSG file.
- USAGE:
  `Expand-MsgAttachment -Path .\MsgFilePath`
  
