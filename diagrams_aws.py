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
from diagrams.aws.general import User

from diagrams.aws.network import VPC

with Diagram("Secure Remote Worker Environment", show=False):
        User("End User")
        with Cluster("VPC - 10.10.0.0/16"):
                DirectoryService("Directory demo.local")
                workspace = Workspaces("WorkSpace")
                Fsx("FSx")
