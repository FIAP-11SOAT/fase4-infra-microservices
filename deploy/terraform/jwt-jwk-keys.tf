resource "tls_private_key" "jwt_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "jose_jwk" "rsa_jwk" {
  kid        = "${local.project_name}-jwk"
  alg        = "RS256"
  use        = "sig"
  public_key = tls_private_key.jwt_key.public_key_pem
}