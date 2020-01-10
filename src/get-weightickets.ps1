function get-weightickets {
    if ($Session:Site -Ne $null -and $Session:Site -ne " " -and $Session:Site -ne "") {
        New-UDHeading  -Text "Showing weightickets for $($Session:Site)"
    }
    else {
        New-UDHeading  -Text "Waiting for selection..."
    }
}