function Get-GoogleOU{
  [CmdletBinding()]
  [OutputType([System.Collections.Generic.List[PSCustomObject]])]
  param(
    [Parameter()][ValidateSet('All','Children','All_Including_Parent')][string]$Type,
    [Parameter()][string]$orgUnitPath
  )
  # Ensure that they have a access token
  if(-not $script:googleAccessToken){
    throw "Please ensure that you have called Get-GoogleAccessToken cmdlet"
  }
  # Confirm we have a valid access token
  if(-not $(Test-GoogleAccessToken)){
    Get-GoogleAccessToken -private_key $script:googlePK -client_email $script:googleClientEmail -customerid  $script:googleCustomerId -scopes $script:googleScopes
  }
  $endpoint = "admin/directory/v1/customer/$($script:googleCustomerId)/orgunits"
  $uriparts = [System.Collections.Generic.List[PSCustomObject]]@()
  if ($PSBoundParameters.ContainsKey("type")) { $uriparts.add("type=$($type)") }
  if ($PSBoundParameters.ContainsKey("orgUnitPath")) { $uriparts.add("orgUnitPath=$($orgUnitPath)") }
  # Generate the final API endppoint URI
  $endpoint = "$($endpoint)?$($uriparts -join "&")"     
  $OrgList = Get-GoogleAPI -endpoint $endpoint -Verbose:$VerbosePreference
  return $orglist.results.organizationUnits
}
