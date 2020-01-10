New-UDPage  -Name "Test - ignore"  -AuthorizationPolicy "IT" -Icon link -Content {
    New-UDCard -id clear -Content {
        New-UDRow -Columns {
            New-UDColumn -id 'testcolumn' -Size 12 -Endpoint  {
                New-UDHeading -Text "Logged in as $User.Identity.Name"
            }
        }
    }
}