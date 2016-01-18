resource "aws_autoscaling_group" "livegrep_frontend" {
  availability_zones = ["${aws_subnet.default.availability_zone}"]
  vpc_zone_identifier = ["${aws_subnet.default.id}"]

  name = "livegrep-frontend"
  min_size = 1
  desired_capacity = 1
  max_size = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.livegrep_frontend.name}"

  tag {
    key = "role"
    value = "livegrep-web"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "livegrep_frontend_user_data" {
  template = "${file("user-data.tpl")}"
  vars = {
    s3_bucket = "${var.s3_bucket}"
    role = "livegrep-web"
    extra_args = ""
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "livegrep_frontend" {
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  key_name = "nelhage-1"

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${template_file.livegrep_frontend_user_data.rendered}"

  security_groups = [
    "${aws_security_group.base.id}",
    "${aws_security_group.livegrep_frontend.id}"
  ]

  iam_instance_profile = "${aws_iam_instance_profile.livegrep_frontend.arn}"

  user_data = <<EOF
EOF
}

resource "aws_autoscaling_group" "livegrep_backend_linux" {
  availability_zones = ["${aws_subnet.default.availability_zone}"]
  vpc_zone_identifier = ["${aws_subnet.default.id}"]
  name = "livegrep-backend-linux"
  min_size = 1
  desired_capacity = 1
  max_size = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.livegrep_backend_linux.name}"

  tag {
    key = "role"
    value = "livegrep-index"
    propagate_at_launch = true
  }
  tag {
    key = "livegrep_index"
    value = "linux"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "livegrep_backend_linux_user_data" {
  template = "${file("user-data.tpl")}"
  vars = {
    s3_bucket = "${var.s3_bucket}"
    role = "livegrep-index"
    extra_args = "-e livegrep_index=linux"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "livegrep_backend_linux" {
  image_id = "${lookup(var.amis, var.region)}"
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

  user_data = "${template_file.livegrep_backend_linux_user_data.rendered}"

  root_block_device {
    volume_size = 12
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "livegrep_backend_github_user_data" {
  template = "${file("user-data.tpl")}"
  vars = {
    s3_bucket = "${var.s3_bucket}"
    role = "livegrep-index"
    extra_args = "-e livegrep_index=github"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "livegrep_backend_github" {
  availability_zones = ["${aws_subnet.default.availability_zone}"]
  vpc_zone_identifier = ["${aws_subnet.default.id}"]
  name = "livegrep-backend-github"
  min_size = 0
  desired_capacity = 0
  max_size = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.livegrep_backend_github.name}"

  tag {
    key = "role"
    value = "livegrep-index"
    propagate_at_launch = true
  }
  tag {
    key = "livegrep_index"
    value = "github"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "livegrep_backend_github" {
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "t2.large"
  key_name = "nelhage-1"

  security_groups = [
    "${aws_security_group.base.id}",
    "${aws_security_group.livegrep_backend.id}"
  ]

  iam_instance_profile = "${aws_iam_instance_profile.livegrep_backend.arn}"

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${template_file.livegrep_backend_github_user_data.rendered}"

  root_block_device {
    volume_size = 30
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ebs_volume" "indexer_cache" {
  availability_zone = "${aws_subnet.default.availability_zone}"
  size = 120
  type = "gp2"
  tags {
    Name = "livegrep-indexer-cache"
  }
}
