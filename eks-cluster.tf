provider "kubernetes" {
    host = data.aws_eks_cluster.voteapp-cluster.endpoint
    token = data.aws_eks_cluster_auth.voteapp-cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.voteapp-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "voteapp-cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "voteapp-cluster" {
    name = module.eks.cluster_id
}

module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "19.19.1"

    cluster_name = "voteapp-eks-cluster"
    cluster_version = "1.18"


    subnet_ids = module.voteapp-vpc.private_subnets
    vpc_id = module.voteapp-vpc.vpc_id

    tags = {
        Environment = "dev"
        Project     = "voteapp"
    }

    
    self_managed_node_groups = [
        {
            name                          = "voteapp-eks-worker-group"
            launch_template_name   = "voteapp-eks-worker-group"
            instance_type                 = "t2.micro"
            asg_desired_capacity          = 3 
        }
    ]
}