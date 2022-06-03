module "vpc" {
    source = "../../../modules/vpc"
    vpcName = "rahkat VPC 1"
    vpcCIDRblock="10.1.0.0/16"
    subnetCIDRblock_public="10.1.1.0/24"
    subnetCIDRblock_private="10.1.2.0/24"
    region="eu-west-1"
    availabilityZone="eu-west-1a"
}