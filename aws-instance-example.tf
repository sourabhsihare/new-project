resource "aws_security_group" "http-group" {
  name = "http-access-group"
  description = "Allow traffic on port 80 (HTTP)"

  tags = {
    Name = "HTTP Inbound Traffic Security Group"
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "all-outbound-traffic" {
  name = "all-outbound-traffic-group"
  description = "Allow traffic to leave the AWS instance"

  tags = {
    Name = "Outbound Traffic Security Group"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "ssh-group" {
  name = "ssh-access-group"
  description = "Allow traffic to port 22 (SSH)"

  tags = {
    Name = "SSH Access Security Group"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
resource "aws_instance" "web1" {
  ami = "${lookup(var.ami_id, var.region)}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "${aws_security_group.http-group.id}",
    "${aws_security_group.ssh-group.id}",
    "${aws_security_group.all-outbound-traffic.id}",
  ]
  key_name = "${var.key_name}"
  user_data = <<EOT
#cloud-config
# update apt on boot
package_update: true
# install nginx
packages:
- nginx
write_files:
- content: |
    <!DOCTYPE html>
    <html> 
      <head> 
<title>Hello World</title> 
</head> 
<body> 
<h1>Hello World!</h1> 
</body> 
</html>
  path: /usr/share/app/index.html
  permissions: '0644'
runcmd:
- cp /usr/share/app/index.html /usr/share/nginx/html/index.html
EOT
}