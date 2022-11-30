# dev-powershell
Powershell cmdlets for developer usage

# Contents
## Export-NetClass
- simple cmdlet to export a .NET class from a Database table.  Eliminates the need for heavyweight EF classes, projects and solutions.
- USAGE: 
  - `Export-NetClass -Table MyTable -ServerInstance "localhost" -DbName MyDatabase -ClassName MyClass -UserName sa -Password xxxx > MyClass.cs`
