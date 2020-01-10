$username = "monitoring"
  $password = ConvertTo-SecureString "password"-AsPlainText -Force
  $cache:dataSource = 'server'
  $cache:database = 'database'
  $cache:cred = New-Object System.Management.Automation.PSCredential ($username, $password)