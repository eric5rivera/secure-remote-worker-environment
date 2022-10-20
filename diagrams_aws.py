from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS, EKS, Lambda
from diagrams.aws.database import Redshift
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3
from diagrams.aws.enduser import Workspaces
from diagrams.aws.security import DirectoryService
from diagrams.aws.storage import Fsx
from diagrams.aws.network import PrivateSubnet
from diagrams.aws.network import VPCElasticNetworkInterface

with Diagram("Enclave", show=False):
        with Cluster("VPC - Room"):
                VPCElasticNetworkInterface("")
                with Cluster("Private Subnet - us-west-2a"):
                        DirectoryService("Directory demo.local")
                        workspace = Workspaces("Admin WorkSpace")
                        Fsx("FSx")
        with Cluster("Private Subnet - us-west-2b"):
")