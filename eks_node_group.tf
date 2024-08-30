resource "aws_instance" "kubectl-server" {
  ami                         = "ami-06ca3ca175f37dd66"
  key_name                    = "EKSKEYPAIR"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-1.id
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  tags = {
    Name = "kubectl"
  }
}

resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "pc-node-group"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  capacity_type   = "ON_DEMAND"
  disk_size       = "20"
  instance_types  = ["t2.small"]
  remote_access {
    ec2_ssh_key               = "EKSKEYPAIR"
    source_security_group_ids = [aws_security_group.allow_tls.id]
  }
  labels = tomap({ env = "dev")} }

