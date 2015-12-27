resource "aws_autoscaling_group" "livegrep_frontend" {
  availability_zones = ["${aws_subnet.default.availability_zone}"]
  vpc_zone_identifier = ["${aws_subnet.default.id}"]

  name = "livegrep-frontend"
  max_size = 1
  min_size = 1
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.livegrep_frontend.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "livegrep_frontend" {
  image_id = "ami-38796759"
  instance_type = "t2.micro"
  key_name = "nelhage-1"

  lifecycle {
    create_before_destroy = true
  }


  security_groups = [
    "${aws_security_group.base.id}",
    "${aws_security_group.livegrep_frontend.id}"
  ]

  iam_instance_profile = "${aws_iam_instance_profile.livegrep_frontend.arn}"

  user_data = <<EOF
#!/bin/sh
set -eux
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
echo 'localhost ansible_connection=local' > /etc/ansible/hosts
ansible-pull -e 'role=livegrep-web' -U https://github.com/nelhage/livegrep.com/ ansible/livegrep.yml
EOF
}

resource "aws_autoscaling_group" "livegrep_backend_linux" {
  availability_zones = ["${aws_subnet.default.availability_zone}"]
  vpc_zone_identifier = ["${aws_subnet.default.id}"]
  name = "livegrep-backend-linux"
  max_size = 1
  min_size = 1
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.livegrep_backend_linux.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "livegrep_backend_linux" {
  image_id = "ami-38796759"
  instance_type = "t2.small"
  key_name = "nelhage-1"

  security_groups = [
    "${aws_security_group.base.id}",
    "${aws_security_group.livegrep_backend.id}"
  ]

  iam_instance_profile = "${aws_iam_instance_profile.livegrep_backend.arn}"

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<EOF
#!/bin/sh
set -eux
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
echo 'localhost ansible_connection=local' > /etc/ansible/hosts
ansible-pull -e 'role=livegrep-index' -e 'livegrep_index=linux' -U https://github.com/nelhage/livegrep.com/ ansible/livegrep.yml
EOF

  lifecycle {
    create_before_destroy = true
  }
}
