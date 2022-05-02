module "fossa_jobstreet_com" {
  #source = "../_modules/cmd-tf-aws-ec2"
  source = "s3::https://central-terraform-modules-734282799255.s3.ap-southeast-1.amazonaws.com/beta/1.0.6/aws-ec2-ver1-.zip"

  instance_name = "fossa.jobstreet.com"
  instance_type = "t2.large"
  ami_id        = "ami-02afe775b5a1c031f"

  vpc_id    = "vpc-05dfbbb608bc2da00"
  subnet_id = "subnet-03820ca9bc480192c"

  user_data = ""

  ebs_optimized = "false"

  enable_ec2_autorecovery = false

  root_block_device = {
    delete_on_termination = false
    volume_type = "gp3"
    volume_size = 50
    iops = 3500
    throughput = 150
    encrypted   = true
    kms_key_id  = "arn:aws:kms:ap-southeast-1:734282799255:key/91e91111-2bc8-4b0c-a8cb-ad4ea0967d0b"
  }

  ebs_block_devices = [
  ]

  create_security_group         = false
  additional_security_group_ids = [data.aws_security_group.common-linux-sg.id, data.aws_security_group.siva-rc-web-sg.id]

  custom_instance_profile_name = "SeekBasicEc2SSMInstanceProfile"

  tags = local.tags

  instance_tags = {
		"AWSApplicationMigrationServiceManaged" = "mgn.amazonaws.com"
		"AWSApplicationMigrationServiceSourceServerID" = "s-9d88fd5d9786c7326"
    "map-migrated" = "fossa.jobstreet.com"
  }

  volume_tags = {
    "AWSApplicationMigrationServiceSourceServerID" = "s-9d88fd5d9786c7326"
		"Name" = "fossa.jobstreet.com"
		"AWSApplicationMigrationServiceManaged" = "mgn.amazonaws.com"
  }

}
	
