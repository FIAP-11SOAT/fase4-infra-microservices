resource "random_password" "docdb_password" {
  length  = 16
  special = false
}

resource "aws_docdb_subnet_group" "docdb_subnet" {
  name       = "docdb-subnet"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "${local.project_name}-docdb-subnet-group"
  }
}

resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier     = "${local.project_name}-docdb-cluster"
  master_username        = "infra_microservices_user"
  master_password        = random_password.docdb_password.result
  db_subnet_group_name   = aws_docdb_subnet_group.docdb_subnet.name
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]
  engine                 = "docdb"
  engine_version         = "5.0.0"

  tags = {
    Name = "${local.project_name}-docdb-cluster"
  }
}

resource "aws_docdb_cluster_instance" "docdb_instance" {
  count              = 1
  identifier         = "docdb-instance"
  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  instance_class     = "db.t3.medium"
  engine             = "docdb"

  tags = {
    Name = "${local.project_name}-docdb-instance"
  }
}


resource "aws_security_group" "docdb_sg" {
  name   = "${local.project_name}-docdb-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ajuste para sua rede!
  }

  tags = {
    Name = "${local.project_name}-docdb-sg"
  }
}
