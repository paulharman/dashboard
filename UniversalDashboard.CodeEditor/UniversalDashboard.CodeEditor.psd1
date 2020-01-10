#
# Module manifest for module 'UniversalDashboard.CodeEditor'
#
# Generated by: Adam Driscoll
#
# Generated on: 12/20/2019
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'UniversalDashboard.CodeEditor.psm1'

# Version number of this module.
ModuleVersion = '1.0.1'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'a7ee4395-28a2-4b52-9d9b-19e87acde964'

# Author of this module
Author = 'Adam Driscoll'

# Company or vendor of this module
CompanyName = 'Ironman Software, LLC'

# Copyright statement for this module
Copyright = '2019 Ironman Software, LLC'

# Description of the functionality provided by this module
Description = 'Code editor control for Universal Dashboard. This controls requires a Universal Dashboard Enterprise license.'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'New-UDCodeEditor'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = '*'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'universaldashboard', 'monaco', 'code', 'ud-control', 'ud-licensed'

        # A URL to the license for this module.
        LicenseUri = 'https://poshtools.com/universal-dashboard-license/'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/ironmansoftware/ud-codeeditor'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/ironmansoftware/universal-dashboard/master/images/logo.png'

        # ReleaseNotes of this module
        ReleaseNotes = 'Added support for loading license from environment variable.'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

