Create an SSH secret engine
```
vault secrets enable ssh
```

Allow longer certificate expiration date
```
vault secrets tune -max-lease-ttl=87600h ssh
```
Create a certificate autority for SSH
```
vault write ssh/config/ca generate_signing_key=true
```

Create a role for clients named with a user named "shellwhale"
```
vault write ssh/roles/shellwhale "@ssh-role-shellwhale.json"
```

Create a role for SSH servers
```
vault write ssh/roles/server "@ssh-role-server.json"
```


Ask Vault to give your user a temporary login certificate [Windows]
```
vault write -field=signed_key ssh/sign/shellwhale public_key="@$HOME\.ssh\id_rsa.pub" > ~\.ssh\id_rsa-cert.pub
```

Ask Vault to give your user a temporary login certificate [Linux]
```
vault write -field=signed_key ssh/sign/shellwhale public_key=@$HOME/.ssh/id_rsa.pub > signed-cert.pub
```

Generate a missing public key
```
ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
```

Connect from Linux
```
rm -rf ~/.ssh/signed-cert.pub && vault write -field=signed_key ssh/sign/shellwhale public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/signed-cert.pub && ssh -i  ~/.ssh/signed-cert.pub -i ~/.ssh/id_rsa shellwhale@infallible-shirley.whalewave.net
```

```
sudo rm -rf ~/.ssh/id_rsa-cert.pub && vault write -field=signed_key ssh/sign/shellwhale public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub && ssh shellwhale@infallible-shirley.whalewave.net && chmod 400 ~/.ssh/id_rsa.pub  && ansible -m ping all --private-key=~/.ssh/id_rsa-cert.pub --inventory inventory.ini --user shellwhale
```
