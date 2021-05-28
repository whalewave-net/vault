$env:VAULT_ADDR="http://192.168.0.5:8200";
vault login;

# Client Key Signing

vault secrets enable ssh;
vault write ssh/config/ca generate_signing_key=true;
vault write ssh/roles/shellwhale "@ssh-role-shellwhale.json";

# Host Key Signing

vault secrets enable --path=ssh-host-signer ssh;
vault write ssh-host-signer/config/ca generate_signing_key=true;
vault secrets tune --max-lease-ttl=87600h ssh-host-signer;
vault write ssh-host-signer/roles/local-server key_type=ca ttl=87600h allow_host_certificates=true allowed_domains="localdomain,whalewave.net" allow_subdomains=true
vault write ssh-host-signer/sign/local-server cert_type=host public_key=@/etc/ssh/ssh_host_rsa_key.pub
vault write --field=signed_key ssh-host-signer/sign/local-server cert_type=host public_key=@/etc/ssh/ssh_host_rsa_key.pub > /etc/ssh/ssh_host_rsa_key-cert.pub
chmod 0640 /etc/ssh/ssh_host_rsa_key-cert.pub