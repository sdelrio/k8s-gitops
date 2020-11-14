
from diagrams import Diagram, Cluster, Edge

from diagrams.onprem.compute import Server
from diagrams.onprem.network import Nginx
from diagrams.onprem.network import Internet

from diagrams.gcp.network import LoadBalancing

from diagrams.aws.security import CertificateManager
from diagrams.aws.storage import Backup

from diagrams.k8s.compute import Pod
from diagrams.k8s.storage import PV
from diagrams.k8s.storage import PVC

from diagrams.aws.storage import S3


def main():

    graph_attr = {
        "fontsize": "45",
        "bgcolor": "white"
    }

    with Diagram("Deployment-0", graph_attr=graph_attr,
                 show=False, filename="img/deployment-0",
                 outformat="svg", direction="LR"):

        with Cluster("Backup"):
            velero = Backup("Velero")
        with Cluster("Storage"):
            with Cluster("OpeneEBS"):
                with Cluster("node from pod"):
                    node = Server("node n")
                with Cluster("Pod + Volume"):
                    hostpath = Pod("openebs-hostpath")
                    hostpath_pv = PV("LocalPV")
                    hostpath >> PVC("claim") >> hostpath_pv >> Edge(color="darkred") >> node
                    hostpath >> node
                velero >> Edge(color="darkred", style="dashed") << hostpath_pv
            with Cluster("Longhorn"):
                with Cluster("Storage nodes"):
                    nodes = [
                        Server("node-3"),
                        Server("node-2"),
                        Server("node-1")
                    ]
                with Cluster("Pod + Volume"):
                    longhorn = Pod("longhorn")
                    longhorn_pv = PV("Replicated")
                    longhorn >> PVC("claim") >> longhorn_pv >> Edge(color="blue") >> nodes
                velero >> Edge(color="blue", style="dashed") << longhorn_pv

        with Cluster("Internet"):
            internet = Internet("HTTP clients")
            certprovider = Internet("Cert provider")
        lan = Server("LAN")
        s3 = S3("S3")
        s3 >> Edge(color="blue") << velero
        with Cluster("Ingress"):
            with Cluster("MetalLB"):
                metallb1 = LoadBalancing("IP1")
                metallb2 = LoadBalancing("IP2")
                certprovider >> Edge(color="darkred") >> metallb1
            with Cluster("NGINX"):
                ingress_ext = Nginx("External")
                ingress_int = Nginx("Internal")
            with Cluster("Certificates"):
                certmanager = CertificateManager("cert-manager")
                certissuer = CertificateManager("cert-issuer")
                certmanager >> certissuer
            ingress_ext >> Edge(color="red", label="acme") >> certmanager
            ingress_ext << Edge(color="red", label="cert-secret") << certmanager

            internet >> Edge(color="blue") >> metallb1 >> Edge(color="darkgreen") >> ingress_ext
            certprovider << Edge(color="red", style="dashed", label="http-01") << certissuer

            lan >> Edge(color="blue") >> metallb2 >> Edge(color="darkgreen") >> ingress_int
