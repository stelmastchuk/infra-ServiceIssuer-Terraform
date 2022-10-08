data "aws_iam_role" "this" {
  name = "Ec2-secrets"
}


resource "aws_instance" "instanci_1" {
  depends_on = [
    aws_db_instance.db
  ]
  ami                         = "ami-0f924dc71d44d23e2"
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  subnet_id                   = aws_subnet.this["pub_a"].id
  availability_zone           = "${var.aws_region}a"
  iam_instance_profile        = data.aws_iam_role.this.name

  user_data = <<-EOF
  #! /bin/bash
  sudo yum -y update
  sudo yum install git -y
  curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash 
  sudo yum install -y nodejs
  sudo yum -y install gcc-c++ make
  curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
  sudo yum -y install yarn
  cd /home/ec2-user
  sudo git clone https://github.com/stelmastchuk/issuerService app
  cd app
  sudo yarn
  export DATABASE_URL="mysql://vadmin:3784563vi@${aws_db_instance.db.endpoint}/issuerDatabase"
  npx prisma migrate deploy
  sudo yarn build
  sudo npm install pm2 -g
  export DATABASE_URL="mysql://vadmin:3784563vi@${aws_db_instance.db.endpoint}/issuerDatabase"
  pm2 start dist/main.js
  EOF

  tags = merge(local.common_tags, { Name = "App1" })
}

resource "aws_instance" "instanci_2" {
  depends_on = [
    aws_db_instance.db
  ]
  ami                         = "ami-0f924dc71d44d23e2"
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  subnet_id                   = aws_subnet.this["pub_b"].id
  availability_zone           = "${var.aws_region}b"
  iam_instance_profile        = data.aws_iam_role.this.name

  user_data = <<-EOF
  #! /bin/bash
  sudo yum -y update
  sudo yum install git -y
  curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash 
  sudo yum install -y nodejs
  sudo yum -y install gcc-c++ make
  curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
  sudo yum -y install yarn
  cd /home/ec2-user
  sudo git clone https://github.com/stelmastchuk/issuerService app
  cd app
  sudo yarn
  export DATABASE_URL="mysql://vadmin:3784563vi@${aws_db_instance.db.endpoint}/issuerDatabase"
  npx prisma migrate deploy
  sudo yarn build
  sudo npm install pm2 -g
  export DATABASE_URL="mysql://vadmin:3784563vi@${aws_db_instance.db.endpoint}/issuerDatabase"
  pm2 start dist/main.js
  EOF

  tags = merge(local.common_tags, { Name = "App2" })
}
