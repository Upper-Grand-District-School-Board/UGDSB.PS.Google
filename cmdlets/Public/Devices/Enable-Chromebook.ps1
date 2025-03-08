function Enable-Chromebook{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)][string]$deviceID
  )
  # Ensure that they have a access token
  if(-not $script:googleAccessToken){
    throw "Please ensure that you have called Get-GoogleAccessToken cmdlet"
  }  
  # Confirm we have a valid access token
  if(-not $(Test-GoogleAccessToken)){
    Get-GoogleAccessToken -private_key $script:googlePK -client_email $script:googleClientEmail -customerid  $script:googleCustomerId -scopes $script:googleScopes
  }  
  # Generate the final API endppoint URI
  $endpoint = "admin/directory/v1/customer/$($script:googleCustomerId)/devices/chromeos/$($deviceID)/action"
  $body = @{
    "action" = "reenable"
  }
  try{
    $result = Get-GoogleAPI -Method "POST" -endpoint $endpoint -Body $body
    if($null -ne ($result.tostring() | COnvertFrom-JSON).error){
      throw ($result.tostring() | COnvertFrom-JSON).error.message
    }
    Write-Verbose "Status Result: $($result.StatusCode)"    
  }
  catch{
    throw $_
  }
}