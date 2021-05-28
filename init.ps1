$json = (Invoke-WebRequest -Uri "https://vault.whalewave.net:8200/v1/sys/init" -Method POST -Body (Get-Content .\request.json)).Content;
$data = ($json | ConvertFrom-Json -AsHashtable);
$json | Out-File -FilePath .\answer.json;
$encryptedShard = $data.keys_base64[0];
$encryptedRootToken = $data.root_token;
$encryptedShard | Out-File -FilePath base64-encrypted-shard.txt;
$encryptedRootToken | Out-File -FilePath base64-encrypted-root-token.txt;
openssl base64 --d --in .\base64-encrypted-root-token.txt --out encrypted-root-token.txt
openssl base64 --d --in .\base64-encrypted-shard.txt --out encrypted-shard.txt
$rootToken = keybase pgp decrypt --infile .\encrypted-root-token.txt;
$shard = keybase pgp decrypt --infile .\encrypted-shard.txt;

Write-Host -ForegroundColor Green "Root Token : $rootToken";
Write-Host -ForegroundColor Green "Shard      : $shard";