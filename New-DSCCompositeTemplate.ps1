Function New-DSCCompositeTemplate {

    <#
        .Synopsis
            Creates a new DSC Resource Folder structure

        .Description
            Creates a new DSC Resource Folder Structure.  The structure looks like this

            ModuleName
                |
                ----- DSCResource
                |         |
                |         ----- Resource
                |                   |
                |                   ----- Resource.psd1
                |                   |
                |                   ----- Resource.Schemal.psm1
                |
                ----- ModuleName.psd1

        .EXAMPLE
            Creates a new DSC Resource
            
            New-DscCompositeTemplate -RootPath "C:\TestModules" -ModuleName "Wakka" -ResourceName "Foo"

        .EXAMPLE
            Adds a Resource to an existing MOdule structure

            New-DscCompositeTemplate -RootPath "C:\TestModules" -ModuleName "Wakka" -ResourceName "FooYoo"

        .Link
            I modified Ashley McGlone's script to work for my situation.

            https://blogs.technet.microsoft.com/ashleymcglone/2015/02/25/helper-function-to-create-a-powershell-dsc-composite-resource/

        .Note
            Author : Jeff Buenting
            Date : 2016 Dec 15
    #>

    [CmdletBinding()]
    Param (
        [String]$RootPath = 'c:\dscscripts',

        [Parameter ( Mandatory = $True ) ]
        [String]$ModuleName,

        [String]$Resource = $ModuleName
    )

    Process {
        # ----- Create the Resources folder structure

        if ( -Not (Test-Path -Path $RootPath\$ModuleName) ) { 
            
            # ----- Path does not exist so build structure
            Write-Verbose "Creating resource structure $Rootpath\$ModuleName"
            New-Item -Path $RootPath\$ModuleName\DSCResource -ItemType Directory

            Write-Verbose 'Creating module manifest'
            New-ModuleManifest -Path $RootPath\$ModuleName\$ModuleName.psd1       
        }

        # ----- Create new Resource inside module folder
        if ( Test-Path -Path $RootPath\$ModuleName\DSCResource\$Resource ) { Throw "New-DSCCompositeTemplate : Resource already exists" }

        New-Item -Path $RootPath\$ModuleName\DSCResource\$Resource -ItemType Directory

        Write-Verbose 'Creating Resource File'
        New-item -path $RootPath\$ModuleName\DSCResource\$Resource\$Resource.Schema.psm1
        
        Write-Verbose 'Creating Resource Manifest'
        New-ModuleManifest -Path $RootPath\$ModuleName\DSCResource\$Resource\$Resource.psd1 -RootModule "$($Resource).Schema.psm1" -verbose

    }
}

